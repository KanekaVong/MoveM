import 'package:dio/dio.dart';
import '../dto/request/login_request.dart';
import '../dto/request/register_request.dart';
import '../dto/request/otp_request.dart';
import '../dto/request/forgot_password_request.dart';
import '../dto/request/reset_password_request.dart';
import '../dto/request/email_verify_request.dart';
import '../../../../core/network/dio_client.dart';

class AuthService {
  final Dio dio = DioClient().dio;

  Future<Response> login(LoginRequest request) async {
    return await dio.post(
      'auth/login',
      data: request.toJson(),
      options: Options(responseType: ResponseType.plain),
    );
  }

  Future<Response> register(RegisterRequest request) async {
    return await dio.post(
      'auth/register',
      data: request.toJson(),
      options: Options(responseType: ResponseType.plain),
    );
  }

  Future<Response> verifyOtp(OtpRequest request) async {
    return await dio.post(
      'auth/verify-otp',
      data: request.toJson(),
      options: Options(responseType: ResponseType.plain),
    );
  }

  Future<Response> verifyEmail(EmailVerifyRequest request) async {
    return await dio.post(
      'auth/verify-email',
      data: request.toJson(),
      options: Options(responseType: ResponseType.plain),
    );
  }

  Future<Response> forgotPassword(ForgotPasswordRequest request) async {
    return await dio.post(
      'auth/forgot-password',
      data: request.toJson(),
      options: Options(responseType: ResponseType.plain),
    );
  }

  Future<Response> resetPassword(ResetPasswordRequest request) async {
    return await dio.post(
      'auth/reset-password',
      data: request.toJson(),
      options: Options(responseType: ResponseType.plain),
    );
  }

  Future<Response> resendVerification(String email) async {
    return await dio.post(
      'auth/resend-verification',
      data: {'email': email},
      options: Options(responseType: ResponseType.plain),
    );
  }

  Future<Response> resendLoginOtp(String username) async {
    return await dio.post(
      'auth/resend-login-otp',
      data: {'username': username},
      options: Options(responseType: ResponseType.plain),
    );
  }

  Future<void> logout() async {
    await dio.post('auth/logout', options: Options(responseType: ResponseType.plain));
  }
}
