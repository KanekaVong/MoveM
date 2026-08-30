import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class InviteService {
  final Dio dio = DioClient().dio;

  Future<Response> getInvite(String token) async {
    return await dio.get(
      'invites/$token',
      options: Options(responseType: ResponseType.json),
    );
  }

  Future<Response> createInvite() async {
    return await dio.post(
      'invites',
      options: Options(responseType: ResponseType.json),
    );
  }
}
