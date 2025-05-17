import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData appTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.indigo.shade900,
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