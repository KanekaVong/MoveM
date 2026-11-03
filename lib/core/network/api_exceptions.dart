import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:movem/core/utils/l10n.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? email;

  ApiException({required this.message, this.statusCode, this.email});

  factory ApiException.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        return ApiException(message: tr.apiRequestCancelled);
      case DioExceptionType.connectionTimeout:
        return ApiException(message: tr.apiTimeout);
      case DioExceptionType.receiveTimeout:
        return ApiException(message: tr.apiTimeout);
      case DioExceptionType.sendTimeout:
        return ApiException(message: tr.apiTimeout);
      case DioExceptionType.connectionError:
        return ApiException(message: tr.apiNoInternet);
      case DioExceptionType.badResponse:
        return ApiException._handleError(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
      case DioExceptionType.unknown:
        if (dioError.response != null && dioError.response?.data != null) {
          return ApiException._handleError(
            dioError.response?.statusCode,
            dioError.response?.data,
          );
        }
        if (dioError.error is FormatException) {
          return ApiException(message: tr.serverBadResponse);
        }
        return ApiException(message: tr.unexpectedError);
      default:
        return ApiException(message: tr.unexpectedError);
    }
  }

  factory ApiException._handleError(int? statusCode, dynamic data) {
    String? defaultMessage;
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
          } else if (decoded is String && decoded.trim().isNotEmpty) {
            defaultMessage = decoded.trim();
          } else {
            defaultMessage = _cleanBackendError(data);
          }
        } catch (_) {
          defaultMessage = _cleanBackendError(data);
        }
      }
    }

    final serverMessage = defaultMessage;
    final message = serverMessage ?? tr.unexpectedError;

    switch (statusCode) {
      case 400:
        return ApiException(message: message, statusCode: 400, email: email);
      case 401:
        return ApiException(message: serverMessage ?? tr.apiUnauthorized, statusCode: 401);
      case 403:
        return ApiException(message: serverMessage ?? tr.apiForbidden, statusCode: 403, email: email);
      case 404:
        return ApiException(message: serverMessage ?? tr.apiNotFound, statusCode: 404);
      case 500:
        return ApiException(message: serverMessage ?? tr.apiServerError, statusCode: 500);
      default:
        return ApiException(message: message, statusCode: statusCode, email: email);
    }
  }

  static String _cleanBackendError(String rawMessage) {
    if (rawMessage.contains("Duplicate entry")) {
      final regex = RegExp(r"Duplicate entry '([^']+)' for key '([^']+)'");
      final match = regex.firstMatch(rawMessage);
      if (match != null) {
        final value = match.group(1);
        final key = match.group(2)?.split('.').last;
        return tr.apiAlreadyTaken(key ?? '', value ?? '');
      }
    }
    return rawMessage;
  }

  @override
  String toString() => message;
}
