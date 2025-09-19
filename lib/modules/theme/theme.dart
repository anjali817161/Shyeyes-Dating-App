import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFDF314D); // Deep rose
  static const Color secondaryColor = Color(0xFFFFF3F3); // Light pink background
  static const Color backgroundColor = Color(0xFFFFF3F3);
  static const Color heartPink = Color.fromARGB(255, 227, 90, 149);
  static const Color white = Colors.white;

  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme(
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.black,
      background: backgroundColor,
      onBackground: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black54),
    ),
    useMaterial3: true,
  );
}
