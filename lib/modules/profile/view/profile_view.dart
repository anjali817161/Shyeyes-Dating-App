import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shyeyes/modules/edit_profile/edit_profile.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/profile/controller/profile_controller.dart';
import 'package:shyeyes/modules/profile/model/profile_model.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    // 🔑 Safe way: run after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Your Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: theme.colorScheme.primary,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text("Error: ${controller.errorMessage}"));
        }
        if (controller.profile.value == null) {
          return const Center(child: Text("No profile data"));
        }

        final profileData = controller.profile.value!.data;
        return _buildProfileView(
          theme,
          profileData!.fullName ?? "No name",
          profileData.email ?? "No email",
          (profileData.age != null) ? profileData.age.toString() : "N/A",
          profileData.gender ?? "N/A",
          profileData.location ?? "N/A",
          profileData.dob ?? "N/A",
          profileData.about ?? "Not Provided",
          profileData.imageUrl ?? "https://via.placeholder.com/150",
        );
      }),
    );
  }

  Widget _buildProfileView(
    ThemeData theme,
    String name,
    String email,
    String age,
    String gender,
    String location,
    String dob,
    String about,
    String imageUrl,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Banner with gradient + 2 lotties + profile image
          Stack(
            clipBehavior: Clip.none,
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

              // Profile image overlapping banner bottom-left
              Positioned(
                bottom: -50,
                left: 40,
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: imageUrl.isNotEmpty
                        ? NetworkImage(imageUrl)
                        : const NetworkImage("https://via.placeholder.com/150"),
                    onBackgroundImageError: (_, __) {
                      // fallback if the image URL is invalid
                    },
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 60),

          // Profile details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildDetail("Name", name),
                _divider(),
                _buildDetail("Email", email),
                _divider(),
                _buildDetail("Age", age),
                _divider(),
                _buildDetail("Gender", gender),
                _divider(),
                _buildDetail("Location", location),
                _divider(),
                _buildDetail("Date of Birth", dob),
                _divider(),
                _buildDetail("Bio", about),
                _divider(),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Edit Profile button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xFFDF314D),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(color: Colors.grey.shade300, height: 0, thickness: 1);
  }
}
