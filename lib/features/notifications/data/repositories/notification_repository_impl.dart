import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../domain/repositories/notification_repository.dart';
import '../dto/response/notification_response.dart';
import '../services/notification_service.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationService service;
  final _logger = Logger();

  NotificationRepositoryImpl({required this.service});

  @override
  Future<ApiResult<List<NotificationResponse>>> getNotifications() async {
    try {
      _logger.i('Calling GET api/notifications');
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
      _logger.e('Get Notifications Error: ${e.response?.data ?? e.message}');
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      _logger.e('Get Notifications Error: $e');
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> markAsRead(int notificationId) async {
    try {
      _logger.i('Calling PATCH api/notifications/$notificationId/read');
      await service.markAsRead(notificationId);
      return const ApiSuccess(null);
    } on DioException catch (e) {
      _logger.e('Mark As Read Error: ${e.response?.data ?? e.message}');
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      _logger.e('Mark As Read Error: $e');
      return ApiError(ApiException(message: e.toString()));
    }
  }
}
