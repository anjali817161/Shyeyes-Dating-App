import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/main_scaffold.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class LoginController extends GetxController {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  var isLoading = false.obs;
  var showPassword = false.obs;

  void togglePassword() => showPassword.value = !showPassword.value;

  Future<void> login(GlobalKey<FormState> formKey, bool isTermsChecked) async {
    final repo = AuthRepository();

    if (!isTermsChecked) {
      Get.snackbar(
        "Error",
        "Please agree to the Terms & Conditions",
        backgroundColor: Colors.red.shade100,
      );
      return;
    }

    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final response = await repo.login(
        emailCtrl.text.trim(),
        passCtrl.text.trim(),
      );

      print("Raw Response: ${response.body}");
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // ✅ Save token
        final token = data['token'];
        if (token != null && token.toString().isNotEmpty) {
          await SharedPrefHelper.saveToken(token);
          print("🔑 Token saved: $token");
        }

        // ✅ Save user details safely
        final user = data['user'];
        if (user != null) {
          final userId = user['_id'] ?? user['id'] ?? '';
          final userName = user['Name'] != null
              ? "${user['Name']['firstName'] ?? ''} ${user['Name']['lastName'] ?? ''}".trim()
              : (user['name'] ?? '');
          final profilePic = user['profilePic'] ?? '';

          if (userId.isEmpty) {
            print("⚠️ Warning: userId is empty, check backend response!");
          }

          await SharedPrefHelper.saveUserId(userId);
          await SharedPrefHelper.saveUserName(userName);
          await SharedPrefHelper.saveUserPic(profilePic);

          print("✅ User saved in SharedPref:");
          print("   ID: $userId");
          print("   Name: $userName");
          print("   Pic: $profilePic");
        } else {
          print("⚠️ No user object found in response");
        }

        Get.snackbar(
          "Success",
          data["message"] ?? "You are logged in successfully",
          backgroundColor: Colors.green.shade100,
          snackPosition: SnackPosition.TOP,
        );

        // ✅ Navigate to main screen
        Get.offAll(() => MainScaffold());
      } else {
        Get.snackbar(
          "Login Failed",
          data["message"] ?? "Invalid credentials",
          backgroundColor: Colors.red.shade100,
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red.shade100);
    } finally {
      isLoading.value = false;
    }
  }
}
