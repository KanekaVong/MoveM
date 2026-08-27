import 'package:get/get.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../data/dto/response/notification_response.dart';

class NotificationController extends GetxController {
  final NotificationRepository repository;

  NotificationController({required this.repository});

  final RxList<NotificationResponse> notifications = <NotificationResponse>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    error.value = '';

    final result = await repository.getNotifications();
    if (result is ApiSuccess<List<NotificationResponse>>) {
      notifications.assignAll(result.data);
      isLoading.value = false;
    } else if (result is ApiError<List<NotificationResponse>>) {
      error.value = result.exception.message;
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(int id) async {

    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !notifications[index].isRead) {
      notifications[index] = notifications[index].copyWith(isRead: true);

      await repository.markAsRead(id);
    }
  }
}
