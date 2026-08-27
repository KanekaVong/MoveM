import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/network/api_result.dart';
import '../../../../shared/base/base_controller.dart';
import '../../domain/repositories/task_repository.dart';
import '../../data/dto/request/create_task_request.dart';
import '../../data/dto/response/label_response.dart';
import '../../data/dto/response/task_response.dart';
import '../../data/services/task_service.dart';
import '../../data/repositories/task_repository_impl.dart';

class CreateTaskController extends BaseController {
  final TaskRepository repository = TaskRepositoryImpl(TaskService());

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final Rx<DateTime?> deadline = Rx<DateTime?>(null);

  final RxList<TextEditingController> checklistControllers = <TextEditingController>[].obs;

  final RxString priority = 'LOW'.obs;
  final RxBool isRecurring = false.obs;
  final Rx<String?> repeatFrequency = Rx<String?>(null);
  final RxBool remindersEnabled = false.obs;

  final RxList<LabelResponse> availableLabels = <LabelResponse>[].obs;
  final Rx<LabelResponse?> selectedLabel = Rx<LabelResponse?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadLabels();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    for (var controller in checklistControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  Future<void> _loadLabels() async {
    final result = await repository.getLabels();
    if (result is ApiSuccess<List<LabelResponse>>) {
      availableLabels.value = result.data;
    } else if (result is ApiError) {
      debugPrint('Failed to load labels: ${(result as ApiError).exception.message}');
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

  Future<void> submitTask() async {
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

    final List<Map<String, String>> checklists = getChecklistItems()
        .map((item) => {"itemName": item})
        .toList();

    List<Map<String, dynamic>>? remindersArray;
    if (remindersEnabled.value && deadlineStr != null) {
      remindersArray = [
        {"remindAt": deadlineStr, "type": "DUE_DATE"}
      ];
    }

    final bool recurring = repeatFrequency.value != null;

    final request = CreateTaskRequest(
      activityName: activityName,
      description: description,
      startActivity: deadlineStr,
      deadline: deadlineStr,
      checklists: const [],
      priority: priority.value,
      isRecurring: recurring,
      recurringType: recurring ? repeatFrequency.value?.toUpperCase() : null,
      recurringInterval: recurring ? 0 : null,
      recurringEndDate: recurring && deadline.value != null ? DateFormat('yyyy-MM-dd').format(deadline.value!) : null,
      labelIds: selectedLabel.value != null ? [selectedLabel.value!.id] : [],
      reminders: remindersArray,
    );

    debugPrint('Create Task Request: \n${const JsonEncoder.withIndent('  ').convert(request.toJson())}');

    await executeApi<TaskResponse>(
      apiCall: () => repository.createTask(request),
      onSuccess: (data) {
        Get.back(result: true);
        Get.snackbar('Success', 'Task created successfully!', backgroundColor: Colors.green, colorText: Colors.white);

        if (checklists.isNotEmpty) {
          for (var item in checklists) {
            repository.addChecklistItem(data.activityId, item);
          }
        }
      },
    );
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
    checklistControllers.add(TextEditingController());
  }

  void removeChecklistItem(int index) {
    if (index >= 0 && index < checklistControllers.length) {
      final controller = checklistControllers[index];
      checklistControllers.removeAt(index);
      controller.dispose();
    }
  }

  List<String> getChecklistItems() {
    return checklistControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();
  }
}
