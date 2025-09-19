import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/auth/Forgetpassword/Createnewpassword.dart';
import 'package:shyeyes/modules/auth/Forgetpassword/otpverify.dart';
import 'package:shyeyes/modules/auth/login/view/login_view.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class ForgetPasswordController extends GetxController {
  final emailCtrl = TextEditingController();
  var isLoading = false.obs; // For Send OTP button

  var isCounting = false.obs;
  var counter = 60.obs;
  var isResendLoading = false.obs; // 🔹 Only for Resend OTP loader
  Timer? _timer;

  // Send OTP API call
  final otpCtrl = TextEditingController();
  Future<void> sendOtp(BuildContext context) async {
    if (emailCtrl.text.isEmpty) {
      Get.snackbar("Error", "Please enter email");
      return;
    }

    isLoading.value = true;
    try {
      final token = await SharedPrefHelper.getToken();
      final response = await AuthRepository().Forgetpassword(emailCtrl.text);

      if (response.statusCode == 200) {
        Get.snackbar("Success", "OTP Sent to your email");
        startTimer();

        // ✅ OTP verify bottomsheet open
        Future.delayed(Duration(milliseconds: 300), () {
          Navigator.pop(context); // pehle forget bottomsheet band karo
          // then OTP bottomsheet open
          OtpVerifyBottomSheet.show(context);
        });
      } else {
        Get.snackbar("Error", "Failed to send OTP");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Resend OTP
  Future<void> resendOtp() async {
    isResendLoading.value = true;
    try {
      final response = await AuthRepository().Forgetpassword(emailCtrl.text);
      if (response.statusCode == 200) {
        Get.snackbar("Success", "OTP resent to your email");
        startTimer();
      } else {
        Get.snackbar("Error", "Failed to resend OTP");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isResendLoading.value = false;
    }
  }

  // Timer start
  void startTimer() {
    isCounting.value = true;
    counter.value = 60;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter.value > 0) {
        counter.value--;
      } else {
        isCounting.value = false;
        timer.cancel();
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // forgetotp api

  // OTP Verify
  Future<void> verifyOtp(String otp, BuildContext context) async {
    if (otp.isEmpty || otp.length < 6) {
      Get.snackbar("Error", "Please enter a valid OTP");
      return;
    }

    isLoading.value = true;
    try {
      final token =
          await SharedPrefHelper.getToken(); // Token from SharedPref
      final response = await AuthRepository().forgetOtpVerify(otp, token ?? "");

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("print data $data");

        Get.snackbar("Success", data['message'] ?? "OTP Verified Successfully");

        //  BottomSheet close + New Password BottomSheet open safely
        Navigator.pop(context);
        Future.delayed(const Duration(milliseconds: 300), () {
          CreatePasswordBottomSheet.show(Get.context!);
        });
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar("Error", data['message'] ?? "OTP verification failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // create new password 

  // ForgetPasswordController.dart

Future<void> createNewPassword(
    String newPass, String confirmPass, BuildContext context) async {
  if (newPass.isEmpty || confirmPass.isEmpty) {
    Get.snackbar("Error", "Please fill all fields");
    return;
  }
  if (newPass.length < 6) {
    Get.snackbar("Error", "Password must be at least 6 characters");
    return;
  }
  if (newPass != confirmPass) {
    Get.snackbar("Error", "Passwords do not match");
    return;
  }

  isLoading.value = true;
  try {
    final token = await SharedPrefHelper.getToken();
    final response = await AuthRepository()
        .CreateNewPass(newPass, confirmPass, token ?? "");

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) { 
      final data = jsonDecode(response.body);
      Get.snackbar("Success", data['message'] ?? "Password reset successful");

      // ✅ BottomSheet close + Login Page open
      Navigator.pop(context);
      Get.offAll(() => LoginView());
    } else {
      final data = jsonDecode(response.body);
      Get.snackbar("Error", data['message'] ?? "Failed to reset password");
    }
  } catch (e) {
    Get.snackbar("Error", e.toString());
  } finally {
    isLoading.value = false;
  }
}

}
