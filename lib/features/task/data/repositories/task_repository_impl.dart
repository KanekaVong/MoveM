import 'package:dio/dio.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../domain/repositories/task_repository.dart';
import '../dto/request/create_task_request.dart';
import '../dto/response/task_response.dart';
import '../dto/response/label_response.dart';
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

  @override
  Future<ApiResult<List<LabelResponse>>> getLabels() async {
    try {
      final response = await _service.getLabels();
      final List<dynamic> data = response.data;
      final labels = data.map((e) => LabelResponse.fromJson(e)).toList();
      return ApiSuccess(labels);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<LabelResponse>> createLabel(String name, String color) async {
    try {
      final response = await _service.createLabel({
        'name': name,
        'color': color,
      });
      final label = LabelResponse.fromJson(response.data);
      return ApiSuccess(label);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<List<TaskResponse>>> getTasks({Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _service.getTasks(queryParameters: queryParameters);
      final List<dynamic> data = response.data;
      final tasks = data.map((json) => TaskResponse.fromJson(json)).toList();
      return ApiSuccess(tasks);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<TaskResponse>> getTaskDetail(String activityId) async {
    try {
      final response = await _service.getTaskDetail(activityId);
      final task = TaskResponse.fromJson(response.data);
      return ApiSuccess(task);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<TaskResponse>> updateTask(String activityId, Map<String, dynamic> data) async {
    try {
      final response = await _service.updateTask(activityId, data);
      final task = TaskResponse.fromJson(response.data);
      return ApiSuccess(task);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> toggleChecklistItem(int checklistId) async {
    try {
      await _service.toggleChecklistItem(checklistId);
      return ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<TaskResponse>> markTaskComplete(String activityId) async {
    try {
      final response = await _service.markTaskComplete(activityId);
      return ApiSuccess(TaskResponse.fromJson(response.data));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> addChecklistItem(String activityId, Map<String, dynamic> data) async {
    try {
      await _service.addChecklistItem(activityId, data);
      return ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> deleteChecklistItem(int checklistId) async {
    try {
      await _service.deleteChecklistItem(checklistId);
      return ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> addReminder(String activityId, Map<String, dynamic> data) async {
    try {
      await _service.addReminder(activityId, data);
      return ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> deleteReminder(int reminderId) async {
    try {
      await _service.deleteReminder(reminderId);
      return ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }
}
