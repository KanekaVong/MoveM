import '../../domain/repositories/auth_repository.dart';
import '../dto/request/login_request.dart';
import '../dto/response/user_response.dart';
import '../services/auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

  AuthRepositoryImpl({required this.authService});

  @override
  Future<UserResponse?> login(LoginRequest request) async {
    return await authService.login(request);
  }

  @override
  Future<void> logout() async {

  }

}
