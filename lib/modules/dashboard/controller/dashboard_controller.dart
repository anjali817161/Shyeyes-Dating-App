import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/dashboard/model/dashboard_model.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class ActiveUsersController extends GetxController {
  final AuthRepository _userRepository = AuthRepository();

  /// Observables
  var isLoading = false.obs;
  var activeUsers = <ActiveUserModel>[].obs;
  var errorMessage = "".obs;

  var bestMatches = <BestMatchModel>[].obs;
  var successMessage = "".obs;

  /// request tracking
  var requestStatus = <int, String>{}.obs; 
  var sentRequests = <int, int>{}.obs; 

  /// request loading
  var requestLoading = <int, bool>{}.obs;
  var recentlyLikedUsers =
      <int>{}.obs; // store userIds that were recently liked

  /// like tracking
  var likedUsers = <int>{}.obs; // store liked userIds

  /// Fetch Active Users
  Future<void> fetchActiveUsers() async {
    try {
      isLoading.value = true;
      final users = await _userRepository.getActiveUsers();
      activeUsers.assignAll(users);
      errorMessage.value = "";
      likedUsers.clear(); // reset likes on refresh
    } catch (e) {
      errorMessage.value = e.toString();
      print(" Error fetching active users: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch Best Matches
  Future<void> fetchBestMatches() async {
    try {
      isLoading.value = true;
      final matches = await _userRepository.fetchBestMatches();
      bestMatches.assignAll(matches);
    } catch (e) {
      print(" Error fetching matches: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Send Request
  Future<void> sendRequest(int receiverId) async {
    try {
      requestLoading[receiverId] = true;

      final response = await AuthRepository.sendRequest(receiverId);
      if (response != null && response['request'] != null) {
        int requestId = response['request']['id'];
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

  Future<void> cancelRequest(int receiverId) async {
    try {
      requestLoading[receiverId] = true;

      final requestId = sentRequests[receiverId];
      if (requestId == null) {
        Get.snackbar("Error", "No request found for this user");
        return;
      }

      final response = await AuthRepository.cancelRequest(requestId);
      if (response != null && response['message'] != null) {
        final message = response['message'] ?? '';
        if (message.contains("cancelled") || message.contains("deleted")) {
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

  bool isRequestSent(int receiverId) => requestStatus[receiverId] == "pending";

  /// Like / Unlike
  Future<bool> toggleFavorite(int likedId) async {
    try {
      final token = await SharedPrefHelper.getToken();
      if (token == null || token.isEmpty) {
        Get.snackbar("Error", "Token not found!");
        return false;
      }

      final url = Uri.parse(
        "https://chat.bitmaxtest.com/admin/api/users/$likedId/like",
      );

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print(
        "❤️ Favorite API Response: ${response.statusCode} - ${response.body}",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data["success"] == true) {
          return true;
        }
      }

      // If already liked, call unlike API
      if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        if (data["message"] != null &&
            data["message"].toString().contains("already liked")) {
          print(" User already liked, calling unlike API...");
          return await unlikeUser(likedId);
        }
      }

      return false;
    } catch (e) {
      print(" Favorite API Error: $e");
      return false;
    }
  }

  bool isLiked(int userId) => likedUsers.contains(userId);

  /// Unlike API
  Future<bool> unlikeUser(int likedId) async {
    try {
      final token = await SharedPrefHelper.getToken();
      if (token == null || token.isEmpty) {
        Get.snackbar("Error", "Token not found!");
        return false;
      }

      final url = Uri.parse(
        "https://chat.bitmaxtest.com/admin/api/users/$likedId/unlike",
      );

      final response = await http.delete(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print(
        "💔 Unlike API Response: ${response.statusCode} - ${response.body}",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        likedUsers.remove(likedId); //  remove from set
        return true;
      }
      return false;
    } catch (e) {
      print(" Unlike API Error: $e");
      return false;
    }
  }

  Future<void> handleDoubleTap(int userId) async {
    if (isLiked(userId)) {
      bool success = await unlikeUser(userId);
      if (success) {
        likedUsers.remove(userId);
        recentlyLikedUsers.remove(userId);
      }
    } else {
      bool success = await toggleFavorite(userId);
      if (success) {
        likedUsers.add(userId);
        recentlyLikedUsers.add(userId);

        Future.delayed(const Duration(seconds: 2), () {
          recentlyLikedUsers.remove(userId);
        });
      }
    }
  }
}
