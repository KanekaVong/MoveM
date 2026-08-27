import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import '../models/run_session.dart';
import '../models/track_point.dart';

class RunSessionRepository {
  late Isar _isar;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    if (Isar.instanceNames.isNotEmpty) {
      _isar = Isar.getInstance()!;
      _isInitialized = true;
      return;
    }

    try {
      final dir = await getApplicationDocumentsDirectory();

      _isar = await Isar.open(
        [RunSessionSchema],
        directory: dir.path,
      );
      _isInitialized = true;
    } catch (e) {

      _isar = Isar.getInstance()!;
      _isInitialized = true;
    }
  }

  Future<void> saveRunSession(RunSession session) async {
    await init();
    await _isar.writeTxn(() async {
      await _isar.runSessions.put(session);
    });
  }

  Future<List<RunSession>> getAllSessions() async {
    await init();
    return await _isar.runSessions.where().findAll();
  }

  Future<RunSession?> getSession(int id) async {
    await init();
    return await _isar.runSessions.get(id);
  }

  Future<void> deleteSession(int id) async {
    await init();
    await _isar.writeTxn(() async {
      await _isar.runSessions.delete(id);
    });
  }
}
