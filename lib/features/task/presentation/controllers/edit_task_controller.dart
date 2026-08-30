import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/services/notification_scheduler_service.dart';
import '../../../../shared/base/base_controller.dart';
import '../../domain/repositories/task_repository.dart';
import '../../data/dto/request/update_task_request.dart';
import '../../data/dto/response/label_response.dart';
import '../../data/dto/response/reminder_response.dart';
import '../../data/dto/response/task_response.dart';
import '../../data/local/models/task_reminder_local.dart';
import '../../data/local/task_local_repository.dart';
import '../../data/services/task_service.dart';
import '../../data/repositories/task_repository_impl.dart';

class EditTaskController extends BaseController {
  final TaskRepository repository = TaskRepositoryImpl(TaskService());
  final TaskLocalRepository localRepository = TaskLocalRepository();
  final NotificationSchedulerService schedulerService = NotificationSchedulerService();
  final ImagePicker _picker = ImagePicker();

  late TaskResponse initialTask;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null);

  final RxList<Map<String, dynamic>> checklists = <Map<String, dynamic>>[].obs;
  final List<int> deletedChecklistIds = [];

  final RxString priority = 'LOW'.obs;
  final RxBool isRecurring = false.obs;
  final Rx<String?> repeatFrequency = Rx<String?>(null);
  final RxBool remindersEnabled = false.obs;

  final RxList<LabelResponse> availableLabels = <LabelResponse>[].obs;
  final Rx<LabelResponse?> selectedLabel = Rx<LabelResponse?>(null);

  final RxList<XFile> pickedAttachments = <XFile>[].obs;
  final RxList<dynamic> existingAttachments = <dynamic>[].obs;
  final RxList<dynamic> collaborators = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is TaskResponse) {
      initialTask = Get.arguments as TaskResponse;
      _populateInitialData();
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
      final parsed = DateTime.tryParse(initialTask.deadline!);
      if (parsed != null) {
        selectedDate.value = parsed.toLocal();
        selectedTime.value = TimeOfDay(hour: parsed.toLocal().hour, minute: parsed.toLocal().minute);
      }
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

    if (initialTask.attachments != null) {
      existingAttachments.addAll(initialTask.attachments!);
    }

    if (initialTask.collaborators != null) {
      collaborators.addAll(initialTask.collaborators!);
    }

    if (initialTask.labels != null && initialTask.labels!.isNotEmpty) {
      availableLabels.assignAll(initialTask.labels!);
      selectedLabel.value = initialTask.labels!.first;
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

  Future<void> pickAttachment(ImageSource source) async {
    try {
      final image = await _picker.pickImage(source: source);
      if (image != null) {
        pickedAttachments.add(image);
      }
    } catch (_) {}
  }

  void removePickedAttachment(int index) {
    if (index >= 0 && index < pickedAttachments.length) {
      pickedAttachments.removeAt(index);
    }
  }

  void removeExistingAttachment(int index) {
    if (index >= 0 && index < existingAttachments.length) {
      existingAttachments.removeAt(index);
    }
  }

  void addCollaborator(String name) {
    if (name.trim().isNotEmpty) {
      collaborators.add({'username': name.trim(), 'name': name.trim()});
    }
  }

  void removeCollaborator(int index) {
    if (index >= 0 && index < collaborators.length) {
      collaborators.removeAt(index);
    }
  }

  Future<void> saveChanges() async {
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
      recurringEndDate: recurring && deadlineDt != null ? DateFormat('yyyy-MM-dd').format(deadlineDt) : null,
      labelIds: selectedLabel.value != null ? [selectedLabel.value!.id] : [],
    );

    await executeApi<TaskResponse>(
      apiCall: () => repository.updateTask(initialTask.activityId, request.toJson()),
      onSuccess: (data) {
        Get.back(result: true);
        Get.snackbar('Success', 'Task updated successfully!', backgroundColor: Colors.green, colorText: Colors.white);

        _processBackgroundUpdates(data.activityId, activityName, description);
      },
    );
  }

  void _processBackgroundUpdates(String activityId, String title, String description) async {
    for (var id in deletedChecklistIds) {
      repository.deleteChecklistItem(id);
    }

    for (var item in checklists) {
      if (item['id'] == null) {
        final text = (item['controller'] as TextEditingController).text.trim();
        if (text.isNotEmpty) {
          repository.addChecklistItem(activityId, {'itemName': text});
        }
      }
    }

    final hadReminders = initialTask.reminders != null && initialTask.reminders!.isNotEmpty;
    final deadlineDt = combinedDeadline;
    if (remindersEnabled.value && !hadReminders && deadlineDt != null) {
      final remindAtUtc = deadlineDt.toUtc().toIso8601String();
      final result = await repository.addReminder(activityId, {
        "remindAt": remindAtUtc,
        "type": "DUE_DATE"
      });

      if (result is ApiSuccess<ReminderResponse>) {
        final r = result.data;
        final localReminder = TaskReminderLocal()
          ..reminderId = r.id
          ..activityId = activityId
          ..taskTitle = title
          ..taskDescription = description
          ..remindAt = deadlineDt
          ..type = r.type
          ..isScheduled = true
          ..isSent = r.sent;

        await localRepository.saveReminder(localReminder);
        await schedulerService.scheduleTaskReminder(
          id: r.id,
          activityId: activityId,
          title: title,
          description: description,
          remindAt: deadlineDt,
        );
      }
    } else if (!remindersEnabled.value && hadReminders) {
      await schedulerService.cancelRemindersForTask(activityId);
      for (var reminder in initialTask.reminders!) {
        repository.deleteReminder(reminder.id);
      }
    }
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
