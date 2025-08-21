import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:shyeyes/modules/auth/signup/controller/personalinfo_controller.dart';
import 'package:shyeyes/modules/main_scaffold.dart';

class PersonalInfo extends StatefulWidget {
  PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final PersonalInfoController controller = Get.put(PersonalInfoController());

  final _formKey = GlobalKey<FormState>();
void pickDob(BuildContext context) async {
  final now = DateTime.now();
  final pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime(now.year - 18),
    firstDate: DateTime(1900),
    lastDate: now,
  );
  if (pickedDate != null) {
    // ✅ enforce English month names
    controller.dobCtrl.text =
        DateFormat('d MMMM yyyy', 'en_US').format(pickedDate);

    print("📤 DOB sending => ${controller.dobCtrl.text}");

    // Auto calculate age
    int age = now.year - pickedDate.year;
    if (now.month < pickedDate.month ||
        (now.month == pickedDate.month && now.day < pickedDate.day)) {
      age--;
    }
    controller.ageCtrl.text = age.toString();
  }
}


  Future<void> pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      controller.profileImage.value = File(pickedFile.path); // ✅ use controller
    }
  }

  @override
  void onClose() {
    controller.fullNameCtrl.dispose();
    controller.emailCtrl.dispose();
    controller.dobCtrl.dispose();
    controller.ageCtrl.dispose();
    controller.streetCtrl.dispose();
    controller.cityCtrl.dispose();
    controller.stateCtrl.dispose();
    controller.countryCtrl.dispose();
    controller.aboutCtrl.dispose();
    // super.onclose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Lottie.asset(
              'assets/lotties/heart_fly.json',
              fit: BoxFit.cover,
              repeat: true,
            ),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Personal Information",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Profile Image Picker
                    Center(
                      child: Obx(() {
                        return GestureDetector(
                          onTap: pickProfileImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: primary.withOpacity(0.3),
                            backgroundImage:
                                controller.profileImage.value != null
                                ? FileImage(controller.profileImage.value!)
                                : null,
                            child: controller.profileImage.value == null
                                ? Icon(
                                    Icons.camera_alt,
                                    color: primary,
                                    size: 40,
                                  )
                                : null,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 25),

                    GestureDetector(
                      onTap: () => pickDob(context),
                      child: AbsorbPointer(
                        child: _buildTextField(
                          context,
                          controller: controller.dobCtrl,
                          label: "Date of Birth",
                          suffixIcon: Icons.calendar_today,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      context,
                      controller: controller.ageCtrl,
                      label: "Age",
                      readOnly: true,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Gender",
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        _genderOption("Male"),
                        _genderOption("Female"),
                        _genderOption("Transgender"),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Location",
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            context,
                            controller: controller.streetCtrl,
                            label: "Street",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            context,
                            controller: controller.cityCtrl,
                            label: "City",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            context,
                            controller: controller.stateCtrl,
                            label: "State",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            context,
                            controller: controller.countryCtrl,
                            label: "Country",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "About",
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      context,
                      controller: controller.aboutCtrl,
                      label: "Tell us about yourself...",
                      maxLines: 4,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            controller.submitPersonalInfo();
                          } else {
                            Get.snackbar(
                              "Error",
                              "Failed to complete registration",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.redAccent.withOpacity(
                                0.8,
                              ),
                              colorText: Colors.white,
                            );
                          }
                        },
                        child: const Text(
                          "Signup",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    IconData? prefixIcon,
    IconData? suffixIcon,
    TextInputType? keyboardType,
    bool readOnly = false,
    int maxLines = 1,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    final primary = Theme.of(context).colorScheme.primary;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLines: maxLines,
      obscureText: obscureText,
      cursorColor: primary,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.85),
        labelText: label,
        labelStyle: TextStyle(color: primary),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: primary)
            : null,
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: primary)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary.withOpacity(0.5)),
        ),
      ),
    );
  }

  Widget _genderOption(String label) {
    return Obx(
      () => Row(
        children: [
          Radio(
            value: label,
            groupValue: controller.gender.value,
            onChanged: (val) => controller.gender.value = val.toString(),
            activeColor: Color(0xFFDF314D),
          ),
          Text(label, style: TextStyle(color: Color(0xFFDF314D))),
        ],
      ),
    );
  }
}
