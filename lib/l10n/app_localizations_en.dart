// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MoveM';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get home => 'Home';

  @override
  String get task => 'Task';

  @override
  String get fitness => 'Fitness';

  @override
  String get trip => 'Trip';

  @override
  String get settings => 'Settings';

  @override
  String get welcome => 'Welcome!';

  @override
  String welcomeUser(String name) {
    return 'Welcome, $name!';
  }
}
