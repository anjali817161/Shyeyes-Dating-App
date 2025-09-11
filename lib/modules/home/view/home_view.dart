import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shyeyes/modules/about/controller/about_controller.dart';
import 'package:shyeyes/modules/about/model/about_model.dart';
import 'package:shyeyes/modules/about/view/about_view.dart';
import 'package:shyeyes/modules/chats/model/chat_model.dart';
import 'package:shyeyes/modules/chats/view/chats_view.dart';
import 'package:shyeyes/modules/chats/view/heart_shape.dart';
import 'package:shyeyes/modules/chats/view/subscription_bottomsheet.dart';
import 'package:shyeyes/modules/dashboard/controller/dashboard_controller.dart';
import 'package:shyeyes/modules/explore/view/explore_view.dart';
import 'package:shyeyes/modules/tabView/view/likes_screen.dart';
import 'package:shyeyes/modules/dashboard/widget/heartAnimationWidget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AboutController controller = Get.put(AboutController());
  final usersController = Get.find<ActiveUsersController>();
  final ValueNotifier<double> _buttonScale = ValueNotifier(1.0);
  List<bool> isLikedList = [];
  int _currentIndex = 0;
  bool isHeartAnimating = false;
  bool isLiked = false;

  List<bool> playHeartAnimationList = [];
  // final List<String> images = [
  //   'assets/images/profile_image1.png',
  //   'assets/images/profile_image2.png',
  //   'assets/images/profile_image3.png',
  //   'assets/images/profile_image4.png',
  //   'assets/images/profile_image5.png',
  // ];

  @override
  void initState() {
    super.initState();
    isLikedList = List.filled(usersController.activeUsers.length, false);
    playHeartAnimationList = List.filled(
      usersController.activeUsers.length,
      false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    UserModel dummyUser = UserModel(
      name: 'Shaan',
      imageUrl: 'https://i.pravatar.cc/150?img=65',
      lastMessage: "Hey, how are you?🥰",
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (usersController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (usersController.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              usersController.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (usersController.activeUsers.isEmpty) {
          return const Center(child: Text("No active users found"));
        }
        return Stack(
          children: [
            CarouselSlider.builder(
              slideTransform: CubeTransform(rotationAngle: 0.0),
              scrollDirection: Axis.vertical,

              itemCount: usersController.activeUsers.length,
              slideBuilder: (index) {
                final profile = usersController.activeUsers[index];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    GestureDetector(
                      child: profile.image != null && profile.image!.isNotEmpty
                          ? Image.network(
                              profile.image!,
                              fit: BoxFit.cover,
                            ) // If API gives URL
                          : Image.asset(
                              "assets/images/profile_image3.png",
                              fit: BoxFit.cover,
                            ),

                      onDoubleTap: () {
                        setState(() {
                          isHeartAnimating = true;
                          isLikedList[index] = true;
                          playHeartAnimationList[index] = true;
                        });
                      },
                    ),
                    // Opacity(opacity: isHeartAnimating ? 1 : 0,

                    // child: HeartAnimationWidget(
                    //   isAnimating: isHeartAnimating,
                    //   duration: const Duration(milliseconds: 700),
                    //   child: Icon(
                    //     Icons.favorite,
                    //     color: Colors.red,
                    //     size: 100,
                    //   ),
                    //   onEnd: ()=> setState(() {
                    //     isHeartAnimating = false;
                    //   }
                    //   ),
                    // ),
                    // ),

                    // Container(
                    //   decoration: BoxDecoration(
                    //     gradient: LinearGradient(
                    //       colors: [
                    //         Colors.transparent,
                    //         Colors.black.withOpacity(0.8),
                    //       ],
                    //       begin: Alignment.topCenter,
                    //       end: Alignment.bottomCenter,
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 140,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.name!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.school, color: Colors.white, size: 18),
                              SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  profile.about!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Obx(() {
                            final receiverId = profile.id ?? 0;
                            final status =
                                usersController.requestStatus[receiverId] ??
                                "none";
                            final loading =
                                usersController.Loading[receiverId] ?? false;

                            return ElevatedButton(
                              onPressed: loading
                                  ? null
                                  : () {
                                      if (status == "pending") {
                                        usersController.cancelRequest(
                                          receiverId,
                                        );
                                      } else {
                                        usersController.sendRequest(receiverId);
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: status == "pending"
                                    ? Colors.red
                                    : theme.colorScheme.primary,
                                foregroundColor: Colors.white,
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                minimumSize: const Size(120, 30),
                              ),
                              child: loading
                                  ? const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          status == "pending"
                                              ? Icons.cancel
                                              : Icons.send,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          status == "pending"
                                              ? "Cancel Request"
                                              : "Send Request",
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                            );
                          }),
                        ],
                      ),
                    ),

                    Positioned(
                      bottom: 50,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildActionButton(
                            isLikedList[index]
                                ? Icons.favorite
                                : Icons.favorite_border,
                            Colors.redAccent,
                            32,
                            () {
                              setState(() {
                                isLikedList[index] = !isLikedList[index];
                                if (isLikedList[index]) {
                                  playHeartAnimationList[index] = true;
                                }
                              });
                            },
                            playAnimation: playHeartAnimationList[index],
                            index: index,
                          ),
                          buildActionButton(Icons.call, Colors.teal[400]!, 30, () {
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
                                      SizedBox(height: 10),
                                      Text(
                                        'Subscription Required',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.primary,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'To Proceed with Audio call, You have to Subscribe your Plan.',
                                        style: TextStyle(fontSize: 16),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                    top: Radius.circular(20),
                                                  ),
                                            ),
                                            builder: (context) =>
                                                const SubscriptionBottomSheet(),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              theme.colorScheme.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 32,
                                            vertical: 12,
                                          ),
                                        ),
                                        child: Text(
                                          'Subscribe Now',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                          buildActionButton(
                            Icons.video_call,
                            Colors.lightBlueAccent,
                            32,
                            () {
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
                                        SizedBox(height: 10),
                                        Text(
                                          'Subscription Required',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: theme.colorScheme.primary,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'To Proceed with Video call, You have to Subscribe your Plan.',
                                          style: TextStyle(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                      top: Radius.circular(20),
                                                    ),
                                              ),
                                              builder: (context) =>
                                                  const SubscriptionBottomSheet(),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                theme.colorScheme.primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 32,
                                              vertical: 12,
                                            ),
                                          ),
                                          child: Text(
                                            'Subscribe Now',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          buildActionButton(
                            Icons.send,
                            Colors.blueAccent,
                            26,
                            () {
                              Get.to(() => ChatScreen(user: dummyUser));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },

              enableAutoSlider: false,
              unlimitedMode: true,
              initialPage: 0,
              onSlideChanged: (index) {
                setState(() {
                  _currentIndex = index % usersController.activeUsers.length;
                });
              },
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Icon(
                      //   Icons.local_fire_department,
                      //   color: Colors.white,
                      //   size: 28,
                      // ),
                      const SizedBox(width: 8),
                      Image.asset('assets/images/logo.png', height: 40),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 18),
                      IconButton(
                        icon: Icon(Icons.share, color: Colors.teal, size: 24),
                        onPressed: () {
                          if (_currentIndex <
                              usersController.activeUsers.length) {
                            final currentProfile =
                                usersController.activeUsers[_currentIndex];

                            final String shareText =
                                '''
${currentProfile.name! ?? 'N/A'}, ${currentProfile.age! ?? 'N/A'}

${currentProfile.location! ?? 'N/A'}
About: ${currentProfile.about! ?? 'N/A'}


Check out this profile on ShyEyes App!
''';

                            Share.share(shareText);
                          }
                        },
                      ),

                      const SizedBox(width: 18),
                      Icon(Icons.flash_on, color: Colors.amber, size: 24),
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

  Widget buildActionButton(
    IconData icon,
    Color color,
    double size,
    VoidCallback onTap, {
    bool playAnimation = false,
    int? index,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTapDown: (_) => _buttonScale.value = 0.9,
          onTapUp: (_) {
            _buttonScale.value = 1.0;
            onTap();
          },
          onTapCancel: () => _buttonScale.value = 1.0,
          child: ValueListenableBuilder<double>(
            valueListenable: _buttonScale,
            builder: (context, scale, child) {
              return AnimatedScale(
                scale: scale,
                duration: const Duration(milliseconds: 150),
                child: Container(
                  decoration: BoxDecoration(
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
              );
            },
          ),
        ),

        // Lottie animation overlay
        if (playAnimation)
          Positioned(
            top: -48,
            child: Lottie.asset(
              'assets/lotties/newHeart.json',
              width: 150,
              height: 150,
              repeat: false,
              onLoaded: (composition) {
                Future.delayed(composition.duration, () {
                  if (mounted && index != null) {
                    setState(() => playHeartAnimationList[index] = false);
                  }
                });
              },
            ),
          ),
      ],
    );
  }
}
