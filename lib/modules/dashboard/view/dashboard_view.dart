import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shyeyes/modules/about/model/about_model.dart';
import 'package:shyeyes/modules/chats/model/chat_model.dart';
import 'package:shyeyes/modules/chats/view/chats_view.dart';
import 'package:shyeyes/modules/chats/view/heart_shape.dart';
import 'package:shyeyes/modules/chats/view/subscription_bottomsheet.dart';
import 'package:shyeyes/modules/dashboard/controller/dashboard_controller.dart';
import 'package:shyeyes/modules/dashboard/view/drawer/custom_drawer.dart';
import 'package:shyeyes/modules/home/view/home_view.dart';
import 'package:shyeyes/modules/notification/view/notification_view.dart';
import 'package:shyeyes/modules/profile/controller/profile_controller.dart';
import 'package:shyeyes/modules/widgets/music_controller.dart';
import 'package:shyeyes/modules/widgets/pulse_animation.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final MusicController musicController = Get.find<MusicController>();

  final ActiveUsersController usersController = Get.put(
    ActiveUsersController(),
  );

  final List<Map<String, String>> profiles = [
    {
      'name': 'Aarav Sharma',
      'active': '1 Day',
      'image': 'assets/images/profile_image1.png',
    },
    {
      'name': 'Priya Singh',
      'active': '2 Days',
      'image': 'assets/images/profile_image2.png',
    },
    {
      'name': 'Rahul Verma',
      'active': '3 Days',
      'image': 'assets/images/profile_image3.png',
    },
    {
      'name': 'Ananya Desai',
      'active': '5 Days',
      'image': 'assets/images/profile_image4.png',
    },
    {
      'name': 'Simran Kaur',
      'active': '1 Day',
      'image': 'assets/images/profile_image5.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    final ProfileController controller = Get.find<ProfileController>();
    controller.fetchProfile();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showWelcomeDialog(context);
      usersController.fetchActiveUsers();
      usersController.fetchBestMatches();
    });
  }

  void showWelcomeDialog(BuildContext context) async {
    final token = await SharedPrefHelper.getToken();
    final isShown = await SharedPrefHelper.isDialogAlreadyShown();

    final theme = Theme.of(context);

    if (token != null && !isShown) {
      Future.delayed(Duration.zero, () {
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
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await SharedPrefHelper.setDialogShown(true);
                              },
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
      });
    }
  }

  Widget sectionTitle(String title, VoidCallback onViewMorePressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextButton(
            onPressed: onViewMorePressed,
            child: const Text(
              'View More',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Color(0xFFDF314D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green, // Success
        behavior: SnackBarBehavior.floating, // Optional: floating style
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget profileList() {
    final theme = Theme.of(context);

    // Dummy user for ChatScreen
    UserModel dummyUser = UserModel(
      name: 'Shaan',
      imageUrl: 'https://i.pravatar.cc/150?img=65',
      lastMessage: "Hey, how are you?🥰",
    );

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (usersController.bestMatches.isEmpty) {
        return const Center(child: Text("No matches found"));
      }

      return SizedBox(
        height: 320,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          scrollDirection: Axis.horizontal,
          itemCount: usersController.bestMatches.length > 10
              ? 5
              : usersController.bestMatches.length,
          separatorBuilder: (context, index) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            final profile = usersController.bestMatches[index];

            return GestureDetector(
              onTap: () {
                // Get.to(() => AboutView(profileData: profile));
              },
              child: Container(
                width: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile image
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: profile.img != null
                          ? Image.network(
                              profile.img!,
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              "assets/images/profile_image3.png",
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),

                    const SizedBox(height: 8),

                    // Send Request button
                    Obx(() {
                      final receiverId = profile.userId ?? 0;
                      final status =
                          usersController.requestStatus[receiverId] ?? "none";
                      final loading =
                          usersController.requestLoading[receiverId] ?? false;

                      return ElevatedButton(
                        onPressed: loading
                            ? null
                            : () {
                                if (status == "pending") {
                                  usersController.cancelRequest(receiverId);
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

                    const SizedBox(height: 8),

                    // Name and status
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              profile.name ?? 'Unknown',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.orange,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const CircleAvatar(
                            radius: 4,
                            backgroundColor: Colors.green,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Age
                    Text(
                      profile.age != null
                          ? "${profile.age} years old"
                          : "Age not specified",
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),

                    const Spacer(),

                    // Bottom icons
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _iconCircle(Icons.call, () {
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
                          _iconCircle(Icons.chat_bubble_outline, () {
                            Get.to(() => ChatScreen(user: dummyUser));
                          }),
                          _iconCircle(Icons.videocam, () {
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  // Icon with circular background
  Widget _iconCircle(IconData icon, VoidCallback ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.pink.shade50,
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: Color(0xFFDF314D)),
      ),
    );
  }

  Widget circularProfileList(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.put(ActiveUsersController()); // inject controller

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.activeUsers.isEmpty) {
        return const Center(child: Text("No active users"));
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
          height: 130,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            scrollDirection: Axis.horizontal,
            itemCount: controller.activeUsers.length > 8
                ? 8
                : controller.activeUsers.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final profile = controller.activeUsers[index];
              return GestureDetector(
                onTap: () {
                  // Get.to(() => AboutView(profileData: profile));
                },
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 85,
                          height: 85,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.primary,
                              width: 2,
                            ),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 1,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child:
                                profile.image != null &&
                                    profile.image!.isNotEmpty
                                ? Image.network(
                                    profile.image!,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (
                                          context,
                                          error,
                                          stackTrace,
                                        ) => Image.asset(
                                          "assets/images/profile_image1.png",
                                          fit: BoxFit.cover,
                                        ),
                                  )
                                : Image.asset(
                                    "assets/images/profile_image2.png",
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),

                        Positioned(bottom: 4, right: 4, child: BlinkingDot()),
                      ],
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 72,
                      child: Text(
                        profile.name ?? "Unknown",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }

  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final user = controller.profile.value?.data;
    RxBool isPlaying = false.obs;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.colorScheme.secondary,
      appBar: AppBar(
        title: Image.asset('assets/images/logo.png', height: 40),
        backgroundColor: primary,
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                musicController.isPlaying.value
                    ? Icons.music_note
                    : Icons.music_off_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                musicController.toggleMusic();
              },
            ),
          ),
          IconButton(
            icon: GestureDetector(
              onTap: () {
                Get.to(() => NotificationsPage());
              },
              child: const Icon(Icons.notifications, color: Colors.white),
            ),
            onPressed: () {
              Get.snackbar("Notifications", "No new notifications");
            },
          ),
          const SizedBox(width: 1),
          Obx(() {
            final user = controller.profile.value?.data;
            print("Profile updated: ${user?.imageUrl}");

            if (user == null) {
              // 👇 If profile data is not yet available, return a placeholder avatar
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(
                    "https://via.placeholder.com/150",
                  ),
                ),
              );
            }
            return GestureDetector(
              onTap: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: CircleAvatar(
                  radius: 28,
                  backgroundImage:
                      (user?.imageUrl != null && user!.imageUrl!.isNotEmpty)
                      ? NetworkImage(user.imageUrl!)
                      : const NetworkImage("https://via.placeholder.com/150"),
                ),
              ),
            );
          }),
        ],
      ),
      endDrawer: const CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await profileList();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
            child: Container(
              color: theme.colorScheme.secondary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Banner Section
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/home_banner.png',
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Positioned(
                      //   top: -20,
                      //   left: -10,
                      //   child: Container(
                      //     padding: const EdgeInsets.all(8),
                      //     child: Image.asset(
                      //       '',
                      //       width: 90,
                      //       height: 90,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ✅ New Members
                  sectionTitle("Active Now", () {
                    Get.to(() => HomeView(viewType: HomeViewType.activeUsers));
                  }),
                  circularProfileList(context),

                  const SizedBox(height: 30),

                  // ✅ Active Members
                  sectionTitle("Best Matches for you", () {
                    Get.to(() => HomeView(viewType: HomeViewType.bestMatches));
                  }),
                  profileList(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
