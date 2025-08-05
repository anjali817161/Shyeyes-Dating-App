import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/home/view/home_view.dart';
import 'package:shyeyes/modules/main_scaffold.dart';

class LoginController extends GetxController {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  var isLoading = false.obs;
  var showPassword = false.obs;

  void togglePassword() {
    showPassword.value = !showPassword.value;
  }

  void clearFields() {
    emailCtrl.clear();
    passCtrl.clear();
  }

  void login(GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      isLoading.value = false;

      clearFields();
      Get.offAll(() => MainScaffold());

      // Get.snackbar(
      //   "Login Success",
      //   "Welcome back!",
      //   backgroundColor: Colors.green.shade100,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    }
  }
}
