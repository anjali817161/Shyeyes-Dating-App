import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF9F9F9), // Custom background color
      child: Column(
        children: [
          // 🔺 Custom Profile Header with Row Layout
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFFDF314D)),
            child: Row(
              children: [
                // Profile Image
                const CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage(
                    'assets/images/profile_image1.png',
                  ),
                ),
                const SizedBox(width: 16),
                // Name and Role
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Anjali Chaudhary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Flutter Developer",
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 🔻 Drawer Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: const [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('My Profile'),
                ),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Notifications'),
                ),
                ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text('Favorites'),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
                ListTile(leading: Icon(Icons.help), title: Text('Support')),
                ListTile(leading: Icon(Icons.info), title: Text('About Us')),
                Divider(), // Adds a divider before logout
                ListTile(leading: Icon(Icons.logout), title: Text('Logout')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
