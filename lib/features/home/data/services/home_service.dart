import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class HomeService {
  final Dio dio;

  HomeService({Dio? client}) : dio = client ?? DioClient().dio;

  Future<Response> getDashboard() async {
    return await dio.get('dashboard/me', options: Options(responseType: ResponseType.json));
  }
}
