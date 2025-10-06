import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shyeyes/modules/Voice_call/view/voice_call.dart';
import 'package:shyeyes/modules/about/controller/about_controller.dart';
import 'package:shyeyes/modules/about/model/about_model.dart';
import 'package:shyeyes/modules/about/view/about_view.dart';
import 'package:shyeyes/modules/chats/view/heart_shape.dart';
import 'package:shyeyes/modules/chats/view/subscription_bottomsheet.dart';
import 'package:shyeyes/modules/dashboard/controller/dashboard_controller.dart';
import 'package:shyeyes/modules/dashboard/model/bestmatch_model.dart';
import 'package:shyeyes/modules/dashboard/model/dashboard_model.dart';
import 'package:shyeyes/modules/profile/view/current_plan.dart';
import 'package:shyeyes/modules/videocall_screen/view/videocall.dart';

enum HomeViewType { activeUsers, bestMatches }

class HomeView extends StatefulWidget {
  final HomeViewType viewType;

  const HomeView({Key? key, required this.viewType}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AboutController controller = Get.put(AboutController());
  final ActiveUsersController usersController = Get.put(
    ActiveUsersController(),
  );
  final ValueNotifier<double> _buttonScale = ValueNotifier(1.0);

  int _currentIndex = 0;

  // final AboutModel dummyUsers = AboutModel(
  //   image: 'assets/images/profile_image1.png',
  //   name: 'Shaan',
  //   age: 25,
  //   distance: '2 km away',
  //   job: 'Software Engineer',
  //   college: 'IIT Delhi',
  //   location: 'New Delhi',
  //   about: 'Loves traveling and coffee.',
  //   interests: ['Music', 'Travel', 'Coding', 'Gaming'],
  //   pets: 'Dog',
  //   drinking: 'Socially',
  //   smoking: 'No',
  //   workout: 'Daily',
  //   zodiac: 'Leo',
  //   education: 'Masters',
  //   vaccine: 'Yes',
  //   communication: 'English, Hindi',
  //   height: '',
  //   active: '',
  // );

  @override
  void initState() {
    super.initState();
    if (widget.viewType == HomeViewType.activeUsers) {
      usersController.fetchActiveUsers();
    } else if (widget.viewType == HomeViewType.bestMatches) {
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
              slideBuilder: (index) {
                final user = users[index];

                final String imageUrl;
                final String name;
                final int age;
                final String location;
                final String about;
                final String userId;

                if (widget.viewType == HomeViewType.activeUsers) {
                  final Users userData = user as Users;
                  userId = userData.id ?? '';
                  imageUrl =
                      (userData.profilePic != null &&
                          userData.profilePic!.isNotEmpty)
                      ? "https://shyeyes-b.onrender.com/uploads/${userData.profilePic}"
                      : "https://picsum.photos/seed/$index/600/800"; // stable fallback

                  name =
                      "${userData.name?.firstName ?? ''} ${userData.name?.lastName ?? ''}";

                  age = userData.age ?? 0;
                  if (userData.location != null) {
                    location =
                        '${userData.location!.city ?? ''}, ${userData.location!.country ?? ''}';
                    if (location.trim() == ',') 'N/A';
                  } else {
                    location = 'N/A';
                  }
                } else {
                  final BestmatchModel match = user as BestmatchModel;
                  userId = match.id ?? '';
                  name = match.name ?? '';

                  // Use only profilePic with a fallback
                  imageUrl =
                      (match.profilePic != null && match.profilePic!.isNotEmpty)
                      ? "https://shyeyes-b.onrender.com/uploads/${match.profilePic}"
                      : "https://picsum.photos/seed/$index/600/800"; // stable fallback

                  age = match.age ?? 0;
                  location = match.location != null
                      ? "${match.location!.street ?? ''},${match.location!.city ?? ''},${match.location!.state ?? ''}, ${match.location!.country ?? ''}"
                      : 'N/A';
                  about = match.bio ?? '';
                }

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    GestureDetector(
                      onDoubleTap: () async {
                        await usersController.toggleFavorite(userId);
                      },
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                    "assets/images/profile_image1.png",
                                    fit: BoxFit.cover,
                                  ),
                            )
                          : Image.asset(
                              "assets/images/profile_image1.png",
                              fit: BoxFit.cover,
                            ),
                    ),

                    Obx(() {
                      if (usersController.recentlyLikedUsers.contains(userId)) {
                        return Center(
                          child: Lottie.asset(
                            'assets/lotties/Heartbeating.json',
                            width: 600,
                            height: 600,
                            repeat: false,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
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
                              color: Colors.black.withOpacity(0.2),
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
                                          const Icon(
                                            Icons.location_on,
                                            color: Colors.white,
                                            size: 18,
                                          ),
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 24,
                                                    vertical: 12,
                                                  ),
                                            ),
                                            onPressed: () {
                                              Get.to(AboutView(userId: userId));
                                            },
                                            child: const Text(
                                              "View Profile",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Obx(() {
                                            final userId =
                                                widget.viewType ==
                                                    HomeViewType.activeUsers
                                                ? (user as Users).id ?? ""
                                                : (user as BestmatchModel).id ??
                                                      "";

                                            final status =
                                                widget.viewType ==
                                                    HomeViewType.activeUsers
                                                ? ((user as Users)
                                                              .friendshipStatus ??
                                                          "none")
                                                      .toLowerCase()
                                                : ((user as BestmatchModel)
                                                              .status ??
                                                          "none")
                                                      .toLowerCase();

                                            final isLoading =
                                                usersController
                                                    .requestLoading[userId] ??
                                                false;

                                            Widget buildStatusText(
                                              IconData icon,
                                              String text,
                                              Color color,
                                            ) {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: color.withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: color,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      icon,
                                                      color: color,
                                                      size: 16,
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      text,
                                                      style: TextStyle(
                                                        color: color,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }

                                            if (status == "friend" ||
                                                status == "accepted") {
                                              return buildStatusText(
                                                Icons.check_circle,
                                                "Friends",
                                                Colors.green,
                                              );
                                            }
                                            //  else if (status == "requested") {
                                            //   // ✅ Sirf text
                                            //   return buildStatusText(
                                            //     Icons.hourglass_top,
                                            //     "Requested",
                                            //     Colors.orange,
                                            //   );
                                            // }
                                            else if (status == "requested") {
                                              // Cancel button (image)
                                              return GestureDetector(
                                                onTap: isLoading
                                                    ? null
                                                    : () async {
                                                        await usersController
                                                            .sendRequest(
                                                              userId,
                                                            ); // cancel karega
                                                      },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                    left: 12,
                                                    top: 8,
                                                  ),
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            blurRadius: 6,
                                                            offset: Offset(
                                                              0,
                                                              2,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                  padding: const EdgeInsets.all(
                                                    12,
                                                  ),
                                                  child: isLoading
                                                      ? const SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                              ),
                                                        )
                                                      : Image.asset(
                                                          "assets/images/png_cancelr.png",
                                                          scale: 17,
                                                        ),
                                                ),
                                              );
                                            } else if (status == "blocked") {
                                              return buildStatusText(
                                                Icons.block,
                                                "Blocked",
                                                Colors.red,
                                              );
                                            } else if (status == "unblocked") {
                                              return buildStatusText(
                                                Icons.lock_open,
                                                "Unblocked",
                                                Colors.grey,
                                              );
                                            } else if (status == "none" ||
                                                status == "cancelled" ||
                                                status == "new") {
                                              // ✅ Send request (image button only)
                                              return GestureDetector(
                                                onTap: isLoading
                                                    ? null
                                                    : () async {
                                                        await usersController
                                                            .sendRequest(
                                                              userId,
                                                            ); // send request karega
                                                      },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                    left: 12,
                                                    top: 8,
                                                  ),
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            blurRadius: 6,
                                                            offset: Offset(
                                                              0,
                                                              2,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                  padding: const EdgeInsets.all(
                                                    12,
                                                  ),
                                                  child: isLoading
                                                      ? const SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                              ),
                                                        )
                                                      : Image.asset(
                                                          "assets/images/invite.png",
                                                          scale: 17,
                                                        ),
                                                ),
                                              );
                                            } else if (status == "pending") {
                                              // ✅ Default → Requested text
                                              return buildStatusText(
                                                Icons.hourglass_top,
                                                "Requested",
                                                Colors.green,
                                              );
                                            } else {
                                              // ✅ Default → Requested text
                                              return buildStatusText(
                                                Icons.hourglass_top,
                                                "Requested",
                                                Colors.green,
                                              );
                                            }
                                          }),
                                        ],
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

