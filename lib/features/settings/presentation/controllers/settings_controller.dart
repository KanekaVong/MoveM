import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/storage/user_manager.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/Constants.dart';
import '../../../../shared/base/base_controller.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../auth/data/dto/response/user_response.dart';
import '../../../auth/data/services/auth_service.dart';

class SettingsController extends BaseController {
  final AuthService _authService = AuthService();

  final RxBool isDarkMode = false.obs;
  final Rx<UserResponse?> user = Rx<UserResponse?>(null);

  final RxString currentLanguage = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    currentLanguage.value = UserManager().languageCode;
    loadSettings();
  }

  void loadSettings() {
    final savedTheme = UserManager().themeMode;
    if (savedTheme == Constants.darkMode) {
      isDarkMode.value = true;
    } else if (savedTheme == Constants.lightMode) {
      isDarkMode.value = false;
    } else {
      isDarkMode.value = Get.isDarkMode;
    }

    currentLanguage.value = UserManager().languageCode;
    user.value = UserManager().getUser();
  }

  void onToggleTheme(bool isDark) {
    isDarkMode.value = isDark;
    final modeStr = isDark ? Constants.darkMode : Constants.lightMode;
    UserManager().setThemeMode(modeStr);
    Get.changeTheme(isDark ? AppTheme.darkTheme : AppTheme.lightTheme);
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    Get.forceAppUpdate();
  }

  void onProfileTap() {
    Get.toNamed(AppRoutes.profile)?.then((_) {
      loadSettings();
    });
  }

  void onChangePasswordTap() {

  }

  void onLanguagesTap() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Language / ជ្រើសរើសភាសា',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildLanguageOption(
                title: 'English (English)',
                code: 'en',
              ),
              const SizedBox(height: 12),
              _buildLanguageOption(
                title: 'ភាសាខ្មែរ (Khmer)',
                code: 'km',
              ),
              const SizedBox(height: 20),
              AppButton.secondary(
                label: 'Cancel / បោះបង់',
                height: 46,
                onPressed: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.6),
    );
  }

  Widget _buildLanguageOption({required String title, required String code}) {
    return Obx(() {
      final isSelected = currentLanguage.value == code;
      return InkWell(
        onTap: () async {
          if (currentLanguage.value != code) {
            currentLanguage.value = code;
            Get.back();
            await UserManager().setLanguage(code);
            await Get.updateLocale(Locale(code));
          } else {
            Get.back();
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.blueAccent.withValues(alpha: 0.2) : AppColors.chipSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.blueAccent : AppColors.borderLight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: AppColors.blueAccent, size: 20),
            ],
          ),
        ),
      );
    });
  }

  void onNotificationsTap() {
    Get.toNamed(AppRoutes.notifications);
  }

  void onPrivacyTap() {

  }

  void onDeleteAccountTap() {

  }

  Future<void> confirmLogout() async {
    try {
      await _authService.logout();
    } catch (_) {}

    await UserManager().clearSession();
    user.value = null;
    Get.offAllNamed(AppRoutes.login);
  }
}
