import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  factory ApiException.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        return ApiException(message: "Request to API server was cancelled");
      case DioExceptionType.connectionTimeout:
        return ApiException(message: "Connection timeout with API server");
      case DioExceptionType.receiveTimeout:
        return ApiException(message: "Receive timeout in connection with API server");
      case DioExceptionType.sendTimeout:
        return ApiException(message: "Send timeout in connection with API server");
      case DioExceptionType.connectionError:
        return ApiException(message: "No Internet Connection");
      case DioExceptionType.badResponse:
        return ApiException._handleError(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
      default:
        return ApiException(message: "Something went wrong");
    }
  }

  factory ApiException._handleError(int? statusCode, dynamic data) {
    String defaultMessage = "Unexpected error occurred";
    if (data != null && data is Map<String, dynamic> && data.containsKey('message')) {
      defaultMessage = data['message'];
    }

    switch (statusCode) {
      case 400:
        return ApiException(message: defaultMessage, statusCode: 400);
      case 401:
        return ApiException(message: "Unauthorized: Please login again.", statusCode: 401);
      case 403:
        return ApiException(message: "Forbidden: You don't have access.", statusCode: 403);
      case 404:
        return ApiException(message: "Resource not found", statusCode: 404);
      case 500:
        return ApiException(message: "Internal server error", statusCode: 500);
      default:
        return ApiException(message: defaultMessage, statusCode: statusCode);
    }
  }

  @override
  String toString() => message;
}
