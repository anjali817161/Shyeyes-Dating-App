import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/dashboard/model/bestmatch_model.dart';
import 'package:shyeyes/modules/dashboard/model/dashboard_model.dart';
import 'package:shyeyes/modules/profile/view/current_plan.dart';
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
        final result = BestMatchResponse.fromJson(json.decode(response.body));

        if (result.data?.matches != null) {
          matches.value = result.data!.matches!;
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
        final status = (response['status'] ?? "cancelled").toLowerCase();
        requestStatus[receiverId] = status;

        // ✅ Active Users list me update karo
        final userIndex = users.indexWhere((u) => u.id == receiverId);
        if (userIndex != -1) {
          users[userIndex] = Users(
            id: users[userIndex].id,
            name: users[userIndex].name,
            age: users[userIndex].age,
            bio: users[userIndex].bio,
            profilePic: users[userIndex].profilePic,
            hobbies: users[userIndex].hobbies,
            location: users[userIndex].location,
            friendshipStatus: status, // 👈 yaha update
          );
          users.refresh();
        }

        // ✅ Best Matches list me update karo
        final matchIndex = matches.indexWhere((m) => m.id == receiverId);
        if (matchIndex != -1) {
          matches[matchIndex] = BestmatchModel(
            id: matches[matchIndex].id,
            age: matches[matchIndex].age,
            bio: matches[matchIndex].bio,
            status: status, // 👈 yaha update
            likedByMe: matches[matchIndex].likedByMe,
            profilePic: matches[matchIndex].profilePic,
            hobbies: matches[matchIndex].hobbies,
            name: matches[matchIndex].name,
            location: matches[matchIndex].location,
          );
          matches.refresh();
        }

        // ✅ Snackbar
        if (status == "pending") {
          Get.snackbar("Success", "Friend request sent successfully!");
        } else {
          Get.snackbar("Success", "Friend request cancelled successfully!");
        }
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
    final uri = Uri.parse("https://shyeyes-b.onrender.com/api/likes/$userId/like");

    // ✅ Check current liked state
    final bool isCurrentlyLiked = likedUsers.contains(userId);

    // ✅ Instantly update UI (optimistic)
    if (isCurrentlyLiked) {
      likedUsers.remove(userId); // turn grey instantly
    } else {
      likedUsers.add(userId); // turn red instantly
      recentlyLikedUsers.add(userId);

      // Heart animation for a second
      Future.delayed(const Duration(seconds: 1), () {
        recentlyLikedUsers.remove(userId);
      });
    }

    // ✅ Hit like/unlike API
    final response = await http.post(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    print("Like/Unlike response: ${response.statusCode} => ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final liked = data['liked'] ?? !isCurrentlyLiked;

      // ✅ Sync with backend (in case mismatch)
      if (liked) {
        likedUsers.add(userId);
      } else {
        likedUsers.remove(userId);
      }

      Get.snackbar(
        "Success",
        liked ? "Profile liked ❤️" : "Profile unliked 💔",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      // ❌ Revert if API fails
      if (isCurrentlyLiked) {
        likedUsers.add(userId);
      } else {
        likedUsers.remove(userId);
      }
      Get.snackbar("Error", "Failed to update like status");
    }
  } catch (e) {
    print("Error in toggleFavorite: $e");
    Get.snackbar("Error", "Something went wrong while liking");
  }
}


  bool isLiked(String userId) {
    return likedUsers.contains(userId);
  }
}
