import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:shyeyes/modules/edit_profile/edit_model.dart';
import 'package:shyeyes/modules/profile/model/current_plan.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  var profile2 = Rxn<EditProfileModel>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  /// Fetch profile using API
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _authRepository.getProfile();
      profile2.value = result;

      //  Save user data to SharedPreferences
      _saveUserDataToSharedPreferences(result);
    } catch (e) {
      errorMessage.value = e.toString();
      print(' Error fetching profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  ///  CORRECTED: Save user data to SharedPreferences
  Future<void> _saveUserDataToSharedPreferences(
    EditProfileModel? profile,
  ) async {
    if (profile != null) {
      try {
        final user = profile.data?.user;
        if (user != null) {
          // Use the correct fields from your model
          final userId = user.id ?? '';
          final userName = _getUserName(user); // Get full name from Name object
          final userProfilePic =
              user.profilePic?.toString() ?? ''; // Handle dynamic type

          // Save to SharedPreferences
          await SharedPrefHelper.saveUserId(userId);
          await SharedPrefHelper.saveUserName(userName);

          if (userProfilePic.isNotEmpty) {
            await SharedPrefHelper.saveUserPic(userProfilePic);
          }
        } else {
          print(' User data is null in profile model');
        }
      } catch (e) {
        print(' Error saving user data to SharedPreferences: $e');
      }
    } else {
      print(' Profile model is null');
    }
  }

  /// CORRECTED: Extract user name from Name object
  String _getUserName(User user) {
    // Check if Name object exists and has data
    if (user.name != null) {
      final firstName = user.name!.firstName ?? '';
      final lastName = user.name!.lastName ?? '';

      // Combine first and last name
      if (firstName.isNotEmpty && lastName.isNotEmpty) {
        return '$firstName $lastName';
      } else if (firstName.isNotEmpty) {
        return firstName;
      } else if (lastName.isNotEmpty) {
        return lastName;
      }
    }

    // Fallback to email if name is not available
    if (user.email != null && user.email!.isNotEmpty) {
      return user.email!.split('@').first;
    }

    // Final fallback
    return 'User';
  }

  /// Update profile using API
  void setProfile(EditProfileModel profileData) {
    profile2.value = profileData;
    _saveUserDataToSharedPreferences(profileData);
  }

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

  ///  Check SharedPreferences status
  Future<void> checkUserDataStatus() async {
    final userId = await SharedPrefHelper.getUserId();
    final userName = await SharedPrefHelper.getUserName();
    final userPic = await SharedPrefHelper.getUserPic();

    if (profile2.value != null) {
      final user = profile2.value!.data!.user!;
    }
  }

  ///  Get current user ID for chat
  Future<String?> getCurrentUserIdForChat() async {
    final userId = await SharedPrefHelper.getUserId();
    if (userId == null || userId.isEmpty) {
      // Try to refetch profile if ID is not available
      await fetchProfile();
      return await SharedPrefHelper.getUserId();
    }
    return userId;
  }
}
