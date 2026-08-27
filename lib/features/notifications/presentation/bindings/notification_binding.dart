import 'package:get/get.dart';
import '../../data/services/notification_service.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../controllers/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationService());
    Get.lazyPut(() => NotificationRepositoryImpl(service: Get.find<NotificationService>()));
    Get.lazyPut(() => NotificationController(repository: Get.find<NotificationRepositoryImpl>()));
  }
}
