import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/auth/Forgetpassword/otpverify.dart';
import 'package:shyeyes/modules/auth/signup/controller/personalinfo_controller.dart';
import 'package:shyeyes/modules/auth/signup/view/personal_info.dart';
import 'package:shyeyes/modules/auth/signup/widget/otp_bottomsheet.dart';
import 'package:shyeyes/modules/widgets/api_endpoints.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class SignUpController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  // 🔹 Text controllers
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();
  final otpCtrl = TextEditingController();

  // 🔹 States
  var showPassword = false.obs;
  var showConfirmPassword = false.obs;
  var isLoading = false.obs;

  // 🔹 OTP Timer & Resend
  // var counter = 30.obs;
  // var isCounting = false.obs;
  // var isResendLoading = false.obs;
  // Timer? _timer;

  void togglePassword() => showPassword.value = !showPassword.value;
  void toggleConfirmPassword() =>
      showConfirmPassword.value = !showConfirmPassword.value;

  // 🔹 Start OTP countdown timer
  // void startTimer() {
  //   counter.value = 30;
  //   isCounting.value = true;
  //   _timer?.cancel();
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (counter.value > 0) {
  //       counter.value--;
  //     } else {
  //       isCounting.value = false;
  //       _timer?.cancel();
  //     }
  //   });
  // }

  // 🔹 Verify OTP API
  // Future<void> verifyOtp(BuildContext context) async {
  //   if (otpCtrl.text.trim().length < 6) {
  //     Get.snackbar("Error", "Enter valid OTP");
  //     return;
  //   }

  //   isLoading.value = true;
  //   try {
  //     final response = await _repo.verifyOtp(
  //       email: emailCtrl.text.trim(),
  //       otp: otpCtrl.text.trim(),
  //     );

  //     final data = jsonDecode(response.body);
  //     print("📨 Verify OTP Response Status => ${response.statusCode}");
  //     print("📨 Verify OTP Raw Response => ${response.body}");

  //     if (response.statusCode == 200) {
  //       // ✅ Close bottom sheet
  //       Get.back();

  //       final message = data['message'] ?? "OTP verified";
  //       final tempToken = data['tempToken'];

  //       print("🎉 OTP Verified, TempToken => $tempToken");

  //       if (tempToken != null) {
  //         // ✅ Save tempToken in SharedPref
  //         await SharedPrefHelper.saveToken(tempToken);
  //         print("✅ Temp Token Saved: $tempToken");
  //       }

  //       Get.snackbar("Success", message);

  //       // ✅ Navigate to PersonalInfo page
  //       Get.to(() => PersonalInfo());
  //     } else {
  //       Get.snackbar("Error", data['message'] ?? "Invalid OTP");
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", "Something went wrong: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // // 🔹 Signup API
  // Future<void> signupUser(BuildContext context) async {
  //   print("Signup function called");
  //   if (passCtrl.text != confirmPassCtrl.text) {
  //     Get.snackbar("Error", "Passwords do not match");
  //     return;
  //   }

  //   isLoading.value = true;
  //   try {
  //     final response = await _repo.signup(
  //       fName: firstNameCtrl.text.trim(),
  //       lName: lastNameCtrl.text.trim(),
  //       email: emailCtrl.text.trim(),
  //       phone: phoneCtrl.text.trim(),
  //       password: passCtrl.text.trim(),
  //     );

  //     print("📩 Status Code => ${response.statusCode}");
  //     print("📩 Raw Response => ${response.body}");

  //     final data = jsonDecode(response.body);

  //     if (response.statusCode == 200) {
  //       final message = data['message'] ?? "OTP sent";
  //       Get.snackbar("Success", message);

  //       // ✅ Show OTP Bottom Sheet
  //       RegisterOtpVerifyBottomSheet.show(context);
  //     } else {
  //       final errorMessage = data['message'] ?? "Signup failed";
  //       Get.snackbar("Error", errorMessage);
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", "Something went wrong: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // @override
  // void onClose() {
  //   _timer?.cancel();
  //   super.onClose();
  // }

  /// Registration Step 1 API Call
  /// ================================
  Future<void> signupUser(BuildContext context) async {
    isLoading.value = true;
    print(ApiEndpoints.baseUrl + ApiEndpoints.signupStep1);

    try {
      /// Get endpoint from AuthRepository
      final String url = ApiEndpoints.baseUrl + ApiEndpoints.signupStep1;

      /// Prepare request body
      final Map<String, dynamic> body = {
        "firstName": firstNameCtrl.text.trim(),
        "lastName": lastNameCtrl.text.trim(),
        "email": emailCtrl.text.trim(),
        "phoneNo": phoneCtrl.text.trim(),
        "password": passCtrl.text.trim(),
      };

      print("📤 Sending registration step 1 data => $body");

      /// Make POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("📥 Response status: ${response.statusCode}");
      print("📥 Response body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        /// Save email and phone locally for step2 use
        await SharedPrefHelper.saveEmail(emailCtrl.text.trim());
        await SharedPrefHelper.savePhone(phoneCtrl.text.trim());

        Get.snackbar(
          "Success",
          data["message"] ?? "Registration successful",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );

        /// Navigate to next screen (e.g., complete profile)
        Future.delayed(const Duration(seconds: 1), () {
          Get.to(() {
            final controller = Get.put(PersonalInfoController());
            controller.email = emailCtrl.text.trim(); // step 1 API response se
            controller.phone = phoneCtrl.text.trim();
            return PersonalInfo();
          });
        });
      } else {
        Get.snackbar(
          "Error",
          data["message"] ?? "Something went wrong",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("❌ Signup error: $e");
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passCtrl.dispose();
    confirmPassCtrl.dispose();
    super.onClose();
  }
}
