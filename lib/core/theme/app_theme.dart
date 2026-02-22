import 'package:flutter/material.dart';

class AppTheme {
  // Stitch Colors
  static const Color primaryColor = Color(0xFF137FEC); // From Onboarding #137fec
  static const Color primarySecondaryColor = Color(0xFF6366F1); // From Settings #6366f1
  
  static const Color lightBackground = Color(0xFFF6F7F8); // From Onboarding #f6f7f8
  static const Color lightSurface = Colors.white; // White
  
  static const Color darkBackground = Color(0xFF101922); // From Onboarding #101922
  static const Color darkSurface = Color(0xFF192633); // From Onboarding #192633
  
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: primarySecondaryColor,
        surface: lightSurface,
        background: lightBackground,
      ),
      fontFamily: 'Inter',
      useMaterial3: true,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Color(0xFF1E293B)), // Slate 800
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: primarySecondaryColor,
        surface: darkSurface,
        background: darkBackground,
      ),
      fontFamily: 'Inter',
      useMaterial3: true,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white),
      ),
    );
  }
}
