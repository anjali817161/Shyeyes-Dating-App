import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/edit_profile/edit_profile.dart';
import 'package:shyeyes/modules/profile/controller/profile_controller.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final ProfileController controller = Get.put(ProfileController());

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
        if (controller.profile2.value == null ||
            controller.profile2.value!.data!.user == null) {
          return const Center(child: Text("No profile data"));
        }

        final profileData = controller.profile2.value!.data!.user!;

        // ✅ DOB ko safe string me convert karna
        String dobText = profileData.dob != null
            ? "${profileData.dob!.year}-${profileData.dob!.month.toString().padLeft(2, '0')}-${profileData.dob!.day.toString().padLeft(2, '0')}"
            : "N/A";

        // ✅ Profile image handling
        String imageUrl = "https://via.placeholder.com/150";
        if (profileData.profilePic != null &&
            profileData.profilePic is String &&
            (profileData.profilePic as String).isNotEmpty) {
          imageUrl = profileData.profilePic as String;
        } else if (profileData.photos != null &&
            profileData.photos!.isNotEmpty) {
          imageUrl = profileData.photos!.first.toString();
        }

        return _buildProfileView(
          theme,
          "${profileData.name?.firstName ?? ""} ${profileData.name?.lastName ?? ""}",
          profileData.email ?? "No email",
          profileData.phoneNo ?? "N/A", // pehle phone
          profileData.age != null ? profileData.age.toString() : "N/A", // fir age
          profileData.gender ?? "N/A",
          profileData.location != null
              ? [
                  profileData.location!.city ?? "",
                  profileData.location!.country ?? "",
                ].where((e) => e.isNotEmpty).join(", ")
              : "Not Provided",
          dobText,
          profileData.bio ?? "Not Provided",
          imageUrl,
          (profileData.hobbies != null && profileData.hobbies!.isNotEmpty)
              ? profileData.hobbies!.join(", ")
              : "Not Provided",
        );
      }),
    );
  }

  Widget _buildProfileView(
    ThemeData theme,
    String name,
    String email,
    String phoneno,
    String age,
    String gender,
    String location,
    String dob,
    String about,
    String imageUrl,
    String hobbies,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Banner with gradient + lotties
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

              // Profile image overlapping banner
              Positioned(
                bottom: -50,
                left: 40,
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(imageUrl),
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
                _buildDetail("PhoneNo", phoneno),
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
                _buildDetail("Hobbies", hobbies),
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
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  );

                  if (result == true) {
                    controller.fetchProfile(); // ✅ refresh karwa lo
                  }
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
