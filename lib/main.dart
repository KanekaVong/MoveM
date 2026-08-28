import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:movem/core/utils/Constants.dart';
import 'l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/storage/local_storage.dart';
import 'core/storage/user_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await LocalStorage().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      title: Constants.appName,
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
