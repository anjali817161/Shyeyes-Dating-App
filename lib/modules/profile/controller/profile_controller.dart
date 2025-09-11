import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:shyeyes/modules/profile/model/profile_model.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';
// adjust path if needed

class ProfileController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  // Reactive variable to hold ProfileModel
  var profile = Rxn<UserProfileModel>();

  // To track loading state
  var isLoading = false.obs;

  // To track error message
  var errorMessage = ''.obs;
  @override
  void onInit() {
    super.onInit();
    fetchProfile(); // 🔹 auto fetch when controller is created
  }

  /// Fetch profile using API
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Call your API service
      final result = await _authRepository.getProfile();

      // Store it in reactive variable
      profile.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Update profile using API
  void setProfile(UserProfileModel profileData) {
    profile.value = profileData;
  }

  Future<void> updateProfile({
    required String fullName,
    required String phone,
    required String age,
    required String dob,
    required String gender,
    required String location,
    required String about,
    File? img,
  }) async {
    try {
      // split fullName into fName + lName
      final parts = fullName.split(" ");
      final fName = parts.isNotEmpty ? parts.first : "";
      final lName = parts.length > 1 ? parts.sublist(1).join(" ") : "";

      final response = await _authRepository.editProfile(
        fName: fName,
        lName: lName,
        phone: phone,
        age: age,
        dob: dob,
        gender: gender,
        location: location,
        about: about,
        img: img,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == true) {
          // refresh profile
          await fetchProfile();
          Get.snackbar("Success", json['message'] ?? "Profile updated");
        } else {
          Get.snackbar("Error", json['message'] ?? "Something went wrong");
        }
      } else {
        Get.snackbar("Error", "Failed: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
