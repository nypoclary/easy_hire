import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryNavyBlue = Color(0xFF000F50);
  static const Color textBoxBorderColor = Color(0xFF7FC3FF);

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
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: textBoxBorderColor),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: textBoxBorderColor, width: 2),
      ),
    ),
    //scaffoldBackgroundColor: Colors.grey[100],
  );
}
