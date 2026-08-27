import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/network/api_result.dart';
import '../../../../shared/base/base_controller.dart';
import '../../domain/repositories/task_repository.dart';
import '../../data/dto/request/update_task_request.dart';
import '../../data/dto/response/label_response.dart';
import '../../data/dto/response/task_response.dart';
import '../../data/services/task_service.dart';
import '../../data/repositories/task_repository_impl.dart';

class EditTaskController extends BaseController {
  final TaskRepository repository = TaskRepositoryImpl(TaskService());

  late TaskResponse initialTask;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final Rx<DateTime?> deadline = Rx<DateTime?>(null);

  final RxList<Map<String, dynamic>> checklists = <Map<String, dynamic>>[].obs;
  final List<int> deletedChecklistIds = [];

  final RxString priority = 'LOW'.obs;
  final RxBool isRecurring = false.obs;
  final Rx<String?> repeatFrequency = Rx<String?>(null);
  final RxBool remindersEnabled = false.obs;

  final RxList<LabelResponse> availableLabels = <LabelResponse>[].obs;
  final Rx<LabelResponse?> selectedLabel = Rx<LabelResponse?>(null);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is TaskResponse) {
      initialTask = Get.arguments as TaskResponse;
      _populateInitialData();
      _loadLabels();
    } else {
      Get.back();
      Get.snackbar('Error', 'No task data provided', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    for (var item in checklists) {
      (item['controller'] as TextEditingController).dispose();
    }
    super.onClose();
  }

  void _populateInitialData() {
    titleController.text = initialTask.activityName;
    if (initialTask.description != null) {
      descriptionController.text = initialTask.description!;
    }

    if (initialTask.deadline != null) {
      deadline.value = DateTime.tryParse(initialTask.deadline!);
    }

    if (initialTask.priority != null) {
      priority.value = initialTask.priority!;
    }

    isRecurring.value = initialTask.recurring;
    repeatFrequency.value = initialTask.recurringType;
    remindersEnabled.value = (initialTask.reminders != null && initialTask.reminders!.isNotEmpty);

    if (initialTask.checklists != null) {
      for (var c in initialTask.checklists!) {
        checklists.add({
          'id': c.id,
          'controller': TextEditingController(text: c.itemName),
        });
      }
    }
  }

  Future<void> _loadLabels() async {
    final result = await repository.getLabels();
    if (result is ApiSuccess<List<LabelResponse>>) {
      availableLabels.value = result.data;
      if (initialTask.labels != null && initialTask.labels!.isNotEmpty) {
        final existingLabelId = initialTask.labels!.first.id;
        try {
          selectedLabel.value = availableLabels.firstWhere((l) => l.id == existingLabelId);
        } catch (_) {}
      }
    }
  }

  void toggleReminders() {
    remindersEnabled.value = !remindersEnabled.value;
  }

  Future<void> createLabel(String name, String color) async {
    final formattedColor = color.startsWith('#') ? color : '#$color';
    await executeApi<LabelResponse>(
      apiCall: () => repository.createLabel(name, formattedColor),
      onSuccess: (data) {
        availableLabels.add(data);
        selectedLabel.value = data;
        Get.back();
        Get.snackbar('Success', 'Label created successfully!', backgroundColor: Colors.green, colorText: Colors.white);
      },
    );
  }

  Future<void> saveChanges() async {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Task title cannot be empty', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final String activityName = titleController.text.trim();
    final String description = descriptionController.text.trim();

    String? deadlineStr;
    if (deadline.value != null) {
      deadlineStr = deadline.value!.toUtc().toIso8601String();
    }

    final bool recurring = repeatFrequency.value != null;

    final request = UpdateTaskRequest(
      activityName: activityName,
      description: description.isEmpty ? null : description,
      startActivity: deadlineStr,
      deadline: deadlineStr,
      priority: priority.value,
      status: initialTask.status ?? 'PENDING',
      isRecurring: recurring,
      recurringType: recurring ? repeatFrequency.value?.toUpperCase() : null,
      recurringInterval: recurring ? 0 : null,
      recurringEndDate: recurring && deadline.value != null ? DateFormat('yyyy-MM-dd').format(deadline.value!) : null,
      labelIds: selectedLabel.value != null ? [selectedLabel.value!.id] : [],
    );

    debugPrint('Update Task Request: \n${const JsonEncoder.withIndent('  ').convert(request.toJson())}');

    await executeApi<TaskResponse>(
      apiCall: () => repository.updateTask(initialTask.activityId, request.toJson()),
      onSuccess: (data) {
        Get.back(result: true);
        Get.snackbar('Success', 'Task updated successfully!', backgroundColor: Colors.green, colorText: Colors.white);

        _processBackgroundUpdates(data.activityId);
      },
    );
  }

  void _processBackgroundUpdates(String activityId) {

    for (var id in deletedChecklistIds) {
      repository.deleteChecklistItem(id);
    }

    for (var item in checklists) {
      if (item['id'] == null) {
        final text = (item['controller'] as TextEditingController).text.trim();
        if (text.isNotEmpty) {
          repository.addChecklistItem(activityId, {'itemName': text});
        }
      } else {

      }
    }

    if (remindersEnabled.value && !initialTask.reminders!.isNotEmpty && deadline.value != null) {

      repository.addReminder(activityId, {
        "remindAt": deadline.value!.toUtc().toIso8601String(),
        "type": "DUE_DATE"
      });
    } else if (!remindersEnabled.value && initialTask.reminders != null) {

      for (var reminder in initialTask.reminders!) {
        repository.deleteReminder(reminder.id);
      }
    }
  }

  Future<void> pickDeadline(BuildContext context) async {
    final initialDate = deadline.value ?? DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF3B82F6),
              onPrimary: Colors.white,
              surface: Color(0xFF131B2F),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      deadline.value = selectedDate;
    }
  }

  String get formattedDeadline {
    if (deadline.value == null) return 'Not set';
    return DateFormat('d MMMM yyyy').format(deadline.value!);
  }

  void addChecklistItem() {
    checklists.add({'id': null, 'controller': TextEditingController()});
  }

  void removeChecklistItem(int index) {
    if (index >= 0 && index < checklists.length) {
      final item = checklists[index];
      if (item['id'] != null) {
        deletedChecklistIds.add(item['id']);
      }
      (item['controller'] as TextEditingController).dispose();
      checklists.removeAt(index);
    }
  }
}
