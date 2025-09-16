import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/profile/controller/profile_controller.dart';
import 'package:shyeyes/modules/splash/splash_screen.dart';
import 'package:shyeyes/modules/home/controller/notificationController.dart';
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
      theme: ThemeData(
        colorScheme: ColorScheme(
          primary: const Color(0xFFDF314D), // Deep rose
          onPrimary: Colors.white,
          secondary: const Color(0xFFFFF3F3), // Light pink background
          onSecondary: Colors.black,
          background: const Color(0xFFFFF3F3), // App background
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF3F3),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFDF314D),
          foregroundColor: Color.fromRGBO(255, 255, 255, 1),
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFDF314D),
          foregroundColor: Colors.white
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black54),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
