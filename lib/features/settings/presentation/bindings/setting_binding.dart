import 'package:get/get.dart';
import '../../data/services/setting_service.dart';
import '../../data/repositories/setting_repository_impl.dart';
import '../../domain/repositories/setting_repository.dart';
import '../controllers/setting_controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingService>(() => SettingService(), fenix: true);
    Get.lazyPut<SettingRepository>(() => SettingRepositoryImpl(settingService: Get.find()), fenix: true);
    Get.lazyPut<SettingController>(() => SettingController(repository: Get.find()), fenix: true);
  }
}