import 'package:dio/dio.dart';
import '../dto/request/login_request.dart';
import '../../../../core/network/dio_client.dart';

class AuthService {
  final Dio dio = DioClient().dio;

  Future<Response> login(LoginRequest request) async {
    return await dio.post('/login', data: request.toJson());
  }

  Future<void> logout() async {
    await dio.post('/logout');
  }
}
