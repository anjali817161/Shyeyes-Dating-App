import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/Friendlist/friendlist.dart';
import 'package:shyeyes/modules/accepted_requests/view/accepted_request_view.dart';
import 'package:shyeyes/modules/auth/login/view/login_view.dart';
import 'package:shyeyes/modules/favourite/view/favourite_view.dart';
import 'package:shyeyes/modules/invitation/view/invitation_view.dart';
import 'package:shyeyes/modules/profile/view/profile_view.dart';
import 'package:shyeyes/modules/t&c/t&c.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';
import 'package:shyeyes/modules/profile/controller/profile_controller.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ProfileController controller = Get.find<ProfileController>();

    final List<_DrawerItem> items = [
      _DrawerItem(
        icon: Icons.person,
        label: 'My Profile',
        ontap: () {
          Get.to(() => UserProfilePage());
        },
      ),
      _DrawerItem(
        icon: Icons.handshake_rounded,
        label: 'Friend list',
        ontap: () {
          Get.to(() => FriendListScreen());
        },
      ),
      _DrawerItem(
        icon: Icons.favorite,
        label: 'Favorites',
        ontap: () {
          Get.to(() => FavouritePage());
        },
      ),
      _DrawerItem(
        icon: Icons.insert_invitation_rounded,
        label: 'Invitations',
        ontap: () {
          Get.to(() => InvitationPage());
        },
      ),
      _DrawerItem(
        icon: Icons.done_all,
        label: 'Accepted Requests',
        ontap: () {
          Get.to(() => AcceptedRequestsView());
        },
      ),
      _DrawerItem(
        icon: Icons.description,
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
          /// DrawerHeader linked with Profile Data
          Obx(() {
            final user = controller.profile2.value?.data?.user;

            final displayName =
                (user?.name?.firstName ?? '') +
                (user?.name?.lastName != null
                    ? ' ${user!.name!.lastName}'
                    : '');

            final profileImage =
                (user?.profilePic != null &&
                    user!.profilePic!.toString().isNotEmpty)
                ? NetworkImage(user.profilePic.toString())
                : _buildPlaceholderAvatar();

            return DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFFDF314D)),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        (user?.profilePic != null &&
                            user!.profilePic!.toString().isNotEmpty)
                        ? NetworkImage(
                            "https://shyeyes-b.onrender.com/uploads/${user.profilePic}",
                          )
                        : null, // if null → fallback to child
                    child:
                        (user?.profilePic == null ||
                            user!.profilePic!.toString().isEmpty)
                        ? _buildPlaceholderAvatar()
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName.isNotEmpty ? displayName : "No Name",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.bio ?? "No about info",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white70,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          /// Drawer Menu Items
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: ListTile(
                      leading: Icon(
                        item.icon,
                        color: theme.primaryColor,
                        size: 26,
                      ),
                      title: Text(
                        item.label,
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
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

  Widget _buildPlaceholderAvatar() {
    return Container(
      color: Colors.grey[200],
      child: Icon(Icons.person, color: Colors.grey[400], size: 30),
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
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              final authRepo = AuthRepository();
              await authRepo.logout();
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
