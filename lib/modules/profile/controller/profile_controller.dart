import 'dart:convert';
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
}


