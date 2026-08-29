import 'package:get/get.dart';
import '../../../../core/services/notification_scheduler_service.dart';
import '../../../../shared/base/base_controller.dart';
import '../../domain/repositories/task_repository.dart';
import '../../data/local/models/task_reminder_local.dart';
import '../../data/local/task_local_repository.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../data/services/task_service.dart';
import '../../data/dto/response/task_response.dart';

class TaskController extends BaseController {
  final TaskRepository repository = TaskRepositoryImpl(TaskService());
  final TaskLocalRepository localRepository = TaskLocalRepository();
  final NotificationSchedulerService schedulerService = NotificationSchedulerService();

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
        _syncReminders(data);
      },
      showLoading: false,
    );
  }

  Future<void> _syncReminders(List<TaskResponse> taskList) async {
    for (final task in taskList) {
      if (task.status == 'COMPLETE' || task.status == 'CANCELLED') {
        await schedulerService.cancelRemindersForTask(task.activityId);
        continue;
      }

      if (task.reminders != null && task.reminders!.isNotEmpty) {
        for (final reminder in task.reminders!) {
          try {
            DateTime remindDateTime;
            if (reminder.remindAt.contains('Z') || reminder.remindAt.contains('+')) {
              remindDateTime = DateTime.parse(reminder.remindAt).toLocal();
            } else {
              remindDateTime = DateTime.parse('${reminder.remindAt}Z').toLocal();
            }

            final localReminder = TaskReminderLocal()
              ..reminderId = reminder.id
              ..activityId = task.activityId
              ..taskTitle = task.activityName
              ..taskDescription = task.description
              ..remindAt = remindDateTime
              ..type = reminder.type
              ..isScheduled = true
              ..isSent = reminder.sent;

            await localRepository.saveReminder(localReminder);

            if (!reminder.sent && remindDateTime.isAfter(DateTime.now())) {
              await schedulerService.scheduleTaskReminder(
                id: reminder.id,
                activityId: task.activityId,
                title: task.activityName,
                description: task.description,
                remindAt: remindDateTime,
              );
            }
          } catch (_) {}
        }
      }
    }
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
