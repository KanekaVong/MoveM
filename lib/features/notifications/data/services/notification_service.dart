import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class NotificationService {
  final Dio dio = DioClient().dio;

  Future<Response> getNotifications() async {
    return await dio.get('notifications');
  }

  Future<Response> markAsRead(int notificationId) async {
    return await dio.patch('notifications/$notificationId/read');
  }
}
