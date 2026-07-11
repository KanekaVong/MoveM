import 'package:flutter/material.dart';


class AppColors {
  AppColors._();

  static const gradientBackground = LinearGradient(
    colors: [
      Color(0xFF003AB3),
      Color(0xFF00297B),
      Color(0xFF001743),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );



  // ─── Light Mode ───
  static const lightPrimary = Color(0xFF1A73E8);



  static const lightOnPrimary = Colors.white;
  static const lightSecondary = Color(0xFF4CAF50);
  static const lightOnSecondary = Colors.white;
  static const lightSurface = Color(0xFFF8F9FA);
  static const lightOnSurface = Color(0xFF1C1B1F);
  static const lightBackground = Colors.white;
  static const lightError = Color(0xFFE53935);
  static const lightOnError = Colors.white;

  // ─── Dark Mode ───
  static const darkPrimary = Color(0xFF8AB4F8);




  static const darkOnPrimary = Color(0xFF003A75);
  static const darkSecondary = Color(0xFF81C784);
  static const darkOnSecondary = Color(0xFF1B5E20);
  static const darkSurface = Color(0xFF1E1E1E);
  static const darkOnSurface = Color(0xFFE3E3E3);
  static const darkBackground = Color(0xFF121212);
  static const darkError = Color(0xFFEF9A9A);
  static const darkOnError = Color(0xFF601410);
}
