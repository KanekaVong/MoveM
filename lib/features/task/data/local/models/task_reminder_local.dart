import 'package:isar/isar.dart';

part 'task_reminder_local.g.dart';

@collection
class TaskReminderLocal {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  int reminderId = 0;

  @Index()
  String activityId = '';

  String taskTitle = '';

  String? taskDescription;

  DateTime remindAt = DateTime.now();

  String type = 'DUE_DATE';

  bool isScheduled = false;

  bool isSent = false;

  bool isCancelled = false;

  DateTime createdAt = DateTime.now();
}
