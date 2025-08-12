import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shyeyes/modules/auth/login/view/login_view.dart';
import 'package:shyeyes/modules/profile/view/profile_view.dart';
import 'package:shyeyes/modules/t&c/t&c.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<_DrawerItem> items = [
      _DrawerItem(
        icon: Icons.person,
        label: 'My Profile',
        ontap: () {
          Get.to(() => UserProfilePage());
        },
      ),
      _DrawerItem(icon: Icons.favorite, label: 'Favorites', ontap: () {}),
      _DrawerItem(icon: Icons.info, label: 'About Us', ontap: () {}),
      _DrawerItem(
        icon: Icons.notifications,
        label: 'Terms & Conditions',
        ontap: () {
          Get.to(() => const TermsAndConditions());
        },
      ),
      _DrawerItem(
        icon: Icons.logout,
        label: 'Logout',
        ontap: () {
          _showLogoutDialog(context, theme);
        },
      ),
    ];

    return Drawer(
      backgroundColor: const Color(0xFFF9F9F9),
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFFDF314D)),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage(
                    'assets/images/profile_image1.png',
                  ),
                ),
                const SizedBox(width: 16),
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
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              padding: EdgeInsets.zero,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                color: Color(0xFFE0E0E0),
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    item.ontap();
                  },
                  child: ListTile(
                    leading: Icon(item.icon, color: theme.primaryColor),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static void _showLogoutDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.logout, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              "Logout",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to logout?",
          style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
          Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              Get.offAll(() => LoginView());
              print("User Logged Out");
            },
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem {
  final IconData icon;
  final String label;
  final VoidCallback ontap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.ontap,
  });
}
