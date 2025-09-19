import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/auth/login/view/login_view.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';

class PersonalInfoController extends GetxController {
  // ✅ TextControllers
  final fullNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final countryCtrl = TextEditingController();
  final aboutCtrl = TextEditingController();
  final hobbiesCtrl = TextEditingController();

  // ✅ Reactive variables
  Rx<File?> profileImage = Rx<File?>(null);
  RxString gender = "".obs;

  final AuthRepository _authRepo = AuthRepository();

  /// 🚀 API Call
  Future<void> submitPersonalInfo() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // ✅ Location JSON bana ke string me convert karo
      final locationJson = jsonEncode({
        "street": streetCtrl.text.trim(),
        "city": cityCtrl.text.trim(),
        "state": stateCtrl.text.trim(),
        "country": countryCtrl.text.trim(),
      });

      // ✅ Agar profile image null h to dummy image use karo
      File? finalImage = profileImage.value;
      if (finalImage == null) {
        // dummy image ko assets se copy karke File bana lo ya ignore kar do
        // yaha dummy ke liye null hi pass kar dete h
        // agar API required karti h to ek local placeholder image ka path dena
      }

      final response = await _authRepo.submitPersonalInfo(
        imageFile: finalImage,
        dob: dobCtrl.text.trim(),
        age: ageCtrl.text.trim(),
        gender: gender.value,
        location: locationJson,
        about: aboutCtrl.text.trim(),
        hobbies: hobbiesCtrl.text.trim(),
      );

      Get.back(); // loader close

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("✅ Personal Info Success => $data");

        Get.snackbar(
          "Success",
          "Personal info saved successfully!",
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );

        // next step navigate karna ho to yaha kara lo
        Get.offAll(() => LoginView());
      } else {
        print("❌ Error => ${response.body}");
        Get.snackbar(
          "Error",
          "Failed to save personal info",
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back();
      print("⚠️ Exception => $e");
      Get.snackbar(
        "Error",
        "Something went wrong",
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    fullNameCtrl.dispose();
    emailCtrl.dispose();
    dobCtrl.dispose();
    ageCtrl.dispose();
    streetCtrl.dispose();
    cityCtrl.dispose();
    stateCtrl.dispose();
    countryCtrl.dispose();
    aboutCtrl.dispose();
    hobbiesCtrl.dispose();
    super.onClose();
  }
}
