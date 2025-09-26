import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shyeyes/modules/profile/controller/profile_controller.dart';
import 'package:flutter/services.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _imageFile;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController hobbiesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final ProfileController controller = Get.find<ProfileController>();
    final user = controller.profile2.value?.data?.user;

    if (user != null) {
      // Name
      nameController.text =
          "${user.name?.firstName ?? ''} ${user.name?.lastName ?? ''}".trim();

      // Contact info
      phoneController.text = user.phoneNo ?? "";
      emailController.text = user.email ?? "";
      ageController.text = user.age?.toString() ?? "";
      genderController.text = user.gender ?? "";

      // Location
      locationController.text =
          "${user.location?.city ?? ''}, ${user.location?.country ?? ''}"
              .trim();

      // DOB → DateTime को String में format करो
      if (user.dob != null) {
        dobController.text = user.dob!.toIso8601String().split("T").first;
      }

      // Bio & hobbies
      aboutController.text = user.bio ?? "";
      hobbiesController.text =
          (user.hobbies != null && user.hobbies!.isNotEmpty)
          ? user.hobbies!.join(", ")
          : "";
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() => _imageFile = File(pickedFile.path));
      }
    } catch (e) {
      debugPrint("Image pick error: $e");
    }
  }

  Widget _buildPhoneField() {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: phoneController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
        style: const TextStyle(color: Colors.grey),
        decoration: InputDecoration(
          labelText: "Phone",
          filled: true,
          fillColor: Colors.white,
          labelStyle: TextStyle(color: theme.colorScheme.primary),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.grey),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          labelStyle: TextStyle(color: theme.colorScheme.primary),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    final ProfileController controller = Get.find<ProfileController>();
    final user = controller.profile2.value?.data?.user;

    String imageUrl = "https://via.placeholder.com/150";

    if (user != null) {
      if (user.profilePic != null) {
        if (user.profilePic is String &&
            (user.profilePic as String).isNotEmpty) {
          imageUrl =
              "https://shyeyes-b.onrender.com/uploads/${user.profilePic}";
        } else if (user.profilePic is List &&
            (user.profilePic as List).isNotEmpty) {
          imageUrl =
              "https://shyeyes-b.onrender.com/uploads/${(user.profilePic as List).first}";
        }
      } else if (user.photos != null && user.photos!.isNotEmpty) {
        imageUrl =
            "https://shyeyes-b.onrender.com/uploads/${user.photos!.first}";
      }
    }

    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: _imageFile != null
                  ? FileImage(_imageFile!)
                  : NetworkImage(imageUrl) as ImageProvider,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: theme.colorScheme.primary,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 160,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 212, 85, 85),
                        Color.fromARGB(255, 252, 48, 116),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Lottie.asset(
                          'assets/lotties/heart_fly.json',
                          fit: BoxFit.cover,
                          repeat: true,
                        ),
                      ),
                      Expanded(
                        child: Lottie.asset(
                          'assets/lotties/heart_fly.json',
                          fit: BoxFit.cover,
                          repeat: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(bottom: -50, child: _buildProfileImage()),
              ],
            ),

            const SizedBox(height: 60),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildEditableField("Name", nameController),
                  _buildEditableField("Email", emailController),
                  _buildPhoneField(),
                  _buildEditableField("Age", ageController),
                  _buildEditableField("Gender", genderController),
                  _buildEditableField("Location", locationController),
                  _buildEditableField("Date of Birth", dobController),
                  _buildEditableField("Bio", aboutController),
                  _buildEditableField(
                    "Hobbies (comma separated)",
                    hobbiesController,
                  ),

                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final ProfileController controller =
                            Get.find<ProfileController>();

                        await controller.updateProfile(
                          fullName: nameController.text.trim(),
                          email: emailController.text.trim(),
                          phone: phoneController.text.trim(),
                          age: ageController.text.trim(),
                          dob: dobController.text.trim(),
                          gender: genderController.text.trim(),
                          location: locationController.text.trim(),
                          bio: aboutController.text.trim(),
                          hobbies: hobbiesController.text.trim(),
                          img: _imageFile,
                        );

                        await controller.fetchProfile();
                        if (context.mounted) Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
