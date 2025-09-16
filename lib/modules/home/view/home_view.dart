import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shyeyes/modules/about/controller/about_controller.dart';
import 'package:shyeyes/modules/about/model/about_model.dart';
import 'package:shyeyes/modules/about/view/about_view.dart';
import 'package:shyeyes/modules/chats/view/heart_shape.dart';
import 'package:shyeyes/modules/chats/view/subscription_bottomsheet.dart';
import 'package:shyeyes/modules/dashboard/controller/dashboard_controller.dart';
import 'package:shyeyes/modules/dashboard/model/dashboard_model.dart';

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

  final AboutModel dummyUsers = AboutModel(
    image: 'assets/images/profile_image1.png',
    name: 'Shaan',
    age: 25,
    distance: '2 km away',
    job: 'Software Engineer',
    college: 'IIT Delhi',
    location: 'New Delhi',
    about: 'Loves traveling and coffee.',
    interests: ['Music', 'Travel', 'Coding', 'Gaming'],
    pets: 'Dog',
    drinking: 'Socially',
    smoking: 'No',
    workout: 'Daily',
    zodiac: 'Leo',
    education: 'Masters',
    vaccine: 'Yes',
    communication: 'English, Hindi',
    height: '',
    active: '',
  );

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

        // Select the list based on viewType
        final users = widget.viewType == HomeViewType.activeUsers
            ? usersController.activeUsers
            : usersController.bestMatches;

        if (users.isEmpty) {
          return Center(
            child: Text(
              widget.viewType == HomeViewType.activeUsers
                  ? "No active users found"
                  : "No best matches found",
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

                // For bestMatches, user model is BestMatchModel, for activeUsers it's ActiveUser Model
                // So we need to handle both types safely
                final String? imageUrl;
                final String name;
                final int age;
                final String location;
                final String about;

                if (widget.viewType == HomeViewType.activeUsers) {
                  // ActiveUser Model assumed to have these fields
                  imageUrl = (user as dynamic).image;
                  name = (user as dynamic).name ?? 'Unknown';
                  age = (user as dynamic).age ?? 0;
                  location = (user as dynamic).location ?? 'N/A';
                  about = (user as dynamic).about ?? '';
                } else {
                  // BestMatchModel
                  imageUrl = (user as BestMatchModel).img;
                  name = user.name ?? 'Unknown';
                  age = user.age ?? 0;
                  location = 'N/A'; // No location info in BestMatchModel
                  about = '';
                }

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    /// Image with double-tap ❤️
                    GestureDetector(
                      onDoubleTap: () async {
                        if (widget.viewType == HomeViewType.activeUsers) {
                          final id = (user as dynamic).id;
                          if (id != null) {
                            await usersController.handleDoubleTap(id);
                          }
                        } else {
                          final userId = (user as BestMatchModel).userId;
                          if (userId != null) {
                            await usersController.handleDoubleTap(userId);
                          }
                        }
                      },
                      child: imageUrl != null && imageUrl.isNotEmpty
                          ? Image.network(imageUrl, fit: BoxFit.cover)
                          : Image.network(
                              "https://i.pravatar.cc/600?img=$index",
                              fit: BoxFit.cover,
                            ),
                    ),

                    /// ❤️ Animation
                    Obx(() {
                      final int? id;
                      if (widget.viewType == HomeViewType.activeUsers) {
                        id = (user as dynamic).id;
                      } else {
                        id = (user as BestMatchModel).userId;
                      }

                      if (id != null &&
                          usersController.recentlyLikedUsers.contains(id)) {
                        return Center(
                          child: Lottie.asset(
                            'assets/lotties/Heartbeating.json',
                            width: 600,
                            height: 600,
                            repeat: false,
                            onLoaded: (composition) {
                              Future.delayed(composition.duration, () {
                                usersController.recentlyLikedUsers.remove(id);
                              });
                            },
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    /// User Info + Profile Buttons
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 140,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            theme.colorScheme.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                      ),
                                      onPressed: () {
                                        Get.to(
                                          AboutView(profileData: dummyUsers),
                                        );
                                      },
                                      child: const Text(
                                        "View Profile",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                        left: 12,
                                        top: 8,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 6,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset(
                                        "assets/images/invite.png",
                                        scale: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Bottom Action Buttons
                    Positioned(
                      bottom: 50,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          /// ❤️ Favorite Button
                          Obx(
                            () => buildActionButton(
                              usersController.isLiked(
                                    widget.viewType == HomeViewType.activeUsers
                                        ? (user as dynamic).id ?? -1
                                        : (user as BestMatchModel).userId ?? -1,
                                  )
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              Colors.red,
                              30,
                              () async {
                                final id =
                                    widget.viewType == HomeViewType.activeUsers
                                    ? (user as dynamic).id
                                    : (user as BestMatchModel).userId;
                                if (id != null) {
                                  await usersController.toggleFavorite(id);
                                }
                              },
                            ),
                          ),

                          /// 📞 Call
                          buildActionButton(
                            Icons.call,
                            Colors.teal[400]!,
                            30,
                            () {
                              _showSubscriptionDialog(context, theme, true);
                            },
                          ),

                          /// Video Call
                          buildActionButton(
                            Icons.video_call,
                            Colors.lightBlueAccent,
                            32,
                            () {
                              _showSubscriptionDialog(context, theme, false);
                            },
                          ),

                          /// Chat
                          buildActionButton(
                            Icons.chat,
                            Colors.blueAccent,
                            26,
                            () {
                              // You can implement chat navigation here
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

                if (widget.viewType == HomeViewType.activeUsers) {
                  final user = users[index];
                  final id = (user as dynamic).id;
                  if (id != null && usersController.isLiked(id)) {
                    usersController.recentlyLikedUsers.add(id);

                    Future.delayed(const Duration(seconds: 2), () {
                      usersController.recentlyLikedUsers.remove(id);
                    });
                  }
                }
              },
            ),

            /// Top Bar
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
                              ? "${(currentUser as dynamic).name}, ${(currentUser as dynamic).age}\n${(currentUser as dynamic).location}\nAbout: ${(currentUser as dynamic).about}\n\nCheck out this profile on ShyEyes App!"
                              : "${(currentUser as BestMatchModel).name}, ${(currentUser as BestMatchModel).age}\n\nCheck out this profile on ShyEyes App!";
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

  /// Subscription Dialog
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
                    ? 'To Proceed with Audio call, You have to Subscribe your Plan.'
                    : 'To Proceed with Video call, You have to Subscribe your Plan.',
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

  /// Reusable Action Button
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
