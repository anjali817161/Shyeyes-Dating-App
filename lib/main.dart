import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/profile/controller/profile_controller.dart';
import 'package:shyeyes/modules/splash/splash_screen.dart';
import 'package:shyeyes/modules/home/controller/notificationController.dart';
import 'package:shyeyes/modules/theme/theme.dart';
import 'package:shyeyes/modules/widgets/music_controller.dart';

void main() {
  Get.put(ProfileController());
  Get.put(NotificationController());
  Get.put(MusicController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Color heartPink = const Color.fromARGB(
      255,
      227,
      90,
      149,
    ); // Heart pink
    final Color white = Colors.white;

    return GetMaterialApp(
      title: 'ShyEyes',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
