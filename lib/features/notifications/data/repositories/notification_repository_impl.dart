import 'package:dio/dio.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../domain/repositories/notification_repository.dart';
import '../dto/response/notification_response.dart';
import '../services/notification_service.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationService service;

  NotificationRepositoryImpl({required this.service});

  @override
  Future<ApiResult<List<NotificationResponse>>> getNotifications() async {
    try {
      final response = await service.getNotifications();

      if (response.data is List) {
        final List<dynamic> dataList = response.data;
        final notifications = dataList
            .whereType<Map<String, dynamic>>()
            .map((json) => NotificationResponse.fromJson(json))
            .toList();
        return ApiSuccess(notifications);
      }
      return ApiError(ApiException(message: 'Invalid response format from server.'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> markAsRead(int notificationId) async {
    try {
      await service.markAsRead(notificationId);
      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }
}
