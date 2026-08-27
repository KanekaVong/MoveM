import 'package:get/get.dart';
import '../../../../shared/base/base_controller.dart';
import '../../domain/repositories/task_repository.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../data/services/task_service.dart';
import '../../data/dto/response/task_response.dart';

class TaskController extends BaseController {
  final TaskRepository repository = TaskRepositoryImpl(TaskService());

  final RxList<TaskResponse> tasks = <TaskResponse>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    await executeApi(
      apiCall: () => repository.getTasks(),
      onSuccess: (data) {
        tasks.value = data;
      },
      showLoading: false,
    );
  }

  int get completedTasksCount {
    return tasks.where((t) => t.status == 'COMPLETE').length;
  }

  int get upcomingTasksCount {
    return tasks.where((t) => t.status != 'COMPLETE' && t.status != 'CANCELLED' && t.deadline != null).length;
  }

  int get ongoingTasksCount {
    return tasks.where((t) => t.status == 'IN_PROGRESS' || t.status == 'PENDING').length;
  }
}
