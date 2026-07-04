// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Khmer Central Khmer (`km`).
class AppLocalizationsKm extends AppLocalizations {
  AppLocalizationsKm([String locale = 'km']) : super(locale);

  @override
  String get appTitle => 'MoveM';

  @override
  String get login => 'ចូល';

  @override
  String get logout => 'ចាកចេញ';

  @override
  String get email => 'អ៊ីមែល';

  @override
  String get password => 'ពាក្យសម្ងាត់';

  @override
  String get home => 'ទំព័រដើម';

  @override
  String get task => 'កិច្ចការ';

  @override
  String get fitness => 'សុខភាព';

  @override
  String get trip => 'ដំណើរកម្សាន្ត';

  @override
  String get settings => 'ការកំណត់';

  @override
  String get welcome => 'សូមស្វាគមន៍!';

  @override
  String welcomeUser(String name) {
    return 'សូមស្វាគមន៍, $name!';
  }

  @override
  String get helloYoulong => 'សួស្តី Youlong';

  @override
  String get test => 'ការសាកល្បង';
}
