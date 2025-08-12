import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shyeyes/modules/edit_profile/edit_profile.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Your Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: theme.colorScheme.primary,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner with gradient + 2 lotties + profile image
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Gradient banner with 2 Lottie animations side by side
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
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
                      ),
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
                  _buildDetail("Name", "Saloni Sharma"),
                  _divider(),
                  _buildDetail("Email", "saloni@example.com"),
                  _divider(),
                  _buildDetail("Age", "25"),
                  _divider(),
                  _buildDetail("Gender", "Female"),
                  _divider(),
                  _buildDetail("Location", "Noida"),
                  _divider(),
                  _buildDetail("Date of Birth", "2000-01-01"),
                  _divider(),
                  _buildDetail("About", "I love travelling and music."),
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
    return Divider(
      color: Colors.grey.shade300,
      height: 0,
      thickness: 1,
    );
  }
}
