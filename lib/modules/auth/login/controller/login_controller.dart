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
    var repo = AuthRepository();
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
      final response = await repo.login(emailCtrl.text, passCtrl.text);

      final data = jsonDecode(response.body);
      print("response: ${response.body}");
// ✅ check login status
      if (data['status'] == true) {
        String token = data['token'];
        await SharedPrefHelper.saveToken(token);
        print("Token saved: $token");
}

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          data["message"] ?? "You are logged in successfully",
          backgroundColor: Colors.green.shade100,
          snackPosition: SnackPosition.TOP,
        );
        Get.offAll(() => MainScaffold());
      } else {
        Get.snackbar(
          "Login Failed",
          data["error"] ?? "Invalid credentials",
          backgroundColor: Colors.red.shade100,
        );
      }
      print(response.statusCode);
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red.shade100);
    } finally {
      isLoading.value = false;
    }
  }
}