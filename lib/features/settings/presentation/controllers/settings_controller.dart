import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/storage/user_manager.dart';
import '../../../../core/utils/Constants.dart';
import '../../../../shared/base/base_controller.dart';
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
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
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
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Language / ជ្រើសរើសភាសា',
                style: TextStyle(
                  color: Colors.white,
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'Cancel / បោះបង់',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
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
          currentLanguage.value = code;
          await UserManager().setLanguage(code);
          await Get.updateLocale(Locale(code));
          Get.back();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF3B82F6).withOpacity(0.2) : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF3B82F6) : Colors.white.withOpacity(0.1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: Color(0xFF3B82F6), size: 20),
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
