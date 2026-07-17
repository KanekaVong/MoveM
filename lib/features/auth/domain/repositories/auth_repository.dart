import '../../../../core/network/api_result.dart';
import '../../data/dto/request/login_request.dart';
import '../../data/dto/response/user_response.dart';

abstract class AuthRepository {
  Future<ApiResult<UserResponse?>> login(LoginRequest request);
  Future<ApiResult<void>> logout();
}
