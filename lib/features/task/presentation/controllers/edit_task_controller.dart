import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/services/notification_scheduler_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../../../shared/base/base_controller.dart';
import '../../domain/repositories/task_repository.dart';
import '../../data/dto/request/update_task_request.dart';
import '../../data/dto/response/attachment_response.dart';
import '../../data/dto/response/label_response.dart';
import '../../data/dto/response/reminder_response.dart';
import '../../data/dto/response/task_response.dart';
import '../../data/local/models/task_reminder_local.dart';
import '../../data/local/task_local_repository.dart';
import '../../data/services/task_service.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../groups/domain/repositories/group_repository.dart';
import '../../../groups/data/repositories/group_repository_impl.dart';
import '../../../groups/data/services/group_service.dart';

class EditTaskController extends BaseController {
  AppLocalizations? get _l10n {
    final ctx = Get.context;
    return ctx == null ? null : AppLocalizations.of(ctx);
  }
  final TaskRepository repository = TaskRepositoryImpl(TaskService());
  final GroupRepository groupRepository = GroupRepositoryImpl(groupService: GroupService());
  final TaskLocalRepository localRepository = TaskLocalRepository();
  final NotificationSchedulerService schedulerService = NotificationSchedulerService();
  final ImagePicker _picker = ImagePicker();
  final Logger _logger = Logger();

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
  final List<int> attachmentsToDelete = [];
  final RxList<dynamic> collaborators = <dynamic>[].obs;
  final List<dynamic> newCollaboratorsToInvite = [];
  final List<int> collaboratorsToRemove = [];
  final RxBool isUploadingAttachment = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is TaskResponse) {
      initialTask = Get.arguments as TaskResponse;
      if (initialTask.isComplete || initialTask.isPastDeadline) {
        Get.back();
        Get.snackbar(
          _l10n?.errorTitle ?? 'Locked',
          _l10n?.cannotEditAfterDeadline ?? 'This task cannot be edited after the deadline.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      _populateInitialData();
    } else {
      Get.back();
      Get.snackbar(_l10n?.errorTitle ?? 'Error', _l10n?.noTaskData ?? 'No task data provided', backgroundColor: Colors.red, colorText: Colors.white);
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
    if (initialTask.description != null && initialTask.description!.isNotEmpty) {
      descriptionController.text = initialTask.description!;
    } else {
      descriptionController.text = '';
    }

    if (initialTask.deadline != null) {
      final parsed = DateTime.tryParse(initialTask.deadline!);
      if (parsed != null) {
        selectedDate.value = parsed.toLocal();
        selectedTime.value = TimeOfDay(hour: parsed.toLocal().hour, minute: parsed.toLocal().minute);
      }
    } else {
      selectedDate.value = DateTime.now();
    }

    if (initialTask.priority != null) {
      priority.value = initialTask.priority!;
    } else {
      priority.value = 'LOW';
    }

    isRecurring.value = initialTask.recurring;
    repeatFrequency.value = initialTask.recurringType ?? 'DAILY';
    remindersEnabled.value = (initialTask.reminders != null && initialTask.reminders!.isNotEmpty);

    if (initialTask.checklists != null && initialTask.checklists!.isNotEmpty) {
      for (var c in initialTask.checklists!) {
        checklists.add({
          'id': c.id,
          'controller': TextEditingController(text: c.itemName),
          'completed': c.completed,
        });
      }
    }

    if (initialTask.attachments != null && initialTask.attachments!.isNotEmpty) {
      existingAttachments.addAll(initialTask.attachments!);
    }

    if (initialTask.collaborators != null && initialTask.collaborators!.isNotEmpty) {
      collaborators.assignAll(initialTask.collaborators!.map((c) {
        if (c is Map) {
          final displayName = '${c['firstname'] ?? ''} ${c['lastname'] ?? ''}'.trim();
          return {
            'userId': c['userId'],
            'username': c['username'] ?? '',
            'name': displayName.isNotEmpty ? displayName : (c['name'] ?? c['displayName'] ?? c['username'] ?? 'User'),
            'profilePic': c['profilePic'],
            'role': c['role'],
          };
        }
        return c;
      }).toList());
    }

    if (initialTask.labels != null && initialTask.labels!.isNotEmpty) {
      selectedLabel.value = initialTask.labels!.first;
    }
  }

  Future<void> loadLabels() async {
    final result = await repository.getLabels();
    if (result is ApiSuccess<List<LabelResponse>>) {
      availableLabels.assignAll(result.data);
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
        Get.snackbar(_l10n?.success ?? 'Done', _l10n?.labelCreatedSuccess ?? 'Label created successfully!', backgroundColor: Colors.green, colorText: Colors.white);
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
    } catch (e, stack) {
      _logger.e('Failed to pick image from device: $e', error: e, stackTrace: stack);
    }
  }

  void removePickedAttachment(int index) {
    if (index >= 0 && index < pickedAttachments.length) {
      pickedAttachments.removeAt(index);
    }
  }

  void removeExistingAttachment(int index) {
    if (index >= 0 && index < existingAttachments.length) {
      final item = existingAttachments[index];
      int? attId;
      if (item is Map && item['id'] != null) {
        attId = item['id'] is int ? item['id'] : int.tryParse(item['id'].toString());
      } else if (item is AttachmentResponse) {
        attId = item.id;
      }
      if (attId != null) {
        attachmentsToDelete.add(attId);
      }
      existingAttachments.removeAt(index);
    }
  }

  void addCollaborator(dynamic user) {
    final exists = collaborators.any((c) {
      if (c is Map && user is Map) {
        if (c['userId'] != null && user['userId'] != null) {
          return c['userId'] == user['userId'];
        }
        if (c['username'] != null && user['username'] != null) {
          return c['username'].toString().toLowerCase() == user['username'].toString().toLowerCase();
        }
      }
      return c == user;
    });

    if (!exists) {
      collaborators.add(user);
      newCollaboratorsToInvite.add(user);
    }
  }

  void removeCollaborator(int index) {
    if (index < 0 || index >= collaborators.length) return;
    final item = collaborators[index];

    if (newCollaboratorsToInvite.contains(item)) {
      newCollaboratorsToInvite.remove(item);
    } else {
      final dynamic rawId = item is Map ? item['userId'] : null;
      final int? memberId = rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '');
      if (memberId != null && memberId > 0) {
        collaboratorsToRemove.add(memberId);
      }
    }

    collaborators.removeAt(index);
  }

  Future<void> saveChanges() async {
    if (initialTask.isComplete || initialTask.isPastDeadline) {
      Get.snackbar(_l10n?.errorTitle ?? 'Error', _l10n?.cannotEditAfterDeadline ?? 'This task cannot be modified after the deadline.', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (titleController.text.trim().isEmpty) {
      Get.snackbar(_l10n?.errorTitle ?? 'Error', _l10n?.taskTitleEmpty ?? 'Task title cannot be empty', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    AppDialogs.showLoading();

    try {
      if (pickedAttachments.isNotEmpty) {
        for (int i = 0; i < pickedAttachments.length; i++) {
          final file = pickedAttachments[i];
          final uploadResult = await repository.uploadTaskAttachment(initialTask.activityId, file.path);
          if (uploadResult is ApiError) {
            _logger.e('Failed to upload task attachment: ${uploadResult.exception?.message}');
          }
        }
      }

      if (attachmentsToDelete.isNotEmpty) {
        for (final attId in attachmentsToDelete) {
          await repository.deleteAttachment(attId);
        }
      }

      if (newCollaboratorsToInvite.isNotEmpty) {
        for (final c in newCollaboratorsToInvite) {
          String identifier = '';
          if (c is Map) {
            identifier = (c['username'] ?? c['email'] ?? c['name'] ?? '').toString().trim();
          } else if (c is String) {
            identifier = c.trim();
          }
          if (identifier.isNotEmpty) {
            await groupRepository.inviteMember(initialTask.activityId, identifier);
          }
        }
      }

      if (collaboratorsToRemove.isNotEmpty) {
        for (final memberId in collaboratorsToRemove) {
          await groupRepository.removeMember(initialTask.activityId, memberId);
        }
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

      final updateResult = await repository.updateTask(initialTask.activityId, request.toJson());
      AppDialogs.hideLoading();

      if (updateResult is ApiSuccess<TaskResponse>) {
        final data = updateResult.data;
        Get.back(result: true);
        Get.snackbar(_l10n?.success ?? 'Done', _l10n?.taskUpdatedSuccess ?? 'Task updated successfully!', backgroundColor: Colors.green, colorText: Colors.white);
        _processBackgroundUpdates(data.activityId, activityName, description);
      } else if (updateResult is ApiError<TaskResponse>) {
        _logger.e('Update task failed: ${updateResult.exception.message}');
        Get.snackbar(_l10n?.updateFailedTitle ?? 'Update Failed', updateResult.exception.message, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e, stack) {
      AppDialogs.hideLoading();
      _logger.e('Unexpected error during saveChanges: $e', error: e, stackTrace: stack);
      Get.snackbar(_l10n?.errorTitle ?? 'Error', _l10n?.unexpectedError ?? 'Something went wrong. Try again.', backgroundColor: Colors.red, colorText: Colors.white);
    }
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
        "type": "CUSTOM"
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
            colorScheme: ColorScheme.light(
              primary: AppColors.accentBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
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
            colorScheme: ColorScheme.light(
              primary: AppColors.accentBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
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
    if (selectedDate.value == null) return '13th August 2026';
    final date = selectedDate.value!;
    String day = DateFormat('d').format(date);
    String suffix = 'th';
    if (day.endsWith('1') && !day.endsWith('11')) {
      suffix = 'st';
    } else if (day.endsWith('2') && !day.endsWith('12')) {
      suffix = 'nd';
    } else if (day.endsWith('3') && !day.endsWith('13')) {
      suffix = 'rd';
    }
    return '$day$suffix ${DateFormat('MMMM yyyy').format(date)}';
  }

  String get formattedReminderDate {
    final date = selectedDate.value ?? DateTime(2026, 8, 6);
    String day = DateFormat('d').format(date).padLeft(2, '0');
    String suffix = 'TH';
    if (day.endsWith('1') && !day.endsWith('11')) {
      suffix = 'ST';
    } else if (day.endsWith('2') && !day.endsWith('12')) {
      suffix = 'ND';
    } else if (day.endsWith('3') && !day.endsWith('13')) {
      suffix = 'RD';
    }
    return '$day$suffix ${DateFormat('MMMM yyyy').format(date).toUpperCase()}';
  }

  void cyclePriority() {
    const list = ['LOW', 'MEDIUM', 'HIGH', 'URGENT'];
    final idx = list.indexOf(priority.value.toUpperCase());
    priority.value = list[(idx + 1) % list.length];
  }

  void cycleRepeat() {
    const list = ['DAILY', 'WEEKLY', 'MONTHLY', 'NONE'];
    final current = repeatFrequency.value?.toUpperCase() ?? 'DAILY';
    final idx = list.indexOf(current);
    final next = list[(idx + 1) % list.length];
    if (next == 'NONE') {
      repeatFrequency.value = null;
      isRecurring.value = false;
    } else {
      repeatFrequency.value = next;
      isRecurring.value = true;
    }
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
