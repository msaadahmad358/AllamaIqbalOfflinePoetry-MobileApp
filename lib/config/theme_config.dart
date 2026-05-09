import 'package:flutter/material.dart';
 
class AppTheme {
  static const primaryColor = Color(0xFFc8dfbf);
  static const darkColor = Color(0xFF0f2b05);
  static const accentColor = Color(0xFF0f2b05);
  static const secondaryColor = Color(0xFF0a5613);

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.transparent,
      primaryColor: primaryColor,
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryColor),
        titleTextStyle: TextStyle(
          color: darkColor,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
      ),
    );
  }
}
