import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/storage/local_storage.dart';
import 'core/storage/user_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await LocalStorage().init();

  final savedLocale = Locale(UserManager().languageCode);
  
  runApp(MyApp(savedLocale: savedLocale));
}

class MyApp extends StatelessWidget {
  final Locale savedLocale;

  const MyApp({super.key, required this.savedLocale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MoveM App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      locale: savedLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: AppRoutes.login,
      getPages: AppPages.pages,
    );
  }
}
