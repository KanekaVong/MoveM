import 'package:isar/isar.dart';
import '../../../../core/storage/app_database.dart';
import 'models/task_reminder_local.dart';

class TaskLocalRepository {
  Future<Isar> get _isar async => await AppDatabase().isar;

  Future<void> saveReminder(TaskReminderLocal reminder) async {
    final db = await _isar;
    await db.writeTxn(() async {
      await db.taskReminderLocals.putByReminderId(reminder);
    });
  }

  Future<void> saveReminders(List<TaskReminderLocal> reminders) async {
    if (reminders.isEmpty) return;
    final db = await _isar;
    await db.writeTxn(() async {
      for (final reminder in reminders) {
        await db.taskReminderLocals.putByReminderId(reminder);
      }
    });
  }

  Future<TaskReminderLocal?> getReminderByServerId(int reminderId) async {
    final db = await _isar;
    return await db.taskReminderLocals.filter().reminderIdEqualTo(reminderId).findFirst();
  }

  Future<List<TaskReminderLocal>> getRemindersForTask(String activityId) async {
    final db = await _isar;
    return await db.taskReminderLocals.filter().activityIdEqualTo(activityId).findAll();
  }

  Future<List<TaskReminderLocal>> getPendingReminders() async {
    final db = await _isar;
    final now = DateTime.now();
    return await db.taskReminderLocals
        .filter()
        .isCancelledEqualTo(false)
        .isSentEqualTo(false)
        .remindAtGreaterThan(now)
        .findAll();
  }

  Future<void> markReminderSent(int reminderId) async {
    final db = await _isar;
    final reminder = await getReminderByServerId(reminderId);
    if (reminder != null) {
      reminder.isSent = true;
      await db.writeTxn(() async {
        await db.taskReminderLocals.put(reminder);
      });
    }
  }

  Future<void> deleteReminderByServerId(int reminderId) async {
    final db = await _isar;
    final reminder = await getReminderByServerId(reminderId);
    if (reminder != null) {
      await db.writeTxn(() async {
        await db.taskReminderLocals.delete(reminder.id);
      });
    }
  }

  Future<void> deleteRemindersForTask(String activityId) async {
    final db = await _isar;
    final reminders = await getRemindersForTask(activityId);
    if (reminders.isNotEmpty) {
      final ids = reminders.map((r) => r.id).toList();
      await db.writeTxn(() async {
        await db.taskReminderLocals.deleteAll(ids);
      });
    }
  }

  Future<List<TaskReminderLocal>> getAllReminders() async {
    final db = await _isar;
    return await db.taskReminderLocals.where().findAll();
  }
}
