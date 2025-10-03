import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/blockedUsers/model/blocked_model.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class BlockedUserController extends GetxController {
  var isLoading = false.obs;
  var blockedUsers = <BlockedUserModel>[].obs;

  final String baseUrl = "https://shyeyes-b.onrender.com/api";

  @override
  void onInit() {
    super.onInit();
    fetchBlockedUsers();
  }

  /// Fetch Blocked Users
  Future<void> fetchBlockedUsers() async {
    final token = await SharedPrefHelper.getToken() ?? "";
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse("$baseUrl/friends/block-list"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final parsed = BlockedUserResponse.fromJson(data);
        blockedUsers.value = parsed.blockedUsers;
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
