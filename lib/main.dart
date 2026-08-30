import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'core/config/app_config.dart';
import 'core/config/app_environment.dart';
import 'core/services/fcm_service.dart';
import 'core/services/notification_scheduler_service.dart';
import 'core/storage/app_database.dart';
import 'core/utils/Constants.dart';
import 'l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/storage/local_storage.dart';
import 'core/storage/user_manager.dart';

void main() async {
  await mainCommon(environment: Environment.dev);
}

Future<void> mainCommon({required Environment environment}) async {
  WidgetsFlutterBinding.ensureInitialized();
  AppEnvironment.setEnvironment(environment);

  await LocalStorage().init();

  try {
    await AppDatabase().init();
  } catch (e) {
    if (AppConfig.enableDetailedLogging) {
      debugPrint('⚠️ Error initializing AppDatabase: $e');
    }
  }

  try {
    await NotificationSchedulerService().initialize();
    await NotificationSchedulerService().rescheduleAllPendingReminders();
  } catch (e) {
    if (AppConfig.enableDetailedLogging) {
      debugPrint('⚠️ Error initializing NotificationSchedulerService: $e');
    }
  }

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await FcmService().initialize();
  } catch (e) {
    if (AppConfig.enableDetailedLogging) {
      debugPrint('⚠️ Error initializing Firebase: $e');
    }
  }

  final savedLocale = Locale(UserManager().languageCode);
  final savedTheme = UserManager().themeMode;

  ThemeMode initialThemeMode;
  if (savedTheme == Constants.lightMode) {
    initialThemeMode = ThemeMode.light;
  } else if (savedTheme == Constants.darkMode) {
    initialThemeMode = ThemeMode.dark;
  } else {
    initialThemeMode = ThemeMode.system;
  }

  runApp(MyApp(savedLocale: savedLocale, savedThemeMode: initialThemeMode));
}

class MyApp extends StatelessWidget {
  final Locale savedLocale;
  final ThemeMode savedThemeMode;

  const MyApp({super.key, required this.savedLocale, required this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConfig.appTitle,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 200),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: savedThemeMode,
      locale: savedLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: UserManager().isLoggedIn ? AppRoutes.main : AppRoutes.login,
      getPages: AppPages.pages,
    );
  }
}
