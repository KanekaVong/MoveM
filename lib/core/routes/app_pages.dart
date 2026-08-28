import 'package:get/get.dart';
import 'app_routes.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/verify_otp_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/bindings/auth_binding.dart';
import '../../features/settings/presentation/screens/edit_profile_screen.dart';
import '../../features/settings/presentation/screens/change_contact_screen.dart';
import '../../features/settings/presentation/models/contact_type.dart';
import '../../features/settings/presentation/screens/verify_contact_screen.dart';
import '../../features/settings/presentation/screens/ProfileScreen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

import '../../features/settings/presentation/bindings/setting_binding.dart';
import '../../features/main_nav/presentation/screens/bottom_nav_screen.dart';
import '../../features/main_nav/presentation/bindings/main_nav_binding.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.verifyOtp,
      page: () => VerifyOtpScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => ResetPasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: AppRoutes.changeContact,
      page: () => ChangeContactScreen(
        type: Get.arguments as ContactType,
      ),
      binding: SettingBinding(),
    ),
    GetPage(
      name: AppRoutes.verifyContact,
      page: () => VerifyContactScreen(
        type: Get.arguments['type'] as ContactType,
        value: Get.arguments['value'] as String,
        verificationId: Get.arguments['verificationId'],
      ),
      binding: SettingBinding(),
    ),
    GetPage(
      name: AppRoutes.profileScreen,
      page: () => const ProfileScreen(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: AppRoutes.settingsScreen,
      page: () => const SettingsScreen(),
      binding: SettingBinding(),
    ),

    GetPage(
      name: AppRoutes.main,
      page: () => const BottomNavScreen(),
      binding: MainNavBinding(),
    ),
  ];
}
