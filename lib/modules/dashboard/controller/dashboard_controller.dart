import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/dashboard/model/bestmatch_model.dart';
import 'package:shyeyes/modules/dashboard/model/dashboard_model.dart';
import 'package:shyeyes/modules/profile/model/profile_model.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class ActiveUsersController extends GetxController {
  final AuthRepository _userRepository = AuthRepository();

  /// Observables
  var isLoading = false.obs;
  var activeUserModel = Activeusermodel().obs;
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
      users.value = response.users ?? [];
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

  Future<void> sendRequest(String receiverId) async {
    try {
      requestLoading[receiverId] = true;

      final response = await AuthRepository.sendRequest(receiverId);

      if (response != null && response['request'] != null) {
        final requestId = response['request']['_id'];
        sentRequests[receiverId] = requestId;
        requestStatus[receiverId] = "pending";
        Get.snackbar("Success", "Request sent successfully!");
      } else {
        Get.snackbar("Error", "Failed to send request");
      }
    } finally {
      requestLoading[receiverId] = false;
    }
  }

  Future<void> cancelRequest(String receiverId) async {
    try {
      requestLoading[receiverId] = true;

      final requestId = sentRequests[receiverId];
      if (requestId == null) {
        Get.snackbar("Error", "No request found for this user");
        return;
      }

      final response = await AuthRepository.cancelRequest(requestId);
      if (response != null && response['message'] != null) {
        final message = response['message']!;
        if (message.toLowerCase().contains("cancelled")) {
          requestStatus[receiverId] = "none";
          sentRequests.remove(receiverId);
          Get.snackbar("Success", "Request cancelled");
        } else {
          Get.snackbar("Info", "Could not cancel request");
        }
      }
    } finally {
      requestLoading[receiverId] = false;
    }
  }

  bool isRequestSent(String receiverId) =>
      requestStatus[receiverId] == "pending";

  // -----------------------
  // LIKE / UNLIKE HANDLING
  // -----------------------

  Future<void> toggleFavorite(String userId) async {
    try {
      final token = await SharedPrefHelper.getToken();

      // Check if user is already in liked list
      if (likedUsers.contains(userId)) {
        // Unlike directly
        await _unlikeUser(userId, token.toString());
        return;
      }

      // Try Like API
      final likeUrl = Uri.parse(
        "https://shyeyes-b.onrender.com/api/likes/$userId/like",
      );
      final response = await http.post(
        likeUrl,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        likedUsers.add(userId);
        recentlyLikedUsers.add(userId);
        print(" Like success: ${response.body}");

        // Heart animation thodi der ke liye
        Future.delayed(const Duration(seconds: 1), () {
          recentlyLikedUsers.remove(userId);
        });
      } else {
        final body = response.body;
        print(" Like API response: $body");

        // ager  "already liked" ka error aya, toh unlike call karo
        if (body.contains("Profile already liked")) {
          await _unlikeUser(userId, token.toString());
        } else {
          print(" Like failed: ${response.statusCode} $body");
        }
      }
    } catch (e) {
      print(" Error toggleFavorite: $e");
    }
  }

  Future<void> _unlikeUser(String userId, String token) async {
    try {
      final unlikeUrl = Uri.parse(
        "https://shyeyes-b.onrender.com/api/likes/$userId/unlike",
      );
      final response = await http.delete(
        unlikeUrl,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        likedUsers.remove(userId);
        print(" Unlike success: ${response.body}");
      } else {
        print(" Unlike failed: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print(" Error in unlike: $e");
    }
  }

  bool isLiked(String userId) {
    return likedUsers.contains(userId);
  }
}
