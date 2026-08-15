import 'package:dio/dio.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../domain/repositories/task_repository.dart';
import '../dto/request/create_task_request.dart';
import '../dto/response/task_response.dart';
import '../services/task_service.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskService _service;

  TaskRepositoryImpl(this._service);

  @override
  Future<ApiResult<TaskResponse>> createTask(CreateTaskRequest request) async {
    try {
      final response = await _service.createTask(request.toJson());
      final task = TaskResponse.fromJson(response.data);
      return ApiSuccess(task);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }
}
