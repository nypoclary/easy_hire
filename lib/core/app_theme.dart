import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryNavyBlue = Color(0xFF000F50);

  static final ThemeData appTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryNavyBlue,
      primary: primaryNavyBlue,
    ),
    // Define button themes to use your color
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryNavyBlue,
        foregroundColor: Colors.white,
      ),
    ),
    appBarTheme: AppBarTheme(
      // fallback in case colorScheme is not used
      titleTextStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        color: Colors.black, // set based on your needs
      ),
    ),
    //scaffoldBackgroundColor: Colors.grey[100],
  );
}
