import 'package:dio/dio.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../dto/request/login_request.dart';
import '../dto/response/user_response.dart';
import '../services/auth_service.dart';
import '../../../../core/network/api_exceptions.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

  AuthRepositoryImpl({required this.authService});

  @override
  Future<ApiResult<UserResponse?>> login(LoginRequest request) async {
    try {
      final response = await authService.login(request);
      return ApiSuccess(UserResponse.fromJson(response.data));
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
