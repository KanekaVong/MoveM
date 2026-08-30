import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../features/task/presentation/screens/task_detail_screen.dart';
import '../../firebase_options.dart';
import '../routes/app_routes.dart';
import '../storage/user_manager.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {}
}

const AndroidNotificationChannel highImportanceChannel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications and alerts.',
  importance: Importance.max,
  playSound: true,
  enableVibration: true,
);

class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(highImportanceChannel);

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
      );

      await _localNotifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          if (response.payload != null && response.payload!.isNotEmpty) {
            try {
              final data = jsonDecode(response.payload!) as Map<String, dynamic>;
              _handleNotificationClick(data);
            } catch (_) {}
          } else {
            _navigateToNotifications();
          }
        },
      );

      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      _messaging.onTokenRefresh.listen((newToken) async {
        await UserManager().saveFcmToken(newToken);
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _showForegroundNotification(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleNotificationClick(message.data);
      });

      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        Future.delayed(const Duration(milliseconds: 600), () {
          _handleNotificationClick(initialMessage.data);
        });
      }

      _isInitialized = true;
    } catch (_) {}
  }

  Future<void> requestNotificationPermissions() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        await _retrieveAndSaveToken();
      }
    } catch (_) {}
  }

  Future<String?> _retrieveAndSaveToken() async {
    try {
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
        String? apnsToken = await _messaging.getAPNSToken();
        int retries = 0;
        while (apnsToken == null && retries < 3) {
          await Future.delayed(const Duration(seconds: 2));
          apnsToken = await _messaging.getAPNSToken();
          retries++;
        }

        if (apnsToken == null) {
          return null;
        }
      }

      final token = await _messaging.getToken();

      if (token != null) {
        await UserManager().saveFcmToken(token);
      }
      return token;
    } catch (_) {
      return null;
    }
  }

  Future<String?> getToken() async {
    final savedToken = await UserManager().getFcmToken();
    if (savedToken != null && savedToken.isNotEmpty) {
      return savedToken;
    }
    return await _retrieveAndSaveToken();
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    final title = notification?.title ?? data['title'] ?? 'Notification';
    final body = notification?.body ?? data['body'] ?? '';

    final androidDetails = AndroidNotificationDetails(
      highImportanceChannel.id,
      highImportanceChannel.name,
      channelDescription: highImportanceChannel.description,
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

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final notificationId = message.messageId.hashCode;

    await _localNotifications.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: details,
      payload: jsonEncode(message.data),
    );
  }

  void _handleNotificationClick(Map<String, dynamic> data) {
    if (data.isEmpty) {
      _navigateToNotifications();
      return;
    }

    final route = data['route'] as String?;
    final type = data['type'] as String? ?? data['notificationType'] as String?;

    if (route != null && route.isNotEmpty) {
      Get.toNamed(route);
      return;
    }

    if (type != null) {
      switch (type.toLowerCase()) {
        case 'friends':
        case 'friend_request':
          Get.toNamed(AppRoutes.main, arguments: {'tab': 2});
          break;
        case 'task':
        case 'task_reminder':
          final activityId = data['activityId'] as String?;
          if (activityId != null && activityId.isNotEmpty) {
            Get.to(() => TaskDetailScreen(activityId: activityId));
          } else {
            Get.toNamed(AppRoutes.main, arguments: {'tab': 1});
          }
          break;
        case 'fitness':
        case 'workout':
          Get.toNamed(AppRoutes.main, arguments: {'tab': 0});
          break;
        case 'notification':
        default:
          _navigateToNotifications();
          break;
      }
      return;
    }

    _navigateToNotifications();
  }

  void _navigateToNotifications() {
    Get.toNamed(AppRoutes.notifications);
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
    } catch (_) {}
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
    } catch (_) {}
  }
}
