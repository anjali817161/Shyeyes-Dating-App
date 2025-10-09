import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shyeyes/modules/about/controller/about_controller.dart';
import 'package:shyeyes/modules/about/controller/block_controller.dart';
import 'package:shyeyes/modules/about/widgets/block_bottomsheet.dart';
import 'package:shyeyes/modules/about/widgets/report_bottomsheet.dart';
import 'package:shyeyes/modules/chats/view/chats_view.dart';
import 'package:shyeyes/modules/dashboard/controller/dashboard_controller.dart';
import 'package:shyeyes/modules/profile/widget/get_profiles_slider.dart';
import 'package:shyeyes/modules/widgets/api_endpoints.dart';

class AboutView extends StatefulWidget {
  final String userId;

  const AboutView({super.key, required this.userId});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  final AboutController controller = Get.put(AboutController());
  final userController = Get.find<ActiveUsersController>();
  final BlockController blockController = Get.put(BlockController());

  // bool isLiked = false;
  bool playHeartAnimation = false;

  @override
  void initState() {
    super.initState();
    controller.fetchUserProfile(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onPrimaryColor = theme.colorScheme.onPrimary;
    final secondaryColor = theme.colorScheme.secondary;
    final onSecondaryColor = theme.colorScheme.onSecondary;

    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      final profileData = controller.aboutModel.value?.user;

      if (profileData == null) {
        return const Scaffold(
          body: Center(child: Text("No profile data found")),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          await controller.fetchUserProfile(widget.userId);
        },
        child: Scaffold(
          backgroundColor: secondaryColor,
          appBar: AppBar(
            title: Text(
              profileData.name?.firstName ?? "",
              style: TextStyle(color: onPrimaryColor),
            ),
            backgroundColor: primaryColor,
            elevation: 0,
            iconTheme: IconThemeData(color: onPrimaryColor),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image + Bottom Actions in Stack
                // Always show PhotoSliderBanner
                // Profile Image + Bottom Actions in Stack
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        height: 320, // same height as previous image
                        width: double.infinity,
                        child: PhotoSliderBanner(
                          height: double.infinity,
                          photos:
                              (profileData.photos != null &&
                                  profileData.photos!.isNotEmpty)
                              ? profileData.photos!
                                    .map((e) => e.toString())
                                    .toList()
                              : (profileData.profilePic != null &&
                                    profileData.profilePic!.isNotEmpty)
                              ? [
                                  profileData.profilePic!,
                                ] // show profile pic if no photos
                              : ["placeholder"], // fallback placeholder
                        ),
                      ),
                    ),

                    // Bottom action buttons
                    Positioned(bottom: -28, child: _bottomActions(theme)),
                  ],
                ),

                const SizedBox(height: 30),

                Row(
                  children: [
                    Text(
                      "${profileData.name?.firstName ?? ""} ${profileData.name?.lastName ?? ""}",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: onSecondaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ", ${profileData.age ?? ""} ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: onSecondaryColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),
                Row(
                  children: [
                    if ((profileData.friendshipStatus ?? "").isNotEmpty) ...[
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      profileData.friendshipStatus ?? "",
                      style: TextStyle(
                        color: onSecondaryColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _infoTile(theme, Icons.work, "Bio", profileData.bio ?? ""),
                _infoTile(
                  theme,
                  (profileData.gender?.toLowerCase() == "male")
                      ? Icons.man
                      : (profileData.gender?.toLowerCase() == "female")
                      ? Icons.woman
                      : Icons
                            .help_outline, // fallback agar gender null/unknown ho
                  "Gender",
                  profileData.gender ?? "N/A",
                ),

                _infoTile(
                  theme,
                  Icons.location_on,
                  "Location",
                  "${profileData.location?.street ?? ""}, ${profileData.location?.city ?? ""}, ${profileData.location?.state ?? ""}, ${profileData.location?.country ?? ""}",
                ),
                _infoTile(
                  theme,
                  Icons.favorite,
                  "Hobbies",
                  profileData.hobbies?.join(", ") ?? "",
                ),

                const SizedBox(height: 20),

                // _sectionTitle(theme, Icons.chat, "Send a First Impression"),
                // const SizedBox(height: 10),
                // _firstImpressionBox(theme),
                // request Button
                // Request Button (Send / Cancel toggle)
                Obx(() {
                  final profileData = controller.aboutModel.value?.user;
                  final isPending = controller.isRequestPending;
                  final isLoading = controller.requestLoading.value;
                  final status =
                      profileData?.friendshipStatus?.toLowerCase() ?? "";
                  final isBlocked =
                      status == "blocked" || blockController.isBlocked.value;
                  final isFriend = status == "friend";

                  if (isBlocked || isFriend) return const SizedBox.shrink();

                  if (isBlocked) return const SizedBox.shrink();

                  return GestureDetector(
                    onTap: () async {
                      if (!isLoading) {
                        await controller.toggleRequest(widget.userId);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isPending
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isPending
                                        ? Icons.cancel_outlined
                                        : Icons.send,
                                    color: isPending
                                        ? Colors.white
                                        : theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isPending
                                        ? "Cancel Request"
                                        : "Send Request",
                                    style: TextStyle(
                                      color: isPending
                                          ? Colors.white
                                          : theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  );
                }),

                // Share Button
                GestureDetector(
                  onTap: () {
                    Share.share(
                      'Check out ${profileData.name?.firstName ?? ""}\'s profile!',
                      subject: 'Profile from ShyEyes',
                    );
                  },
                  child: Container(
                    width:
                        double.infinity, // ✅ Make width same as other buttons
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // ✅ Center icon + text
                      children: [
                        const Icon(Icons.share, color: Colors.blueAccent),
                        const SizedBox(width: 8),
                        Text(
                          "Share Profile",
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Block / Unblock Button
                Obx(() {
                  final profileData = controller.aboutModel.value?.user;
                  final isBlockedFromApi =
                      profileData?.friendshipStatus?.toLowerCase() == "blocked";

                  // Agar API se "Blocked" mila to wahi dikhao
                  final isBlocked =
                      isBlockedFromApi || blockController.isBlocked.value;

                  return GestureDetector(
                    onTap: () async {
                      await blockController.toggleBlockUser(widget.userId);

                      // Toggle ke baad API ko dobara call karke status fresh kar lo
                      await controller.fetchUserProfile(widget.userId);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isBlocked
                            ? theme
                                  .colorScheme
                                  .primary // blocked hai toh primary color
                            : theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: blockController.isLoading.value
                            ? const CircularProgressIndicator(strokeWidth: 2)
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isBlocked
                                        ? Icons.block_flipped
                                        : Icons.block,
                                    color: isBlocked
                                        ? theme.colorScheme.onPrimary
                                        : theme.colorScheme.onSurface,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isBlocked ? "Unblock User" : "Block User",
                                    style: TextStyle(
                                      color: isBlocked
                                          ? theme.colorScheme.onPrimary
                                          : theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  );
                }),

                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _infoTile(ThemeData theme, IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(ThemeData theme, IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 20),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  // Widget _firstImpressionBox(ThemeData theme) {
  //   return Container(
  //     padding: const EdgeInsets.all(14),
  //     decoration: BoxDecoration(
  //       color: theme.colorScheme.surfaceVariant,
  //       borderRadius: BorderRadius.circular(14),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           "Say something to break the ice!",
  //           style: TextStyle(color: theme.colorScheme.onSurface),
  //         ),
  //         const SizedBox(height: 10),
  //         Row(
  //           children: [
  //             Expanded(
  //               child: TextField(
  //                 style: TextStyle(color: theme.colorScheme.onSurface),
  //                 decoration: InputDecoration(
  //                   hintText: "Write a message...",
  //                   hintStyle: TextStyle(
  //                     color: theme.colorScheme.onSurface.withOpacity(0.6),
  //                   ),
  //                   filled: true,
  //                   fillColor: theme.colorScheme.background,
  //                   contentPadding: const EdgeInsets.symmetric(
  //                     horizontal: 14,
  //                     vertical: 12,
  //                   ),
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(30),
  //                     borderSide: BorderSide(
  //                       color: theme.colorScheme.outlineVariant,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(width: 8),
  //             IconButton(
  //               onPressed: () {},
  //               icon: Icon(Icons.send, color: theme.colorScheme.primary),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _actionButton(
    ThemeData theme,
    String text, {
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isDestructive
                ? theme.colorScheme.error
                : theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String getValidImage(String? url) {
    if (url == null || !url.startsWith("http")) {
      return "assets/images/placeholder.png"; // local placeholder
    }
    return url;
  }

  Widget _bottomActions(ThemeData theme) {
    final profileData = controller.aboutModel.value?.user;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Close button
        buildActionButton(Icons.chat, Colors.blueAccent, 26, () {
          if (profileData != null) {
            Get.to(
              () => ChatScreen(
                receiverId: widget.userId,
                receiverName:
                    "${profileData.name?.firstName ?? ""} ${profileData.name?.lastName ?? ""}",
                receiverImage: getValidImage(
                  profileData.photos != null && profileData.photos!.isNotEmpty
                      ? profileData.photos!.first
                      : profileData.profilePic,
                ),
              ),
            );
          }
        }),

        const SizedBox(width: 16),

        // Like button with animation
        Obx(() {
          final isLiked =
              controller.aboutModel.value?.user?.likedByMe ??
              false; // ✅ API se direct check

          return GestureDetector(
            onTap: () async {
              await userController.toggleFavorite(widget.userId);

              // Toggle ke baad API call karke refresh karna hoga
              await controller.fetchUserProfile(widget.userId);

              if (controller.aboutModel.value?.user?.likedByMe == true) {
                setState(() {
                  playHeartAnimation = true;
                });
              }
            },
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border_outlined,
                    color: Colors.redAccent,
                    size: 28,
                  ),
                ),

                if (playHeartAnimation)
                  Positioned(
                    top: -77,
                    child: Lottie.asset(
                      'assets/lotties/newHeart.json',
                      width: 200,
                      height: 200,
                      repeat: false,
                      onLoaded: (composition) {
                        Future.delayed(composition.duration, () {
                          if (mounted) {
                            setState(() => playHeartAnimation = false);
                          }
                        });
                      },
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  final ValueNotifier<double> _buttonScale = ValueNotifier(1.0);
  Widget buildActionButton(
    IconData icon,
    Color color,
    double size,
    VoidCallback onTap,
  ) {
    return ValueListenableBuilder<double>(
      valueListenable: _buttonScale,
      builder: (context, scale, child) {
        return GestureDetector(
          onTapDown: (_) => _buttonScale.value = 0.9,
          onTapUp: (_) {
            _buttonScale.value = 1.0;
            onTap();
          },
          onTapCancel: () => _buttonScale.value = 1.0,
          child: AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 150),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child: Icon(icon, color: color, size: size),
              ),
            ),
          ),
        );
      },
    );
  }
}
