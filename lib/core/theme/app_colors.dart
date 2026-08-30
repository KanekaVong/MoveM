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

  // General App & Dark Palette
  static const slate950 = Color(0xFF070A13);
  static const slate900 = Color(0xFF0F172A);
  static const slate850 = Color(0xFF131B2F);
  static const slate800 = Color(0xFF1E293B);
  static const slate700 = Color(0xFF334155);
  static const slate600 = Color(0xFF475569);
  static const slate500 = Color(0xFF64748B);
  static const slate400 = Color(0xFF94A3B8);
  static const slate300 = Color(0xFFCBD5E1);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate100 = Color(0xFFF1F5F9);
  static const textMuted = Color(0xFFA0AAB2);

  // Status & Notification Colors
  static const blueAccent = Color(0xFF3B82F6);
  static const skyBlue = Color(0xFF38BDF8);
  static const skyBlueDark = Color(0xFF0284C7);
  static const emerald = Color(0xFF10B981);
  static const emeraldDark = Color(0xFF059669);
  static const emeraldLight = Color(0xFF34D399);
  static const amber = Color(0xFFF59E0B);
  static const violet = Color(0xFF8B5CF6);
  static const pink = Color(0xFFEC4899);
  static const gold = Color(0xFFEAB308);
  static const redError = Color(0xFFEF4444);

  // Primary / Navy Accents
  static const primaryBlueStart = Color(0xFF1E3A8A);
  static const primaryBlueEnd = Color(0xFF1D4ED8);

  // Chat & Comments Colors
  static const commentBlueStart = Color(0xFF2563EB);
  static const commentBlueEnd = Color(0xFF1D4ED8);
  static const commentGreenStart = Color(0xFF10B981);
  static const commentGreenEnd = Color(0xFF059669);
  static const commentInputBg = Color(0xFF1E293B);
  static const commentBarBg = Color(0xFF0F172A);

  // Social Brand Colors
  static const socialFacebook = Color(0xFF1877F2);
  static const socialTelegram = Color(0xFF2AABEE);
  static const socialMessengerStart = Color(0xFF00B2FF);
  static const socialMessengerEnd = Color(0xFF006AFF);
  static const socialInstagramPurple = Color(0xFF833AB4);
  static const socialInstagramPink = Color(0xFFFD1D1D);
  static const socialInstagramOrange = Color(0xFFF77737);

  // QR & Theme Accents
  static const qrDarkNavy = Color(0xFF0B1B3D);
}
