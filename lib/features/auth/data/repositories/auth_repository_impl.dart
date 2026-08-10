import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../dto/request/login_request.dart';
import '../dto/request/register_request.dart';
import '../dto/request/otp_request.dart';
import '../dto/request/forgot_password_request.dart';
import '../dto/request/reset_password_request.dart';
import '../dto/response/user_response.dart';
import '../services/auth_service.dart';
import '../../../../core/network/api_exceptions.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;
  final _logger = Logger();

  AuthRepositoryImpl({required this.authService});

  String _parseSuccessMessage(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('message')) {
      return data['message'].toString();
    }
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic> && decoded.containsKey('message')) {
          return decoded['message'].toString();
        }
      } catch (_) {}
    }
    return data.toString();
  }

  @override
  Future<ApiResult<String>> login(LoginRequest request) async {
    try {
      _logger.i('Calling POST auth/login with data: ${request.toJson()}');
      final response = await authService.login(request);
      _logger.i('Login Response [${response.statusCode}]: ${response.data}');
      return ApiSuccess(_parseSuccessMessage(response.data));
    } on DioException catch (e) {
      _logger.e('Login Error: ${e.response?.data ?? e.message}');
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      _logger.e('Login Error: $e');
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<String>> register(RegisterRequest request) async {
    try {
      _logger.i('Calling POST auth/register with data: ${request.toJson()}');
      final response = await authService.register(request);
      _logger.i('Register Response [${response.statusCode}]: ${response.data}');
      return ApiSuccess(_parseSuccessMessage(response.data));
    } on DioException catch (e) {
      _logger.e('Register Error: ${e.response?.data ?? e.message}');
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      _logger.e('Register Error: $e');
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<UserResponse?>> verifyOtp(OtpRequest request) async {
    try {
      _logger.i('Calling POST auth/verify-otp with data: ${request.toJson()}');
      final response = await authService.verifyOtp(request);
      _logger.i('Verify OTP Response [${response.statusCode}]: ${response.data}');
      
      // Attempt to parse JSON response. If it returns plain text, it will fail here.
      // If the backend returns a token, it usually comes in a JSON object.
      if (response.data is Map<String, dynamic>) {
        return ApiSuccess(UserResponse.fromJson(response.data));
      } else if (response.data is String) {
        try {
          final decoded = jsonDecode(response.data);
          if (decoded is Map<String, dynamic>) {
            return ApiSuccess(UserResponse.fromJson(decoded));
          }
        } catch (_) {}
      }
      
      // Fallback if it returns plain text just like the other endpoints for now
      return ApiSuccess(UserResponse(id: '0', email: request.username, name: request.username));
    } on DioException catch (e) {
      _logger.e('Verify OTP Error: ${e.response?.data ?? e.message}');
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      _logger.e('Verify OTP Error: $e');
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<String>> forgotPassword(ForgotPasswordRequest request) async {
    try {
      _logger.i('Calling POST auth/forgot-password with data: ${request.toJson()}');
      final response = await authService.forgotPassword(request);
      _logger.i('Forgot Password Response [${response.statusCode}]: ${response.data}');
      return ApiSuccess(_parseSuccessMessage(response.data));
    } on DioException catch (e) {
      _logger.e('Forgot Password Error: ${e.response?.data ?? e.message}');
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      _logger.e('Forgot Password Error: $e');
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<String>> resetPassword(ResetPasswordRequest request) async {
    try {
      _logger.i('Calling POST auth/reset-password with data: ${request.toJson()}');
      final response = await authService.resetPassword(request);
      _logger.i('Reset Password Response [${response.statusCode}]: ${response.data}');
      return ApiSuccess(_parseSuccessMessage(response.data));
    } on DioException catch (e) {
      _logger.e('Reset Password Error: ${e.response?.data ?? e.message}');
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      _logger.e('Reset Password Error: $e');
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> logout() async {
    try {
      await authService.logout();
      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }
}
