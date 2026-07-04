import '../../data/dto/request/login_request.dart';
import '../../data/dto/response/user_response.dart';

abstract class AuthRepository {
  Future<UserResponse?> login(LoginRequest request);
  Future<void> logout();
}
