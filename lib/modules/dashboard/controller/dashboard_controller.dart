import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/dashboard/model/bestmatch_model.dart';
import 'package:shyeyes/modules/dashboard/model/dashboard_model.dart';
import 'package:shyeyes/modules/profile/model/current_plan.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class ActiveUsersController extends GetxController {
  final AuthRepository _userRepository = AuthRepository();

  /// Observables
  var isLoading = false.obs;
  var activeUserModel = ActiveUsersModel().obs;
  var errorMessage = "".obs;

  /// Users list
  var users = <Users>[].obs;
  var matches = <BestmatchModel>[].obs;
  var successMessage = "".obs;

  /// Request tracking
  var requestStatus = <String, String>{}.obs; // userId -> status
  var sentRequests = <String, String>{}.obs; // userId -> requestId
  var requestLoading = <String, bool>{}.obs;

  /// Liked users tracking
  var likedUsers = <String>{}.obs; // store liked userIds as String
  var recentlyLikedUsers = <String>{}.obs; // for double-tap animation

  // -----------------------
  // FETCH USERS & MATCHES
  // -----------------------

  /// Fetch Active Users
  Future<void> fetchActiveUsers() async {
    try {
      isLoading.value = true;
      final response = await _userRepository.getActiveUsers();
      activeUserModel.value = response;
      users.value = response.data?.users ?? [];
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch Best Matches
  Future<void> fetchBestMatches() async {
    final String token = await SharedPrefHelper.getToken() ?? 'NULL';
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse("https://shyeyes-b.onrender.com/api/user/matches"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['matches'] != null && decoded['matches'] is List) {
          matches.value = (decoded['matches'] as List)
              .map((e) => BestmatchModel.fromJson(e))
              .toList();
        } else {
          matches.clear();
        }
      } else {
        matches.clear();
      }
    } catch (e) {
      matches.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // -----------------------
  // REQUEST HANDLING
  // -----------------------

  bool isRequestSent(String userId) {
    final status = requestStatus[userId]?.toLowerCase() ?? "cancelled";
    return status == "pending";
  }

  Future<void> sendRequest(String receiverId) async {
    try {
      requestLoading[receiverId] = true;

      final response = await AuthRepository.sendRequest(receiverId);

      if (response != null) {
        final bool sent = response['sent'] ?? false;

        // ✅ Backend se aaya status use karo
        final status = (response['status'] ?? "Cancelled").toLowerCase();
        requestStatus[receiverId] = status;

        if (sent && status == "pending") {
          // request sent hai
          final requestId = response['request']?['_id'];
          if (requestId != null) {
            sentRequests[receiverId] = requestId;
          }

          Get.closeAllSnackbars();
          Get.snackbar(
            "Success",
            "Friend request sent successfully!",
            snackPosition: SnackPosition.TOP,
          );
        } else if (!sent && status == "cancelled") {
          // request cancel hai
          sentRequests.remove(receiverId);

          Get.closeAllSnackbars();
          Get.snackbar(
            "Success",
            "Friend request cancelled successfully!",
            snackPosition: SnackPosition.TOP,
          );
        }
      } else {
        Get.closeAllSnackbars();
        Get.snackbar(
          "Error",
          "Something went wrong",
          snackPosition: SnackPosition.TOP,
        );
      }
    } finally {
      requestLoading[receiverId] = false;
    }
  }

  // Future<void> cancelRequest(String receiverId) async {
  //   try {
  //     requestLoading[receiverId] = true;

  //     final requestId = sentRequests[receiverId];
  //     if (requestId == null) {
  //       Get.snackbar("Error", "No request found for this user");
  //       return;
  //     }

  //     final response = await AuthRepository.cancelRequest(requestId);
  //     if (response != null && response['message'] != null) {
  //       final message = response['message']!;
  //       if (message.toLowerCase().contains("cancelled")) {
  //         requestStatus[receiverId] = "none";
  //         sentRequests.remove(receiverId);
  //         Get.snackbar("Success", "Request cancelled");
  //       } else {
  //         Get.snackbar("Info", "Could not cancel request");
  //       }
  //     }
  //   } finally {
  //     requestLoading[receiverId] = false;
  //   }
  // }

  // Future<void> cancelRequestByRequestId(String requestId) async {
  //   try {
  //     // Optionally show loader in your requestLoading map
  //     requestLoading[requestId] = true;

  //     final response = await AuthRepository.cancelRequest(requestId);
  //     if (response != null && response['message'] != null) {
  //       final message = response['message']!;
  //       if (message.toLowerCase().contains("cancelled")) {
  //         // Remove from your local list
  //         // acceptedRequests.removeWhere((r) => r.id == requestId);
  //         Get.snackbar("Success", "Request cancelled");
  //       } else {
  //         Get.snackbar("Info", "Could not cancel request");
  //       }
  //     }
  //   } finally {
  //     requestLoading[requestId] = false;
  //   }
  // }

  // bool isRequestSent(String receiverId) =>
  //     requestStatus[receiverId] == "pending";

  // -----------------------
  // LIKE / UNLIKE HANDLING
  // -----------------------
  Future<void> toggleFavorite(String userId) async {
    try {
      final token = await SharedPrefHelper.getToken() ?? '';

      // Toggle API URL
      final uri = Uri.parse(
        "https://shyeyes-b.onrender.com/api/likes/$userId/like",
      );

      final response = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("Toggle Favorite response code: ${response.statusCode}");
      print("Toggle Favorite response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final liked = data['liked'] ?? false;

        // Update likedUsers set based on backend response
        if (liked) {
          likedUsers.add(userId);
          recentlyLikedUsers.add(userId);

          // Heart animation thodi der ke liye
          Future.delayed(const Duration(seconds: 1), () {
            recentlyLikedUsers.remove(userId);
          });
        } else {
          likedUsers.remove(userId);
        }

        // Optional: Show snackbar
        Get.snackbar(
          "Success",
          liked ? "Profile liked" : "Profile unliked",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        print("Toggle failed: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("Error in toggleFavorite: $e");
    }
  }

  bool isLiked(String userId) {
    return likedUsers.contains(userId);
  }
}
