import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:shyeyes/modules/edit_profile/edit_model.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  // Reactive profile model
  var profile2 = Rxn<EditProfileModel>();

  // Loading & error tracking
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  /// Getter for easier access
  EditProfileModel? get editProfileModel => profile2.value;

  @override
  void onInit() {
    super.onInit();
    fetchProfile(); // auto load
  }

  /// Fetch profile from API
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _authRepository.getProfile();
      profile2.value = result;
      print("✅ Profile fetched: ${result.data?.edituser?.name?.firstName}");
    } catch (e) {
      errorMessage.value = e.toString();
      print("❌ Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Called explicitly in main.dart
  Future<void> loadProfile() async {
    await fetchProfile();
  }

  /// Manually set profile
  void setProfile(EditProfileModel profileData) {
    profile2.value = profileData;
  }

  /// Update Profile API
  Future<void> updateProfile({
    required String fullName,
    required String email,
    required String phone,
    required String age,
    required String gender,
    required String location,
    required String dob,
    required String bio,
    String? hobbies,
    File? img,
  }) async {
    try {
      final parts = fullName.split(" ");
      final fName = parts.isNotEmpty ? parts.first : "";
      final lName = parts.length > 1 ? parts.sublist(1).join(" ") : "";

      final response = await _authRepository.editProfile(
        fName: fName,
        lName: lName,
        email: email,
        phone: phone,
        age: age,
        gender: gender,
        location: location,
        dob: dob,
        bio: bio,
        hobbies: hobbies,
        img: img,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        if (json['status'] == true) {
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
