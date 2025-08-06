import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/about/model/about_model.dart';

class AboutView extends StatelessWidget {
  final AboutModel profileData;

  AboutView({super.key, required this.profileData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(profileData.name!, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                profileData.image!,
                height: 320,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              profileData.name ?? '',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),
            Text(
              'Active ${profileData.active} ago',
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            _infoTile(Icons.work, "Job", "Software Engineer"),
            _infoTile(Icons.school, "College", "IIT Bombay"),
            _infoTile(Icons.location_on, "Location", "Mumbai"),
            _infoTile(Icons.info_outline, "About", "I love building cool apps and exploring new places."),
            _infoTile(Icons.favorite, "Interests", "Music, Coding, Movies"),

            const SizedBox(height: 24),

            _sectionTitle(Icons.chat, "Send a First Impression"),

            const SizedBox(height: 10),

            _firstImpressionBox(primaryColor),

            const SizedBox(height: 30),

            _actionButton("Share Profile"),
            _actionButton("Block User"),
            _actionButton("Report", isDestructive: true),

            const SizedBox(height: 24),

            _bottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFDF314D), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFDF314D), size: 20),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _firstImpressionBox(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Say something to break the ice!",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Write a message...",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.black,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.white30),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.send, color: primaryColor),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _actionButton(String text, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isDestructive ? Colors.redAccent : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _bottomActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white10,
          child: Icon(Icons.close, color: Colors.pinkAccent, size: 28),
        ),
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white10,
          child: Icon(Icons.star, color: Colors.blueAccent, size: 28),
        ),
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white10,
          child: Icon(Icons.favorite, color: Colors.greenAccent, size: 28),
        ),
      ],
    );
  }
}
