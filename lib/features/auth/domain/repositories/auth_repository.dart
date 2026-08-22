import '../../../../core/network/api_result.dart';
import '../../data/dto/request/login_request.dart';
import '../../data/dto/request/register_request.dart';
import '../../data/dto/request/otp_request.dart';
import '../../data/dto/request/email_verify_request.dart';
import '../../data/dto/request/forgot_password_request.dart';
import '../../data/dto/request/reset_password_request.dart';
import '../../data/dto/response/auth_response.dart';

abstract class AuthRepository {
  Future<ApiResult<String>> register(RegisterRequest request);
  Future<ApiResult<AuthResponse>> verifyEmail(EmailVerifyRequest request);
  Future<ApiResult<AuthResponse>> login(LoginRequest request);
  Future<ApiResult<AuthResponse>> verifyOtp(OtpRequest request);
  Future<ApiResult<String>> resendVerification(String email);
  Future<ApiResult<String>> resendLoginOtp(String username);
  Future<ApiResult<String>> forgotPassword(ForgotPasswordRequest request);
  Future<ApiResult<AuthResponse>> resetPassword(ResetPasswordRequest request);
  Future<ApiResult<void>> logout();
}
