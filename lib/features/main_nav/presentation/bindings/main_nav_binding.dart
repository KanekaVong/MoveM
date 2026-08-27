import 'package:get/get.dart';
import '../controllers/main_nav_controller.dart';
import '../../../../features/home/presentation/controllers/home_controller.dart';

import '../../../../features/settings/presentation/controllers/settings_controller.dart';
import '../../../../features/settings/presentation/controllers/profile_controller.dart';

class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavController>(() => MainNavController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SettingsController>(() => SettingsController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
