import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../features/task/data/local/models/task_reminder_local.dart';
import '../../features/task/data/local/task_local_repository.dart';

class NotificationSchedulerService {
  static final NotificationSchedulerService _instance =
      NotificationSchedulerService._internal();
  factory NotificationSchedulerService() => _instance;
  NotificationSchedulerService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final TaskLocalRepository _taskLocalRepository = TaskLocalRepository();

  bool _isInitialized = false;

  static const AndroidNotificationChannel taskReminderChannel =
      AndroidNotificationChannel(
    'task_reminder_channel',
    'Task Reminders',
    description: 'Notifications for task deadlines and upcoming reminders',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(taskReminderChannel);

      _isInitialized = true;
    } catch (_) {}
  }

  Future<bool> scheduleTaskReminder({
    required int id,
    required String activityId,
    required String title,
    String? description,
    required DateTime remindAt,
  }) async {
    try {
      await initialize();

      if (remindAt.isBefore(DateTime.now())) {
        return false;
      }

      final scheduledDate = tz.TZDateTime.from(remindAt, tz.local);

      const androidDetails = AndroidNotificationDetails(
        'task_reminder_channel',
        'Task Reminders',
        channelDescription:
            'Notifications for task deadlines and upcoming reminders',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        playSound: true,
        enableVibration: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final payload = jsonEncode({
        'type': 'task_reminder',
        'activityId': activityId,
        'reminderId': id,
      });

      try {
        await _localNotifications.zonedSchedule(
          id: id,
          title: 'Task Reminder: $title',
          body: description != null && description.isNotEmpty
              ? description
              : "Don't forget to complete your task!",
          scheduledDate: scheduledDate,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: payload,
        );
      } catch (_) {
        await _localNotifications.zonedSchedule(
          id: id,
          title: 'Task Reminder: $title',
          body: description != null && description.isNotEmpty
              ? description
              : "Don't forget to complete your task!",
          scheduledDate: scheduledDate,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: payload,
        );
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> cancelReminder(int id) async {
    try {
      await _localNotifications.cancel(id: id);
      await _taskLocalRepository.deleteReminderByServerId(id);
    } catch (_) {}
  }

  Future<void> cancelRemindersForTask(String activityId) async {
    try {
      final reminders =
          await _taskLocalRepository.getRemindersForTask(activityId);
      for (final reminder in reminders) {
        await _localNotifications.cancel(id: reminder.reminderId);
      }
      await _taskLocalRepository.deleteRemindersForTask(activityId);
    } catch (_) {}
  }

  Future<void> rescheduleAllPendingReminders() async {
    try {
      await initialize();
      final pendingReminders =
          await _taskLocalRepository.getPendingReminders();

      for (final reminder in pendingReminders) {
        await scheduleTaskReminder(
          id: reminder.reminderId,
          activityId: reminder.activityId,
          title: reminder.taskTitle,
          description: reminder.taskDescription,
          remindAt: reminder.remindAt,
        );
      }
    } catch (_) {}
  }
}
