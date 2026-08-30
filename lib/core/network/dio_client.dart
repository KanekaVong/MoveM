import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../storage/local_storage.dart';
import '../config/app_config.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio _dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(milliseconds: AppConfig.connectTimeout),
      receiveTimeout: const Duration(milliseconds: AppConfig.receiveTimeout),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    _dio = Dio(options);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await LocalStorage().getSecureString('access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (options.data is FormData) {
            options.headers.remove('Content-Type');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          log('*** DioException [${e.response?.statusCode}] ***\nURI: ${e.requestOptions.uri}\nResponse Body: ${e.response?.data}\nError: ${e.error}\nMessage: ${e.message}', name: 'DIO-ERR');
          return handler.next(e);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        logPrint: (object) => log(object.toString(), name: 'DIO-REQ'),
      ));

      _dio.interceptors.add(InterceptorsWrapper(
        onResponse: (response, handler) {
          try {
            final prettyString = const JsonEncoder.withIndent('  ').convert(response.data);
            log('URI: ${response.requestOptions.uri}\n$prettyString', name: 'DIO-RES');
          } catch (e) {
            log('URI: ${response.requestOptions.uri}\n${response.data}', name: 'DIO-RES');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          try {
            final prettyString = const JsonEncoder.withIndent('  ').convert(e.response?.data);
            log('URI: ${e.requestOptions.uri}\nStatus: ${e.response?.statusCode}\n$prettyString', name: 'DIO-ERR');
          } catch (_) {
            log('URI: ${e.requestOptions.uri}\nStatus: ${e.response?.statusCode}\nData: ${e.response?.data}', name: 'DIO-ERR');
          }
          return handler.next(e);
        },
      ));
    }
  }

  Dio get dio => _dio;
}
