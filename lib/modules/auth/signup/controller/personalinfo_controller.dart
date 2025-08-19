import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/dashboard/view/dashboard_view.dart';
import 'package:shyeyes/modules/main_scaffold.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';

class PersonalInfoController extends GetxController {
  final fullNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final countryCtrl = TextEditingController();
  final aboutCtrl = TextEditingController();

  final gender = ''.obs;
  final Rx<File?> profileImage = Rx<File?>(null);

  var isLoading = false.obs;
  final AuthRepository _repo = AuthRepository();

  /// submit to API
  Future<void> submitPersonalInfo() async {
    final userId = Get.arguments?['user_id']; // received from signup step
    if (userId == null) {
      Get.snackbar("Error", "User ID not found!");
      return;
    }

    final location =
        "${streetCtrl.text.trim()}, ${cityCtrl.text.trim()}, ${stateCtrl.text.trim()}, ${countryCtrl.text.trim()}";

    isLoading.value = true;
    try {
      final response = await _repo.submitPersonalInfo(
        userId: userId,
        imageFile: profileImage.value,
        dob: dobCtrl.text.trim(),
        age: ageCtrl.text.trim(),
        gender: gender.value.toLowerCase(),
        location: location.trim(),
        about: aboutCtrl.text.trim(),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data["status"] == true) {
        Get.snackbar("Success", data["message"] ?? "Registration completed");

        // you can access user info if needed
        final user = data["user"];
        print("User Registered => ${user['full_name']}");

        // Navigate next
        Get.offAll(() => MainScaffold());
      } else {
        Get.snackbar("Error", data["message"] ?? "Something went wrong");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
