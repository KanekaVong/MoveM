import 'package:get/get.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../friends/presentation/bindings/friends_binding.dart';
import '../../../friends/presentation/screens/add_friends_screen.dart';
import '../../../main_nav/presentation/controllers/main_nav_controller.dart';
import '../../../settings/presentation/screens/ProfileScreen.dart';
import '../../../task/presentation/screens/task_comment_screen.dart';
import '../../../task/presentation/screens/task_detail_screen.dart';
import '../../data/dto/response/notification_response.dart';
import '../../domain/repositories/notification_repository.dart';

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

  Future<void> onNotificationTap(NotificationResponse notification) async {
    // 1. Mark as read immediately
    markAsRead(notification.id);

    // 2. Navigate to destination screen based on type
    navigateToNotificationTarget(notification);
  }

  void navigateToNotificationTarget(NotificationResponse notification) {
    final notifType = notification.notificationType?.toUpperCase() ?? '';
    final refType = notification.referenceType?.toUpperCase() ?? '';
    final refId = notification.referenceId?.trim() ?? '';

    // 1. Task Comments
    if (notifType == 'COMMENT_CREATED' || refType == 'COMMENT') {
      if (refId.isNotEmpty) {
        Get.to(() => TaskCommentScreen(
              activityId: refId,
              taskTitle: notification.title ?? 'Task Details',
            ));
      } else {
        _switchToTab(1); // Task tab
      }
      return;
    }

    // 2. Tasks (TASK_ASSIGNED, TASK_COMPLETED, TASK_DEADLINE, TASK_REMINDER, or refType == TASK)
    if (notifType.startsWith('TASK_') || refType == 'TASK') {
      if (refId.isNotEmpty) {
        Get.to(() => TaskDetailScreen(activityId: refId));
      } else {
        _switchToTab(1); // Task tab
      }
      return;
    }

    // 3. Friend Requests / Social
    if (notifType == 'FRIEND_REQUEST' ||
        notifType == 'FRIEND_ACCEPTED' ||
        refType == 'USER') {
      Get.to(() => const AddFriendsScreen(), binding: FriendsBinding());
      return;
    }

    // 4. Fitness / Workouts
    if (notifType.startsWith('FITNESS_') ||
        notifType.startsWith('WORKOUT_') ||
        refType == 'FITNESS') {
      _switchToTab(2); // Fitness tab
      return;
    }

    // 5. Trips
    if (notifType.startsWith('TRIP_') || refType == 'TRIP') {
      _switchToTab(3); // Trip tab
      return;
    }

    // 6. Group Activities / MoveM Club
    if (notifType.startsWith('GROUP_') ||
        notifType == 'MEMBER_INVITED' ||
        refType == 'GROUP') {
      _switchToTab(2); // Fitness/Club tab
      return;
    }

    // 7. Achievement / Profile
    if (notifType == 'ACHIEVEMENT_UNLOCKED' || refType == 'ACHIEVEMENT') {
      Get.to(() => const ProfileScreen());
      return;
    }
  }

  void _switchToTab(int tabIndex) {
    if (Get.isRegistered<MainNavController>()) {
      Get.find<MainNavController>().changeTab(tabIndex);
      Get.back();
    } else {
      Get.toNamed(AppRoutes.main, arguments: {'tab': tabIndex});
    }
  }
}
