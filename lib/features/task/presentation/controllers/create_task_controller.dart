import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/services/notification_scheduler_service.dart';
import '../../../../shared/base/base_controller.dart';
import '../../domain/repositories/task_repository.dart';
import '../../data/dto/request/create_task_request.dart';
import '../../data/dto/response/label_response.dart';
import '../../data/dto/response/task_response.dart';
import '../../data/local/models/task_reminder_local.dart';
import '../../data/local/task_local_repository.dart';
import '../../data/services/task_service.dart';
import '../../data/repositories/task_repository_impl.dart';

class CreateTaskController extends BaseController {
  final TaskRepository repository = TaskRepositoryImpl(TaskService());
  final TaskLocalRepository localRepository = TaskLocalRepository();
  final NotificationSchedulerService schedulerService = NotificationSchedulerService();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null);

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

  DateTime? get combinedDeadline {
    if (selectedDate.value == null) return null;
    final date = selectedDate.value!;
    final time = selectedTime.value ?? const TimeOfDay(hour: 23, minute: 59);
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> submitTask() async {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Task title cannot be empty', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final String activityName = titleController.text.trim();
    final String description = descriptionController.text.trim();

    final deadlineDt = combinedDeadline;
    String? deadlineStr;
    if (deadlineDt != null) {
      deadlineStr = deadlineDt.toUtc().toIso8601String();
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
      recurringEndDate: recurring && deadlineDt != null ? DateFormat('yyyy-MM-dd').format(deadlineDt) : null,
      labelIds: selectedLabel.value != null ? [selectedLabel.value!.id] : [],
      reminders: remindersArray,
    );

    await executeApi<TaskResponse>(
      apiCall: () => repository.createTask(request),
      onSuccess: (data) async {
        Get.back(result: true);
        Get.snackbar('Success', 'Task created successfully!', backgroundColor: Colors.green, colorText: Colors.white);

        if (checklists.isNotEmpty) {
          for (var item in checklists) {
            repository.addChecklistItem(data.activityId, item);
          }
        }

        if (data.reminders != null && data.reminders!.isNotEmpty) {
          for (final reminder in data.reminders!) {
            try {
              DateTime remindDateTime;
              if (reminder.remindAt.contains('Z') || reminder.remindAt.contains('+')) {
                remindDateTime = DateTime.parse(reminder.remindAt).toLocal();
              } else {
                remindDateTime = DateTime.parse('${reminder.remindAt}Z').toLocal();
              }

              final localReminder = TaskReminderLocal()
                ..reminderId = reminder.id
                ..activityId = data.activityId
                ..taskTitle = data.activityName
                ..taskDescription = data.description
                ..remindAt = remindDateTime
                ..type = reminder.type
                ..isScheduled = true
                ..isSent = reminder.sent;

              await localRepository.saveReminder(localReminder);

              if (!reminder.sent) {
                await schedulerService.scheduleTaskReminder(
                  id: reminder.id,
                  activityId: data.activityId,
                  title: data.activityName,
                  description: data.description,
                  remindAt: remindDateTime,
                );
              }
            } catch (_) {}
          }
        }
      },
    );
  }

  Future<void> pickDeadlineDate(BuildContext context) async {
    final initialDate = selectedDate.value ?? DateTime.now();
    final pickedDate = await showDatePicker(
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

    if (pickedDate != null) {
      selectedDate.value = pickedDate;
    }
  }

  Future<void> pickDeadlineTime(BuildContext context) async {
    final initialTime = selectedTime.value ?? TimeOfDay.now();
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
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

    if (pickedTime != null) {
      selectedTime.value = pickedTime;
    }
  }

  String get formattedDeadlineDate {
    if (selectedDate.value == null) return 'Not set';
    return DateFormat('d MMMM yyyy').format(selectedDate.value!);
  }

  String get formattedDeadlineTime {
    if (selectedTime.value == null) return 'Not set';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, selectedTime.value!.hour, selectedTime.value!.minute);
    return DateFormat('hh:mm a').format(dt);
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
