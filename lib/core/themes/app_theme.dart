
import 'package:flutter/material.dart';
import '/core/themes/color_utils.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Colors.white,
      ),
      cardColor: Colors.grey[200],
      textTheme: const TextTheme(
        labelSmall: TextStyle(color: Colors.black87),
        labelMedium: TextStyle(
          fontFamily: 'SF Pro',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.33,
          letterSpacing: 0.06,
        ),
      ),
      unselectedWidgetColor: Colors.grey,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF011131),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF011131),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Color(0xFF2A2A2A),
      ),
      cardColor: const Color(0xFF2B2725),
      textTheme: const TextTheme(
        labelSmall: TextStyle(color: Color(0xFFF9FAFB)),
        labelMedium: TextStyle(
          fontFamily: 'SF Pro',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.33,
          letterSpacing: 0.06,
        ),
      ),
      unselectedWidgetColor: Colors.grey,
    );
  }
}
