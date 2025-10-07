import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/edit_profile/edit_model.dart';
import 'package:shyeyes/modules/profile/controller/profile_controller.dart';
import 'package:shyeyes/modules/splash/splash_screen.dart';
import 'package:shyeyes/modules/home/controller/notificationController.dart';
import 'package:shyeyes/modules/theme/theme.dart';
import 'package:shyeyes/modules/widgets/Zego_service.dart';
import 'package:shyeyes/modules/widgets/music_controller.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

/// ✅ Global navigator key for ZegoUIKit
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 🔹 Assign navigatorKey to ZegoUIKit Call Service
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  /// 🔹 Initialize ZEGO Engine + ZIMKit
  await ZegoService.initZegoEngine();
  await ZIMKit().init(
    appID: ZegoService.appID,
    appSign: ZegoService.appSign,
  );

  /// 🔹 Initialize Controllers
  final profileController = Get.put(ProfileController());
  Get.put(NotificationController());
  Get.put(MusicController());

  /// 🔹 Fetch current logged-in user
  await profileController.fetchProfile();
  final user = profileController.profile2.value?.data?.edituser;

  if (user != null && user.id != null && user.id!.isNotEmpty) {
    print("👤 Logged in User => ${user.name?.firstName} (${user.id})");

    /// 🔹 Initialize Zego user connection (ZIMKit)
    await ZegoService.initZego(user);

    /// 🟢 Important Note:
    /// ZegoUIKitPrebuiltCallInvitationService().init() ab DashboardPage me initialize hoga
    /// jab user login ke baad successfully app ke main screen par aa chuka ho.
  } else {
    print("⚠️ No valid user found — skipping Zego login");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ShyEyes',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey, // ✅ Required for popup navigation
      home: const SplashScreen(),
      builder: (context, child) {
        /// 🔔 This widget automatically handles incoming call popups
        return Stack(
          children: [
            child!,
            ZegoUIKitPrebuiltCallMiniOverlayPage(
              contextQuery: () => context,
            ),
          ],
        );
      },
    );
  }
}
