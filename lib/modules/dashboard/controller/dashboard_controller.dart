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

  bool isRequestSent(String receiverId) => requestStatus[receiverId] == "pending";

  // -----------------------
  // LIKE / UNLIKE HANDLING
  // -----------------------

  void addLiked(String userId) => likedUsers.add(userId);
  void removeLiked(String userId) => likedUsers.remove(userId);
  bool isLiked(String userId) => likedUsers.contains(userId);

  Future<bool> toggleFavorite(String userId) async {
    final currentlyLiked = isLiked(userId);
    if (currentlyLiked) removeLiked(userId);
    else addLiked(userId);

    try {
      final token = await SharedPrefHelper.getToken();
      if (token == null || token.isEmpty) {
        if (currentlyLiked) addLiked(userId);
        else removeLiked(userId);
        return false;
      }

      final url = Uri.parse("https://chat.bitmaxtest.com/admin/api/users/$userId/like");
      final response = await http.post(url, headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      if (response.statusCode == 200 || response.statusCode == 201) return true;

      // Already liked → unlike
      if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        if (data["message"] != null &&
            data["message"].toString().contains("already liked")) {
          final success = await unlikeUser(userId);
          if (!success) {
            if (currentlyLiked) addLiked(userId);
            else removeLiked(userId);
          }
          return success;
        }
      }

      if (currentlyLiked) addLiked(userId);
      else removeLiked(userId);
      return false;
    } catch (e) {
      if (currentlyLiked) addLiked(userId);
      else removeLiked(userId);
      return false;
    }
  }

  Future<bool> unlikeUser(String userId) async {
    try {
      final token = await SharedPrefHelper.getToken();
      if (token == null || token.isEmpty) return false;

      final url = Uri.parse("https://chat.bitmaxtest.com/admin/api/users/$userId/unlike");
      final response = await http.delete(url, headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        likedUsers.remove(userId);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Handle double-tap like/unlike with animation
  Future<void> handleDoubleTap(String userId) async {
    if (isLiked(userId)) {
      bool success = await unlikeUser(userId);
      if (success) recentlyLikedUsers.remove(userId);
    } else {
      bool success = await toggleFavorite(userId);
      if (success) {
        recentlyLikedUsers.add(userId);
        Future.delayed(const Duration(seconds: 2), () {
          recentlyLikedUsers.remove(userId);
        });
      }
    }
  }
}