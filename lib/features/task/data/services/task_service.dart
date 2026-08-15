import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class TaskService {
  final Dio dio = DioClient().dio;

  Future<Response> createTask(Map<String, dynamic> data) async {
    return await dio.post('tasks', data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getLabels() async {
    return await dio.get('task-labels', options: Options(responseType: ResponseType.json));
  }
}
