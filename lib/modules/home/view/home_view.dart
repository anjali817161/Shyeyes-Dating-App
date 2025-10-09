import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shyeyes/modules/Friendlist/friendlistcontroller.dart';
import 'package:shyeyes/modules/Voice_call/view/voice_call.dart';
import 'package:shyeyes/modules/about/controller/about_controller.dart';
import 'package:shyeyes/modules/about/view/about_view.dart';
import 'package:shyeyes/modules/chats/view/subscription_bottomsheet.dart';
import 'package:shyeyes/modules/dashboard/controller/dashboard_controller.dart';
import 'package:shyeyes/modules/dashboard/model/bestmatch_model.dart';
import 'package:shyeyes/modules/dashboard/model/dashboard_model.dart';
import 'package:shyeyes/modules/profile/controller/profile_controller.dart';
import 'package:shyeyes/modules/videocall_screen/view/videocall.dart';
import 'package:shyeyes/modules/widgets/Zego_service.dart';

enum HomeViewType { activeUsers, bestMatches }

class HomeView extends StatefulWidget {
  final HomeViewType viewType;

  const HomeView({Key? key, required this.viewType}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final AboutController controller;
  late final ActiveUsersController usersController;
    final FriendController friendController = Get.put(FriendController(), permanent: true); // ✅ Added

  final ValueNotifier<double> _buttonScale = ValueNotifier(1.0);
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AboutController(), permanent: true);
    usersController = Get.put(ActiveUsersController(), permanent: true);

    if (widget.viewType == HomeViewType.activeUsers) {
      usersController.fetchActiveUsers();
    } else {
      usersController.fetchBestMatches();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (usersController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = widget.viewType == HomeViewType.activeUsers
            ? usersController.users
            : usersController.matches;

        if (users.isEmpty) {
          return Center(
            child: Text(
              widget.viewType == HomeViewType.activeUsers
                  ? "No active users found"
                  : "No best matches found",
              style: const TextStyle(fontSize: 16),
            ),
          );
        }

        return Stack(
          children: [
            CarouselSlider.builder(
              slideTransform: CubeTransform(rotationAngle: 0.0),
              scrollDirection: Axis.vertical,
              itemCount: users.length,
              enableAutoSlider: false,
              unlimitedMode: true,
              onSlideChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              slideBuilder: (index) {
                final user = users[index];

                final String userId;
                final String name;
                final int age;
                final String imageUrl;
                final String location;
                final String about;

                if (widget.viewType == HomeViewType.activeUsers) {
                  final Users u = user as Users;
                  userId = u.id ?? '';
                  name = "${u.name?.firstName ?? ''} ${u.name?.lastName ?? ''}";
                  age = u.age ?? 0;
                  imageUrl = (u.profilePic != null && u.profilePic!.isNotEmpty)
                      ? "https://shyeyes-b.onrender.com/uploads/${u.profilePic}"
                      : "https://picsum.photos/seed/$index/600/800";
                  location = u.location != null
                      ? "${u.location!.city ?? ''}, ${u.location!.country ?? ''}"
                      : "N/A";
                  about = "";
                } else {
                  final BestmatchModel m = user as BestmatchModel;
                  userId = m.id ?? '';
                  name = m.name ?? '';
                  age = m.age ?? 0;
                  imageUrl =
                      (m.profilePic != null && m.profilePic!.isNotEmpty)
                          ? "https://shyeyes-b.onrender.com/uploads/${m.profilePic}"
                          : "https://picsum.photos/seed/$index/600/800";
                  location = m.location != null
                      ? "${m.location!.city ?? ''}, ${m.location!.country ?? ''}"
                      : "N/A";
                  about = m.bio ?? '';
                }

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // 👆 Double-tap image to like/unlike
                    GestureDetector(
  onDoubleTap: () => usersController.toggleFavorite(userId),
  child: Image.network(
    imageUrl,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) =>
        Image.asset("assets/images/profile_image1.png", fit: BoxFit.cover),
  ),
),


                    // ❤️ Heart animation
                    Obx(() {
                      return usersController.recentlyLikedUsers.contains(userId)
                          ? Center(
                              child: Lottie.asset(
                                'assets/lotties/Heartbeating.json',
                                width: 300,
                                height: 300,
                                repeat: false,
                              ),
                            )
                          : const SizedBox.shrink();
                    }),

                    // 👤 Profile info
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 140,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$name, $age",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              color: Colors.white, size: 18),
                                          const SizedBox(width: 6),
                                          Flexible(
                                            child: Text(
                                              location,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      ElevatedButton(
                                        onPressed: () {
                                          Get.to(AboutView(userId: userId));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              theme.colorScheme.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 12),
                                        ),
                                        child: const Text(
                                          "View Profile",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ☎️ CALL + LIKE + CHAT buttons
                    Positioned(
                      bottom: 50,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // ❤️ Like Button (Toggle Like/Unlike)
                        Obx(() {
  final bool isLiked = usersController.isLiked(userId);
  return buildActionButton(
    Icons.favorite,
    isLiked ? Colors.red : Colors.grey,
    30,
    () => usersController.toggleFavorite(userId),
  );
}),

                          // 🎧 Audio Call
                          buildActionButton(
                            Icons.call,
                            Colors.teal[400]!,
                            30,
                            () async =>

                                await _makeAudioCall(user, userId, name),
                          ),

                          // 🎥 Video Call
                          buildActionButton(
                            Icons.video_call,
                            Colors.lightBlueAccent,
                            32,
                            () async =>
                                await _makeVideoCall(user, userId, name),
                          ),

                          // 💬 Chat Button
                          buildActionButton(
                            Icons.chat,
                            Colors.blueAccent,
                            26,
                            () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            // 🔝 Top Bar
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/images/logo.png', height: 40),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share,
                            color: Colors.teal, size: 24),
                        onPressed: () {
                          if (users.isEmpty) return;
                          final currentUser = users[_currentIndex];
                          final String shareText =
                              widget.viewType == HomeViewType.activeUsers
                                  ? "${(currentUser as Users).name?.firstName ?? ''}, ${currentUser.age}\nCheck out this profile on ShyEyes!"
                                  : "${(currentUser as BestmatchModel).name ?? ''}, ${currentUser.age}\nCheck out this profile on ShyEyes!";
                          Share.share(shareText);
                        },
                      ),
                      const SizedBox(width: 18),
                      const Icon(Icons.flash_on,
                          color: Colors.amber, size: 24),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // 🔈 AUDIO CALL
   Future<void> _makeAudioCall(dynamic user, String userId, String userName) async {
   try {
bool isFriend = friendController.friends.any((f) => f.userId == userId);

      if (!isFriend) {
        Get.snackbar('Warning', '⚠️ You are not a friend!');
        return;
      }

      await ZegoService.startCall(targetUser: user, isVideoCall: false);
    } catch (e) {
      Get.snackbar('Error', 'Failed to start audio call: $e');
    }
  }

  /// ✅ VIDEO CALL FUNCTION
  Future<void> _makeVideoCall(dynamic user, String userId, String userName) async {
    try {
    bool isFriend = friendController.friends.any((f) => f.userId == userId);

      if (!isFriend) {
        Get.snackbar('Warning', '⚠️ You are not a friend!');
        return;
      }

      await ZegoService.startCall(targetUser: user, isVideoCall: true);
    } catch (e) {
      Get.snackbar('Error', 'Failed to start video call: $e');
    }
  }

  // 💖 Reusable Button
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
