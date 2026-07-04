import 'package:dio/dio.dart';
import '../../domain/repositories/auth_repository.dart';
import '../dto/request/login_request.dart';
import '../dto/response/user_response.dart';
import '../services/auth_service.dart';
import '../../../../core/network/api_exceptions.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

  AuthRepositoryImpl({required this.authService});

  @override
  Future<UserResponse?> login(LoginRequest request) async {
    try {
      final response = await authService.login(request);
      return UserResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await authService.logout();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
