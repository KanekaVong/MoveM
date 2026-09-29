import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';

class AppSnack {
  static void show(
    String title,
    String message, {
    SnackPosition? snackPosition,
    Duration? duration,
    Widget? icon,
    EdgeInsets? margin,
    double? borderRadius,
    Color? backgroundColor,
    Color? colorText,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: snackPosition ?? SnackPosition.TOP,
      duration: duration ?? const Duration(seconds: 3),
      backgroundColor: AppColors.cardSurface,
      colorText: AppColors.textPrimary,
      barBlur: 0,
      borderRadius: 16,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderColor: AppColors.borderMuted,
      borderWidth: 1,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.16),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
      icon: icon,
      shouldIconPulse: false,
    );
  }
}
