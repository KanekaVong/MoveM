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

  static const lightPrimary = Color(0xFF1A73E8);
  static const lightOnPrimary = Colors.white;
  static const lightSecondary = Color(0xFF4CAF50);
  static const lightOnSecondary = Colors.white;
  static const lightSurface = Color(0xFFF8F9FA);
  static const lightOnSurface = Color(0xFF1C1B1F);
  static const lightBackground = Colors.white;
  static const lightError = Color(0xFFE53935);
  static const lightOnError = Colors.white;

  static const darkPrimary = Color(0xFF8AB4F8);
  static const darkOnPrimary = Color(0xFF003A75);
  static const darkSecondary = Color(0xFF81C784);
  static const darkOnSecondary = Color(0xFF1B5E20);
  static const darkSurface = Color(0xFF131B2F);
  static const darkOnSurface = Color(0xFFE3E3E3);
  static const darkBackground = Color(0xFF0F172A);
  static const darkError = Color(0xFFEF9A9A);
  static const darkOnError = Color(0xFF601410);

  static const taskDarkBackground = Color(0xFF0E0A07);
  static const taskFigmaCard = Color(0xFFD9D9D9);
  static const taskSlateCard = Color(0xFF131B2F);
  static const taskSlateDark = Color(0xFF1E293B);
  static const taskAvatarBg = Color(0xFF334155);
  static const taskBluePrimary = Color(0xFF3B82F6);
  static const taskGreenButton = Color(0xFF48A45B);
  static const taskGreenAccent = Color(0xFF4ADE80);
  static const taskYellowPriority = Color(0xFFFACC15);
  static const taskOrangePriority = Color(0xFFFBBF24);
  static const taskRedPriority = Color(0xFFF87171);
  static const taskRedError = Color(0xFFEF4444);
  static const taskTextMuted = Color(0xFF94A3B8);
  static const taskTextSecondary = Color(0xFF64748B);
  static const taskTextLight = Color(0xFFCBD5E1);
  static const taskTextBody = Color(0xFFE2E8F0);
}
