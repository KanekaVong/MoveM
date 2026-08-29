import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import '../../features/fitness/data/models/run_session.dart';
import '../../features/task/data/local/models/task_reminder_local.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();

  Isar? _isar;

  Future<Isar> get isar async {
    if (_isar != null && _isar!.isOpen) {
      return _isar!;
    }
    _isar = await init();
    return _isar!;
  }

  Future<Isar> init() async {
    if (_isar != null && _isar!.isOpen) {
      return _isar!;
    }

    if (Isar.instanceNames.isNotEmpty) {
      _isar = Isar.getInstance()!;
      return _isar!;
    }

    try {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [
          RunSessionSchema,
          TaskReminderLocalSchema,
        ],
        directory: dir.path,
      );
      return _isar!;
    } catch (_) {
      if (Isar.instanceNames.isNotEmpty) {
        _isar = Isar.getInstance()!;
        return _isar!;
      }
      rethrow;
    }
  }

  Future<void> cleanUp() async {
    if (_isar != null && _isar!.isOpen) {
      await _isar!.close();
      _isar = null;
    }
  }
}
