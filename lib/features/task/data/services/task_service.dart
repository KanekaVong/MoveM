import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../../../core/network/dio_client.dart';

class TaskService {
  final Dio dio = DioClient().dio;

  Future<Response> createTask(Map<String, dynamic> data) async {
    return await dio.post('tasks', data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getLabels() async {
    return await dio.get('task-labels', options: Options(responseType: ResponseType.json));
  }

  Future<Response> createLabel(Map<String, dynamic> data) async {
    return await dio.post('task-labels', data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getTasks({Map<String, dynamic>? queryParameters}) async {
    return await dio.get('tasks', queryParameters: queryParameters, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getTaskDetail(String activityId) async {
    return await dio.get('tasks/$activityId', options: Options(responseType: ResponseType.json));
  }

  Future<Response> updateTask(String activityId, Map<String, dynamic> data) async {
    return await dio.put('tasks/$activityId', data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> deleteTask(String activityId) async {
    return await dio.delete('tasks/$activityId', options: Options(responseType: ResponseType.json));
  }

  Future<Response> toggleChecklistItem(int checklistId) async {
    return await dio.patch('tasks/checklists/$checklistId/complete', options: Options(responseType: ResponseType.json));
  }

  Future<Response> markTaskComplete(String activityId) async {
    return await dio.patch('tasks/$activityId/complete', options: Options(responseType: ResponseType.json));
  }

  Future<Response> addChecklistItem(String activityId, Map<String, dynamic> data) async {
    return await dio.post('tasks/$activityId/checklists', data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> deleteChecklistItem(int checklistId) async {
    return await dio.delete('tasks/checklists/$checklistId', options: Options(responseType: ResponseType.json));
  }

  Future<Response> addReminder(String activityId, Map<String, dynamic> data) async {
    return await dio.post('tasks/$activityId/reminders', data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> deleteReminder(int reminderId) async {
    return await dio.delete('tasks/reminders/$reminderId', options: Options(responseType: ResponseType.json));
  }

  MediaType? _getMediaType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    if (ext == 'jpg' || ext == 'jpeg') {
      return MediaType('image', 'jpeg');
    } else if (ext == 'png') {
      return MediaType('image', 'png');
    } else if (ext == 'webp') {
      return MediaType('image', 'webp');
    } else if (ext == 'gif') {
      return MediaType('image', 'gif');
    } else if (ext == 'pdf') {
      return MediaType('application', 'pdf');
    }
    return null;
  }

  Future<Response> uploadAttachment(String filePath) async {
    final fileName = filePath.split('/').last;
    final mediaType = _getMediaType(fileName);
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: fileName,
        contentType: mediaType,
      ),
    });
    return await dio.post(
      'attachments/upload',
      data: formData,
      options: Options(
        responseType: ResponseType.json,
      ),
    );
  }

  Future<Response> uploadTaskAttachment(String activityId, String filePath) async {
    final fileName = filePath.split('/').last;
    final mediaType = _getMediaType(fileName);
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: fileName,
        contentType: mediaType,
      ),
    });
    return await dio.post(
      'tasks/$activityId/attachments',
      data: formData,
      options: Options(
        responseType: ResponseType.json,
      ),
    );
  }
}
