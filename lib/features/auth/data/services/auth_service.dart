import 'package:dio/dio.dart';
import '../../../../core/network/api_exceptions.dart';
import '../dto/request/login_request.dart';
import '../dto/response/user_response.dart';
import '../../../../core/network/dio_client.dart';

class AuthService {
  final Dio dio = DioClient().dio;

  Future<UserResponse?> login(LoginRequest request) async {
    try {
      final response = await dio.post('/login', data: request.toJson());
      return UserResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
