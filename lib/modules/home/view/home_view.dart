import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shyeyes/modules/about/controller/about_controller.dart';
import 'package:shyeyes/modules/about/model/about_model.dart';
import 'package:shyeyes/modules/about/view/about_view.dart';
import 'package:shyeyes/modules/chats/model/chat_model.dart';
import 'package:shyeyes/modules/chats/view/chats_view.dart';
import 'package:shyeyes/modules/chats/view/heart_shape.dart';
import 'package:shyeyes/modules/chats/view/subscription_bottomsheet.dart';
import 'package:shyeyes/modules/explore/view/explore_view.dart';
import 'package:shyeyes/modules/tabView/view/likes_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AboutController controller = Get.put(AboutController());

  // final List<String> images = [
  //   'assets/images/profile_image1.png',
  //   'assets/images/profile_image2.png',
  //   'assets/images/profile_image3.png',
  //   'assets/images/profile_image4.png',
  //   'assets/images/profile_image5.png',
  // ];

  final List<AboutModel> profiles = [
    AboutModel(
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
    ),
    AboutModel(
      image: 'assets/images/profile_image2.png',
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
    ),
    AboutModel(
      image: 'assets/images/profile_image3.png',
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
    ),
    AboutModel(
      image: 'assets/images/profile_image4.png',
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
    ),
    AboutModel(
      image: 'assets/images/profile_image5.png',
      name: 'Eshaan',
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
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Show dialog only once after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showWelcomeDialog(context);
    });
  }

  void showWelcomeDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Lottie.asset(
                    'assets/lotties/congratulation.json',
                    fit: BoxFit.cover,
                    repeat: true,
                  ),
                ),

                // Foreground Content
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                    maxWidth: MediaQuery.of(context).size.width * 0.85,
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset(
                          'assets/lotties/love2.json',
                          width: 180,
                          height: 180,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Welcome to ShyEyes!",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.deepPurple,
                            letterSpacing: 1.2,
                            fontFamily: 'Montserrat',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Start exploring new connections.",
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.black87,
                            fontFamily: 'Poppins',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 4,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            "Continue",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    int _currentIndex = 0;
    UserModel dummyUser = UserModel(
      name: 'Shaan',
      imageUrl: 'https://i.pravatar.cc/150?img=65',
      lastMessage: "Hey, how are you?🥰",
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CarouselSlider.builder(
            slideTransform: CubeTransform(rotationAngle: 0.0),
            scrollDirection: Axis.vertical,
            slideBuilder: (index) {
              final profile = profiles[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final controller = Get.find<AboutController>();
                      controller.setProfile(profile);
                      await Get.to(() => AboutView());
                    },
                    child: Image.asset(profile.image, fit: BoxFit.cover),
                  ),
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
                    bottom: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Shaan, 25",
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
                                "Indian Institute of Technology, Delhi",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            itemCount: profiles.length,
            enableAutoSlider: false,
            unlimitedMode: true,
            initialPage: 0,
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
                    Icon(
                      Icons.notifications_none,
                      color: Colors.indigoAccent,
                      size: 24,
                    ),
                    const SizedBox(width: 18),
                    Icon(Icons.share, color: Colors.teal, size: 24),
                    const SizedBox(width: 18),
                    Icon(Icons.flash_on, color: Colors.amber, size: 24),
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 25,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildActionButton(Icons.favorite, Colors.redAccent, 32, () {}),
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
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (context) =>
                                      const SubscriptionBottomSheet(),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
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
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    builder: (context) =>
                                        const SubscriptionBottomSheet(),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
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
                buildActionButton(Icons.send, Colors.blueAccent, 26, () {
                  Get.to(() => ChatScreen(user: dummyUser));
                }),
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   selectedItemColor: theme.primaryColor,
      //   unselectedItemColor: Colors.grey,
      //   currentIndex: _currentIndex,
      //   showUnselectedLabels: true,
      //   onTap: (index) {
      //     setState(() => _currentIndex = index);
      //     if (index == 0) {
      //       Get.to(() => HomeView());
      //     }
      //     if (index == 1) {
      //       Get.to(() => ExploreView());
      //     }
      //     if (index == 2) {
      //       Get.to(() => LikesScreen());
      //     }
      //     if (index == 3) {
      //       Get.to(() => ());
      //     }
      //   },
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.local_fire_department),
      //       label: "Home",
      //     ),
      //     BottomNavigationBarItem(icon: Icon(Icons.search), label: "Explore"),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.favorite_border),
      //       label: "Likes",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.chat_bubble_outline),
      //       label: "Chats",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person_outline),
      //       label: "Profile",
      //     ),
      //   ],
      // ),
    );
  }

  Widget buildActionButton(
    IconData icon,
    Color color,
    double size,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.white,
        child: Icon(icon, color: color, size: size),
      ),
    );
  }
}
