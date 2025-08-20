import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/auth/signup/model/signup_model.dart';
import 'package:shyeyes/modules/auth/signup/view/personal_info.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class SignUpController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  // Text controllers
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  var showPassword = false.obs;
  var showConfirmPassword = false.obs;
  var isLoading = false.obs;

  void togglePassword() => showPassword.value = !showPassword.value;
  void toggleConfirmPassword() =>
      showConfirmPassword.value = !showConfirmPassword.value;

  Future<void> signupUser() async {
    print("Signup function called");
    if (passCtrl.text != confirmPassCtrl.text) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    isLoading.value = true;
    try {
      final response = await _repo.signup(
        fName: firstNameCtrl.text.trim(),
        lName: lastNameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      print("📩 Status Code => ${response.statusCode}");
      print("📩 Raw Response => ${response.body}");

      final data = jsonDecode(response.body);

      // only then try to map it
      final signupResponse = SignupResponse.fromJson(data);

      if (response.statusCode == 200 && signupResponse.status) {
        if (data['token'] != null) {
          await SharedPrefHelper.saveToken(data['token']);
          print("✅ Token saved: ${data['token']}");
        }
        Get.snackbar("Success", signupResponse.message);
        Get.to(
          () => PersonalInfo(),
          arguments: {"user_id": signupResponse.userId},
        );
      } else {
        Get.snackbar("Error", signupResponse.message);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
