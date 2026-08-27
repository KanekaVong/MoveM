import '../../../../core/network/api_result.dart';
import '../../data/dto/response/notification_response.dart';

abstract class NotificationRepository {
  Future<ApiResult<List<NotificationResponse>>> getNotifications();
  Future<ApiResult<void>> markAsRead(int notificationId);
}
