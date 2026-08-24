import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../dto/request/login_request.dart';
import '../dto/request/register_request.dart';
import '../dto/request/otp_request.dart';
import '../dto/request/email_verify_request.dart';
import '../dto/request/forgot_password_request.dart';
import '../dto/request/reset_password_request.dart';
import '../dto/response/auth_response.dart';
import '../services/auth_service.dart';
import '../../../../core/network/api_exceptions.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

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
  Future<ApiResult<AuthResponse>> login(LoginRequest request) async {
    try {
      final response = await authService.login(request);

      if (response.data is Map<String, dynamic>) {
        return ApiSuccess(AuthResponse.fromJson(response.data));
      } else if (response.data is String) {
        try {
          var decoded = jsonDecode(response.data);
          if (decoded is String) {
            decoded = jsonDecode(decoded);
          }
          if (decoded is Map<String, dynamic>) {
            return ApiSuccess(AuthResponse.fromJson(decoded));
          }
        } catch (_) {}
      }
      return ApiSuccess(AuthResponse(message: response.data.toString()));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<String>> register(RegisterRequest request) async {
    try {
      final response = await authService.register(request);
      return ApiSuccess(_parseSuccessMessage(response.data));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<AuthResponse>> verifyEmail(EmailVerifyRequest request) async {
    try {
      final response = await authService.verifyEmail(request);

      if (response.data is Map<String, dynamic>) {
        return ApiSuccess(AuthResponse.fromJson(response.data));
      } else if (response.data is String) {
        try {
          final decoded = jsonDecode(response.data);
          if (decoded is Map<String, dynamic>) {
            return ApiSuccess(AuthResponse.fromJson(decoded));
          }
        } catch (_) {}
      }

      return ApiError(ApiException(message: 'Invalid email verification response from server.'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<AuthResponse>> verifyOtp(OtpRequest request) async {
    try {
      final response = await authService.verifyOtp(request);
      
      if (response.data is Map<String, dynamic>) {
        return ApiSuccess(AuthResponse.fromJson(response.data));
      } else if (response.data is String) {
        try {
          final decoded = jsonDecode(response.data);
          if (decoded is Map<String, dynamic>) {
            return ApiSuccess(AuthResponse.fromJson(decoded));
          }
        } catch (_) {}
      }
      
      return ApiError(ApiException(message: 'Invalid OTP verification response from server.'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<String>> resendVerification(String email) async {
    try {
      final response = await authService.resendVerification(email);
      return ApiSuccess(_parseSuccessMessage(response.data));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<String>> resendLoginOtp(String username) async {
    try {
      final response = await authService.resendLoginOtp(username);
      return ApiSuccess(_parseSuccessMessage(response.data));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<String>> forgotPassword(ForgotPasswordRequest request) async {
    try {
      final response = await authService.forgotPassword(request);
      return ApiSuccess(_parseSuccessMessage(response.data));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<AuthResponse>> resetPassword(ResetPasswordRequest request) async {
    try {
      final response = await authService.resetPassword(request);

      if (response.data is Map<String, dynamic>) {
        return ApiSuccess(AuthResponse.fromJson(response.data));
      } else if (response.data is String) {
        try {
          final decoded = jsonDecode(response.data);
          if (decoded is Map<String, dynamic>) {
            return ApiSuccess(AuthResponse.fromJson(decoded));
          }
        } catch (_) {}
      }

      return ApiError(ApiException(message: 'Invalid reset password response from server.'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
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
