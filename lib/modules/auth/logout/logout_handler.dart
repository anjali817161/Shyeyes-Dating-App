import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/auth/login/view/login_view.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class LogoutHelper {
  static void showLogoutDialog(BuildContext context, ThemeData theme) {
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);

              // 🔹 Clear token and other stored session data
              final String token = await SharedPrefHelper.getToken() ?? "";
              if (token.isNotEmpty) {
                await SharedPrefHelper.clearToken();
              }
              // final box = GetStorage();
              // await box.erase(); // Clears all stored keys (or use box.remove('token'))

              // Optionally show a short feedback
              Get.snackbar(
                "Logged Out",
                "You have been logged out successfully.",
                snackPosition: SnackPosition.BOTTOM,
              );

              // 🔹 Navigate back to login
              Get.offAll(() => LoginView());
            },
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
