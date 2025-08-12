import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _imageFile;

  final TextEditingController nameController =
      TextEditingController(text: "Saloni Sharma");
  final TextEditingController emailController =
      TextEditingController(text: "saloni@example.com");
  final TextEditingController ageController =
      TextEditingController(text: "25");
  final TextEditingController genderController =
      TextEditingController(text: "Female");
  final TextEditingController locationController =
      TextEditingController(text: "Noida");
  final TextEditingController dobController =
      TextEditingController(text: "2000-01-01");
  final TextEditingController aboutController =
      TextEditingController(text: "I love travelling and music.");

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() => _imageFile = File(pickedFile.path));
      }
    } catch (e) {
      debugPrint("Image pick error: $e");
    }
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.grey), // prefilled text color
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
    return GestureDetector(
      onTap: _pickImage, // Tap avatar to change image
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
                  : const NetworkImage(
                      'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
                    ) as ImageProvider,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
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
        title: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: theme.colorScheme.primary,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner with gradient + 2 lotties + profile image
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center, // Center profile image horizontally
              children: [
                Container(
                  height: 180,
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
                Positioned(
                  bottom: -50,
                  child: _buildProfileImage(), // now centered
                ),
              ],
            ),

            const SizedBox(height: 60),

            // Editable fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildEditableField("Name", nameController),
                  _buildEditableField("Email", emailController),
                  _buildEditableField("Age", ageController),
                  _buildEditableField("Gender", genderController),
                  _buildEditableField("Location", locationController),
                  _buildEditableField("Date of Birth", dobController),
                  _buildEditableField("About", aboutController),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
