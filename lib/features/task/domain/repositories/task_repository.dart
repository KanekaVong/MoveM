import '../../../../core/network/api_result.dart';
import '../../data/dto/request/create_task_request.dart';
import '../../data/dto/response/task_response.dart';
import '../../data/dto/response/label_response.dart';
import '../../data/dto/response/attachment_response.dart';

abstract class TaskRepository {
  Future<ApiResult<TaskResponse>> createTask(CreateTaskRequest request);
  Future<ApiResult<List<LabelResponse>>> getLabels();
  Future<ApiResult<LabelResponse>> createLabel(String name, String color);
  Future<ApiResult<List<TaskResponse>>> getTasks({Map<String, dynamic>? queryParameters});
  Future<ApiResult<TaskResponse>> getTaskDetail(String activityId);
  Future<ApiResult<TaskResponse>> updateTask(String activityId, Map<String, dynamic> data);
  Future<ApiResult<void>> toggleChecklistItem(int checklistId);
  Future<ApiResult<TaskResponse>> markTaskComplete(String activityId);
  Future<ApiResult<void>> addChecklistItem(String activityId, Map<String, dynamic> data);
  Future<ApiResult<void>> deleteChecklistItem(int checklistId);
  Future<ApiResult<void>> addReminder(String activityId, Map<String, dynamic> data);
  Future<ApiResult<void>> deleteReminder(int reminderId);
  Future<ApiResult<AttachmentResponse>> uploadAttachment(String filePath);
  Future<ApiResult<AttachmentResponse>> uploadTaskAttachment(String activityId, String filePath);
}