                    Positioned(
                      bottom: 50,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(() {
                            // Determine users list based on viewType
                            final users =
                                widget.viewType == HomeViewType.activeUsers
                                ? usersController.users
                                : usersController.matches;

                            if (users.isEmpty) return const SizedBox.shrink();

                            // Clamp _currentIndex to valid range
                            final currentIndexSafe =
                                (_currentIndex < users.length)
                                ? _currentIndex
                                : users.length - 1;

                            // Get current user safely
                            final currentUser =
                                widget.viewType == HomeViewType.activeUsers
                                ? (users[currentIndexSafe] as Users)
                                : (users[currentIndexSafe] as BestmatchModel);

                            final String userId =
                                widget.viewType == HomeViewType.activeUsers
                                ? (currentUser as Users).id ?? ""
                                : (currentUser as BestmatchModel).id ?? "";

                            // Determine if user is liked (API likedByMe or recently liked locally)
                            final bool isLiked =
                                widget.viewType == HomeViewType.activeUsers
                                ? ((currentUser as Users).likedByMe ?? false) ||
                                      usersController.recentlyLikedUsers
                                          .contains(userId)
                                : ((currentUser as BestmatchModel).likedByMe ??
                                          false) ||
                                      usersController.recentlyLikedUsers
                                          .contains(userId);

                            return buildActionButton(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              isLiked ? Colors.red : Colors.grey,
                              30,
                              () async {
                                // Optimistic toggle
                                if (isLiked) {
                                  usersController.recentlyLikedUsers.remove(
                                    userId,
                                  );
                                } else {
                                  usersController.recentlyLikedUsers.add(
                                    userId,
                                  );
                                }

                                // Call API after local update
                                try {
                                  await usersController.toggleFavorite(userId);
                                } catch (e) {
                                  // Rollback if API fails
                                  if (isLiked) {
                                    usersController.recentlyLikedUsers.add(
                                      userId,
                                    );
                                  } else {
                                    usersController.recentlyLikedUsers.remove(
                                      userId,
                                    );
                                  }
                                }
                              },
                            );
                          }),

                          buildActionButton(
                            Icons.call,
                            Colors.teal[400]!,
                            30,
                            () {
                              Get.to(AudioCallScreen());
                              // _showSubscriptionDialog(context, theme, true);
                            },
                          ),
                          buildActionButton(
                            Icons.video_call,
                            Colors.lightBlueAccent,
                            32,
                            () {
                              Get.to(VideoCallScreen());
                              //_showSubscriptionDialog(context, theme, false);
                            },
                          ),
                          buildActionButton(
                            Icons.chat,
                            Colors.blueAccent,
                            26,
                            () {
                              // Navigate to chat
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              itemCount: users.length,
              enableAutoSlider: false,
              unlimitedMode: true,
              initialPage: 0,
              onSlideChanged: (index) {
                setState(() => _currentIndex = index);
              },
            ),
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
                        icon: const Icon(
                          Icons.share,
                          color: Colors.teal,
                          size: 24,
                        ),
                        onPressed: () {
                          if (users.isEmpty) return;
                          final currentUser = users[_currentIndex];
                          final String shareText =
                              widget.viewType == HomeViewType.activeUsers
                              ? "${(currentUser as Users).name ?? ''}, ${(currentUser).age}\n${(currentUser).location != null ? "${(currentUser).location!.city ?? ''}, ${(currentUser).location!.country ?? ''}" : ''}\n\nCheck out this profile on ShyEyes App!"
                              : "${(currentUser as BestmatchModel).name ?? ''}, ${(currentUser).age}\n\nCheck out this profile on ShyEyes App!";

                          Share.share(shareText);
                        },
                      ),
                      const SizedBox(width: 18),
                      const Icon(Icons.flash_on, color: Colors.amber, size: 24),
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

  void _showSubscriptionDialog(
    BuildContext context,
    ThemeData theme,
    bool isAudio,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: HeartShapeBorder(),
        backgroundColor: theme.colorScheme.secondary,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: theme.colorScheme.primary,
                size: 50,
              ),
              const SizedBox(height: 10),
              Text(
                'Subscription Required',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                isAudio
                    ? 'To proceed with Audio call, you have to subscribe.'
                    : 'To proceed with Video call, you have to subscribe.',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) => const SubscriptionBottomSheet(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Subscribe Now',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
