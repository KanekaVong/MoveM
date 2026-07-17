import 'package:get/get.dart';
import 'app_routes.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/bindings/auth_binding.dart';
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
      name: AppRoutes.main,
      page: () => const BottomNavScreen(),
      binding: MainNavBinding(),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const BottomNavScreen(),
      binding: MainNavBinding(),
    ),
  ];
}
