import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';

class AppDialogs {
  static void showLoading() {
    Get.dialog(
      const PopScope(
        canPop: false,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.darkOnPrimary,
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  static void showError(String message, {VoidCallback? onConfirm}) {
    showSingleActionDialog(
      title: 'Error',
      message: message,
      onConfirm: onConfirm,
    );
  }

  static void showSingleActionDialog({
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onConfirm,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title, textAlign: TextAlign.center),
        content: Text(message, textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              if (onConfirm != null) {
                onConfirm();
              }
            },
            child: Text(buttonText),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  static void showMultiActionDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title, textAlign: TextAlign.start),
        content: Text(message, textAlign: TextAlign.start),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              if (onCancel != null) {
                onCancel();
              }
            },
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: Text(confirmText),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
