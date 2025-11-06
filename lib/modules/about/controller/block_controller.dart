import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class BlockController extends GetxController {
  var isLoading = false.obs;
  var isBlocked = false.obs;

  /// Toggle Block / Unblock
  Future<void> toggleBlockUser(String userId) async {
    final token = await SharedPrefHelper.getToken() ?? '';

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse("https://shyeyes-b.onrender.com/api/friends/$userId/block"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // API se directly blocked flag aata hai
        isBlocked.value = data["blocked"] ?? false;
      } else {
        Get.snackbar("Error", "Failed to block/unblock user");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Block User
  Future<void> blockUser(String userId) async {
    await toggleBlockUser(userId);
  }

  /// Unblock User
  Future<void> unblockUser(String userId) async {
    await toggleBlockUser(userId);
  }

  /// Check if User is Blocked
  Future<bool> isUserBlocked(String userId) async {
    final token = await SharedPrefHelper.getToken() ?? '';

    try {
      final response = await http.get(
        Uri.parse("https://shyeyes-b.onrender.com/api/friends/$userId/block"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["blocked"] ?? false;
      } else {
        // Assume not blocked if API fails
        return false;
      }
    } catch (e) {
      // Assume not blocked on error
      return false;
    }
  }
}
