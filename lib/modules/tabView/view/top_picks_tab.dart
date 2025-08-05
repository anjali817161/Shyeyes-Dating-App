import 'package:flutter/material.dart';
import 'package:shyeyes/modules/tabView/widget/user_card.dart';

class TopPicksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recently active",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              UserCard(
                name: "Shivanya",
                age: 24,
                isActive: true,
                imageUrl: "assets/images/profile_image1.png",
              ),
              const SizedBox(width: 12),
              UserCard(
                name: "Rashi",
                age: 26,
                isActive: true,
                imageUrl: "assets/images/profile_image2.png",
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Expand Recently Active logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 3,
              ),
              child: Text("SEE MORE", style: TextStyle(fontSize: 14)),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            "Recommended",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              UserCard(
                name: "User 1",
                age: 27,
                isActive: false,
                imageUrl: "assets/images/profile_image3.png",
              ),
              const SizedBox(width: 12),
              UserCard(
                name: "User 2",
                age: 25,
                isActive: false,
                imageUrl: "assets/images/profile_image4.png",
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Expand Recommended logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 3,
              ),
              child: Text("SEE MORE", style: TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
