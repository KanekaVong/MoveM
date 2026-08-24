import 'dart:convert';
import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? email;

  ApiException({required this.message, this.statusCode, this.email});

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
    String? email;
    if (data != null) {
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        defaultMessage = data['message'];
        email = data['email']?.toString();
      } else if (data is String && data.isNotEmpty) {
        try {
          final decoded = jsonDecode(data);
          if (decoded is Map<String, dynamic> && decoded.containsKey('message')) {
            defaultMessage = decoded['message'].toString();
            email = decoded['email']?.toString();
          } else {
            defaultMessage = _cleanBackendError(data);
          }
        } catch (_) {
          defaultMessage = _cleanBackendError(data);
        }
      }
    }

    bool hasCustomMessage = defaultMessage != "Unexpected error occurred";

    switch (statusCode) {
      case 400:
        return ApiException(message: defaultMessage, statusCode: 400, email: email);
      case 401:
        return ApiException(message: hasCustomMessage ? defaultMessage : "Unauthorized: Please login again.", statusCode: 401);
      case 403:
        return ApiException(message: hasCustomMessage ? defaultMessage : "Forbidden: You don't have access.", statusCode: 403, email: email);
      case 404:
        return ApiException(message: hasCustomMessage ? defaultMessage : "Resource not found", statusCode: 404);
      case 500:
        return ApiException(message: hasCustomMessage ? defaultMessage : "Internal server error", statusCode: 500);
      default:
        return ApiException(message: defaultMessage, statusCode: statusCode, email: email);
    }
  }

  static String _cleanBackendError(String rawMessage) {
    if (rawMessage.contains("Duplicate entry")) {
      final regex = RegExp(r"Duplicate entry '([^']+)' for key '([^']+)'");
      final match = regex.firstMatch(rawMessage);
      if (match != null) {
        final value = match.group(1);
        final key = match.group(2)?.split('.').last; // user.username -> username
        return "The $key '$value' is already taken. Please try another one.";
      }
    }
    return rawMessage;
  }

  @override
  String toString() => message;
}
