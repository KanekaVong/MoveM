import '../../../../core/network/api_result.dart';
import '../../data/dto/request/login_request.dart';
import '../../data/dto/request/register_request.dart';
import '../../data/dto/request/otp_request.dart';
import '../../data/dto/request/forgot_password_request.dart';
import '../../data/dto/request/reset_password_request.dart';
import '../../data/dto/response/user_response.dart';

abstract class AuthRepository {
  Future<ApiResult<String>> login(LoginRequest request);
  Future<ApiResult<String>> register(RegisterRequest request);
  Future<ApiResult<UserResponse?>> verifyOtp(OtpRequest request);
  Future<ApiResult<String>> forgotPassword(ForgotPasswordRequest request);
  Future<ApiResult<String>> resetPassword(ResetPasswordRequest request);
  Future<ApiResult<void>> logout();
}
