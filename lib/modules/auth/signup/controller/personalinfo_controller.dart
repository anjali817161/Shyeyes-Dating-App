// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shyeyes/modules/auth/login/view/login_view.dart';
// import 'package:shyeyes/modules/widgets/auth_repository.dart';

// class PersonalInfoController extends GetxController {
//   // ✅ TextControllers
//   final fullNameCtrl = TextEditingController();
//   final emailCtrl = TextEditingController();
//   final dobCtrl = TextEditingController();
//   final ageCtrl = TextEditingController();
//   final streetCtrl = TextEditingController();
//   final cityCtrl = TextEditingController();
//   final stateCtrl = TextEditingController();
//   final countryCtrl = TextEditingController();
//   final aboutCtrl = TextEditingController();
//   final hobbiesCtrl = TextEditingController();

//   // ✅ Reactive variables
//   Rx<File?> profileImage = Rx<File?>(null);
//   RxString gender = "".obs;

//   final AuthRepository _authRepo = AuthRepository();

//   /// 🚀 API Call
//   Future<void> submitPersonalInfo() async {
//     try {
//       Get.dialog(
//         const Center(child: CircularProgressIndicator()),
//         barrierDismissible: false,
//       );

//       // ✅ Location JSON bana ke string me convert karo
//       final locationJson = jsonEncode({
//         "street": streetCtrl.text.trim(),
//         "city": cityCtrl.text.trim(),
//         "state": stateCtrl.text.trim(),
//         "country": countryCtrl.text.trim(),
//       });

//       // ✅ Agar profile image null h to dummy image use karo
//       File? finalImage = profileImage.value;
//       if (finalImage == null) {
//         // dummy image ko assets se copy karke File bana lo ya ignore kar do
//         // yaha dummy ke liye null hi pass kar dete h
//         // agar API required karti h to ek local placeholder image ka path dena
//       }

//       final response = await _authRepo.submitPersonalInfo(
//         imageFile: finalImage,
//         dob: dobCtrl.text.trim(),
//         age: ageCtrl.text.trim(),
//         gender: gender.value,
//         location: locationJson,
//         about: aboutCtrl.text.trim(),
//         hobbies: hobbiesCtrl.text.trim(),
//       );

//       Get.back(); // loader close

//       if (response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//         print("✅ Personal Info Success => $data");

//         Get.snackbar(
//           "Success",
//           "Personal info saved successfully!",
//           backgroundColor: Colors.green.withOpacity(0.8),
//           colorText: Colors.white,
//         );

//         // next step navigate karna ho to yaha kara lo
//         Get.offAll(() => LoginView());
//       } else {
//         print(" Error => ${response.body}");
//         Get.snackbar(
//           "Error",
//           "Failed to save personal info",
//           backgroundColor: Colors.redAccent.withOpacity(0.8),
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       Get.back();
//       print("⚠️ Exception => $e");
//       Get.snackbar(
//         "Error",
//         "Something went wrong",
//         backgroundColor: Colors.redAccent.withOpacity(0.8),
//         colorText: Colors.white,
//       );
//     }
//   }

//   @override
//   void onClose() {
//     fullNameCtrl.dispose();
//     emailCtrl.dispose();
//     dobCtrl.dispose();
//     ageCtrl.dispose();
//     streetCtrl.dispose();
//     cityCtrl.dispose();
//     stateCtrl.dispose();
//     countryCtrl.dispose();
//     aboutCtrl.dispose();
//     hobbiesCtrl.dispose();
//     super.onClose();
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shyeyes/modules/auth/login/view/login_view.dart';
import 'package:shyeyes/modules/widgets/api_endpoints.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart'; // for baseURL if needed

class PersonalInfoController extends GetxController {
  // 🧩 Text Controllers
  final dobCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final bioCtrl = TextEditingController();
  final hobbiesCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final countryCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final stateCtrl = TextEditingController();

  // 🧩 Other Fields
  final gender = ''.obs;
  final pickedImage = Rxn<File>();
  final isLoading = false.obs;

  String? email; // from step 1
  String? phone;

  @override
  void onInit() {
    super.onInit();
    _loadEmailFromPrefs();
  }

  Future<void> _loadEmailFromPrefs() async {
    email = await SharedPrefHelper.getEmail();
    phone = await SharedPrefHelper.getPhone();

    print("📧 Loaded email from SharedPrefs => $email");
    print("📧 Loaded phone from SharedPrefs => $phone");
  }

  // 🧩 Pick image from gallery
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      pickedImage.value = File(picked.path);
    }
  }

  // 🧩 Submit Step 2 data (Multipart request)
  Future<void> submitPersonalInfo() async {
    if (dobCtrl.text.isEmpty ||
        ageCtrl.text.isEmpty ||
        gender.value.isEmpty ||
        bioCtrl.text.isEmpty ||
        hobbiesCtrl.text.isEmpty ||
        cityCtrl.text.isEmpty ||
        stateCtrl.text.isEmpty ||
        streetCtrl.text.isEmpty ||
        countryCtrl.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    if (email == null || email!.isEmpty) {
      Get.snackbar('Error', 'Email missing, please go back and re-register.');
      return;
    }

    // Load phone number from SharedPrefs
    if (phone == null || phone!.isEmpty) {
      Get.snackbar('Error', 'Phone number missing. Please re-register.');
      return;
    }

    isLoading.value = true;
    try {
      final uri = Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.signupStep2);

      var request = http.MultipartRequest('POST', uri);

      // ✅ Basic fields
      request.fields['email'] = email!;
      request.fields['phoneNo'] = phone!;
      request.fields['dob'] = dobCtrl.text.trim();
      request.fields['age'] = ageCtrl.text.trim();
      request.fields['gender'] = gender.value;
      request.fields['bio'] = bioCtrl.text.trim();
      request.fields['hobbies'] = hobbiesCtrl.text.trim();

      // ✅ Location JSON
      final locationJson = jsonEncode({
        "city": cityCtrl.text.trim(),
        "country": countryCtrl.text.trim(),
        "street": streetCtrl.text.trim(),
        "state": stateCtrl.text.trim(),
      });
      request.fields['location'] = locationJson;

      print("📤 Multipart Request Fields:");
      request.fields.forEach((key, value) => print("$key => $value"));

      // ✅ Optional image
      if (pickedImage.value != null) {
        final file = pickedImage.value!;
        request.files.add(
          await http.MultipartFile.fromPath('profilePic', file.path),
        );
        print("📤 Multipart File Added: ${file.path}");
      }

      // ✅ Headers
      print("📤 Request Headers:");
      request.headers.forEach((key, value) => print("$key => $value"));

      // Send request
      var response = await request.send();
      print("📥 Response Status Code: ${response.statusCode}");

      final respStr = await response.stream.bytesToString();
      print("📥 Raw Response: $respStr");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(respStr);
        print("📥 Parsed Response: $data");

        if (data['success'] == true) {
          Get.snackbar('Success', 'Registration complete!');
          print("✅ Token: ${data['token']}");
          Get.offAll(() => LoginView());
        } else {
          Get.snackbar('Error', data['message'] ?? 'Something went wrong');
        }
      } else {
        Get.snackbar('Error', 'Failed with status: ${response.statusCode}');
      }
    } catch (e, st) {
      print("⚠️ Exception: $e");
      print("⚠️ Stacktrace: $st");
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
