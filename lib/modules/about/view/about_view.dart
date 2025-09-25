import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shyeyes/modules/about/controller/about_controller.dart';
import 'package:shyeyes/modules/about/widgets/block_bottomsheet.dart';
import 'package:shyeyes/modules/about/widgets/report_bottomsheet.dart';

class AboutView extends StatefulWidget {
  final String userId;

  const AboutView({super.key, required this.userId});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  final AboutController controller = Get.put(AboutController());

  bool isLiked = false;
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

      return Scaffold(
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
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child:
                        profileData.profilePic != null &&
                            profileData.profilePic!.isNotEmpty
                        ? Image.network(
                            profileData.profilePic!,
                            height: 320,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "assets/images/profile_image1.png",
                            height: 320,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),

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
                  if ((profileData.status ?? "").isNotEmpty) ...[
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
                    profileData.status ?? "",
                    style: TextStyle(color: onSecondaryColor.withOpacity(0.6)),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _infoTile(theme, Icons.work, "Job", profileData.bio ?? ""),
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

              // Share Button
              GestureDetector(
                onTap: () {
                  Share.share(
                    'Check out ${profileData.name?.firstName ?? ""}\'s profile!',
                    subject: 'Profile from ShyEyes',
                  );
                },
                child: _actionButton(theme, "Share Profile"),
              ),

              // Block Button
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (_) => BlockReasonBottomSheet(
                      onReasonSelected: (reason) {
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
                child: _actionButton(theme, "Block User"),
              ),

              // Report Button
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (_) => ReportReasonBottomSheet(
                      onReasonSelected: (reason) {
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
                child: _actionButton(theme, "Report", isDestructive: true),
              ),
              SizedBox(height: 40),
            ],
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

  Widget _bottomActions(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Close button
        buildActionButton(Icons.chat, Colors.blueAccent, 26, () {
          // Navigate to chat
        }),
        const SizedBox(width: 16),

        // Like button with animation
        GestureDetector(
          onTap: () {
            setState(() {
              isLiked = !isLiked;
              if (isLiked) {
                playHeartAnimation = true;
              }
            });
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
        ),
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
