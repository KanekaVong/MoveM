import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../shared/base/base_controller.dart';
import '../../domain/repositories/task_repository.dart';
import '../../data/dto/response/task_response.dart';
import '../../data/dto/response/checklist_response.dart';
import '../../data/services/task_service.dart';
import '../../data/repositories/task_repository_impl.dart';

class TaskDetailController extends BaseController {
  final TaskRepository repository = TaskRepositoryImpl(TaskService());
  final String activityId;

  final Rx<TaskResponse?> task = Rx<TaskResponse?>(null);

  TaskDetailController({required this.activityId});

  @override
  void onReady() {
    super.onReady();
    fetchTaskDetail();
  }

  Future<void> fetchTaskDetail({bool showLoading = true}) async {
    await executeApi<TaskResponse>(
      apiCall: () => repository.getTaskDetail(activityId),
      showLoading: showLoading,
      onSuccess: (data) {
        task.value = data;
      },
    );
  }

  Future<void> markAsComplete() async {
    final currentTask = task.value;
    if (currentTask == null) return;

    await executeApi<TaskResponse>(
      apiCall: () => repository.markTaskComplete(currentTask.activityId),
      showLoading: true,
      onSuccess: (data) {
        task.value = data;
        Get.back(result: true);
        Get.snackbar('Success', 'Task marked as complete!', backgroundColor: Colors.green, colorText: Colors.white);
      },
    );
  }

  Future<void> toggleChecklistItem(int checklistId, bool currentStatus) async {
    if (task.value == null) return;

    final currentTask = task.value!;

    final updatedChecklists = currentTask.checklists?.map((item) {
      if (item.id == checklistId) {
        return ChecklistResponse(
          id: item.id,
          itemName: item.itemName,
          completed: !currentStatus,
        );
      }
      return item;
    }).toList();

    int completedDelta = currentStatus ? -1 : 1;
    int newCompleted = currentTask.completedChecklistItems + completedDelta;
    if (newCompleted < 0) newCompleted = 0;

    double newProgress = currentTask.totalChecklistItems > 0
        ? newCompleted / currentTask.totalChecklistItems
        : 0.0;

    task.value = TaskResponse(
      activityId: currentTask.activityId,
      activityName: currentTask.activityName,
      description: currentTask.description,
      startActivity: currentTask.startActivity,
      deadline: currentTask.deadline,
      priority: currentTask.priority,
      status: currentTask.status,
      recurring: currentTask.recurring,
      recurringType: currentTask.recurringType,
      totalChecklistItems: currentTask.totalChecklistItems,
      completedChecklistItems: newCompleted,
      checklistProgress: newProgress,
      labels: currentTask.labels,
      reminders: currentTask.reminders,
      checklists: updatedChecklists,
    );

    await executeApi<void>(
      apiCall: () => repository.toggleChecklistItem(checklistId),
      showLoading: false,
      onSuccess: (_) {
        fetchTaskDetail(showLoading: false);
      },
      onError: (e) {
        fetchTaskDetail(showLoading: false);
      },
    );
  }
}
