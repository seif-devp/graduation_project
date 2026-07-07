import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color lightPrimary = Color.fromARGB(255, 3, 59, 122);
  static const Color lightBackground = Color(0xFFF8F9FB);
  static const Color lightCard = Colors.white;
  static const Color lightText = Colors.black;
  static const Color lightSubText = Colors.grey;
  static const Color lightSuccess = Color(0xFF22C55E);
  static const Color lightWarning = Color(0xFFF59E0B);
  static const Color lightError = Color(0xFFEF4444);
  static const Color lightInfo = Color(0xFF3B82F6);


  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF4A90E2); // A lighter blue for dark mode
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkText = Colors.white;
  static const Color darkSubText = Colors.grey;
  static const Color darkSuccess = Color(0xFF22C55E);
  static const Color darkWarning = Color(0xFFF59E0B);
  static const Color darkError = Color(0xFFEF4444);
  static const Color darkInfo = Color(0xFF3B82F6);
}

extension ColorSchemeExtension on ColorScheme {
  Color get success => brightness == Brightness.light ? AppColors.lightSuccess : AppColors.darkSuccess;
  Color get warning => brightness == Brightness.light ? AppColors.lightWarning : AppColors.darkWarning;
  Color get error => brightness == Brightness.light ? AppColors.lightError : AppColors.darkError;
  Color get info => brightness == Brightness.light ? AppColors.lightInfo : AppColors.darkInfo;
}
