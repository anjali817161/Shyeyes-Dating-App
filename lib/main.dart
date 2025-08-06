import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/auth/login/view/login_view.dart';
import 'package:shyeyes/modules/auth/signup/view/signup_view.dart';
import 'package:shyeyes/modules/splash/splash_screen.dart';

void main() {
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
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFDF314D),
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black54),
        ),
        useMaterial3: true,
      ),

      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      // getPages: [
      //   GetPage(name: '/login', page: () => LoginView()),
      //   GetPage(name: '/signup', page: () => SignUpView()),
      // ],
    );
  }
}
