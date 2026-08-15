import '../../../../core/network/api_result.dart';
import '../../data/dto/request/create_task_request.dart';
import '../../data/dto/response/task_response.dart';

import '../../data/dto/response/label_response.dart';

abstract class TaskRepository {
  Future<ApiResult<TaskResponse>> createTask(CreateTaskRequest request);
  Future<ApiResult<List<LabelResponse>>> getLabels();
}
