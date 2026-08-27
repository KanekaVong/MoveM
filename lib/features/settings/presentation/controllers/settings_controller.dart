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

  @override
  void onInit() {
    super.onInit();
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
