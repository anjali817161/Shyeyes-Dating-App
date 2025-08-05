import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/about/controller/about_controller.dart';

class AboutView extends StatelessWidget {
  final profile = Get.find<AboutController>().selectedProfile.value!;

  AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (profile == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "No profile data found",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                profile.image,
                height: 360,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),
            Text(
              "${profile.name}, ${profile.age}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(profile.distance, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 16),
            _infoRow(Icons.work, profile.job),
            _infoRow(Icons.school, profile.college),
            _infoRow(Icons.location_on, profile.location),

            const SizedBox(height: 24),
            const Divider(color: Colors.white24),
            _matchmakerCard(),
            const SizedBox(height: 16),
            _infoRow(Icons.chat, profile.about),

            const SizedBox(height: 24),
            _sectionTitle(Icons.interests, "Interests"),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.interests.map((interest) {
                return Chip(
                  label: Text(interest),
                  backgroundColor: Colors.grey[850],
                  labelStyle: const TextStyle(color: Colors.white),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),
            _firstImpressionBox(),

            const SizedBox(height: 24),
            _actionButton("Share ${profile.name}'s profile"),
            _actionButton("Block ${profile.name}"),
            _actionButton("Report ${profile.name}", isDestructive: true),

            const SizedBox(height: 24),
            _bottomActions(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Icon with text
  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFFDF314D), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  // Matchmaker section
  Widget _matchmakerCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Color(0xFFDF314D)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Matchmaker",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Invite friends to be your Matchmaker",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Section title with icon
  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFFDF314D), size: 20),
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

  // First Impression message box
  Widget _firstImpressionBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.send, color: Colors.blueAccent, size: 20),
              SizedBox(width: 6),
              Text(
                "Stand out with a First Impression",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Send a message before matching to help get their attention. Say what made them stand out, hype them up or make them laugh.",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.white30),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Your message",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Send",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Buttons like Share, Block, Report
  Widget _actionButton(String text, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey[900],
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

  // Bottom 3 action icons
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
