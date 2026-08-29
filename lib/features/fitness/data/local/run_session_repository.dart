import 'package:isar/isar.dart';
import '../../../../core/storage/app_database.dart';
import '../models/run_session.dart';

class RunSessionRepository {
  Future<Isar> get _isar async => await AppDatabase().isar;

  Future<void> init() async {
    await AppDatabase().init();
  }

  Future<void> saveRunSession(RunSession session) async {
    final db = await _isar;
    await db.writeTxn(() async {
      await db.runSessions.put(session);
    });
  }

  Future<List<RunSession>> getAllSessions() async {
    final db = await _isar;
    return await db.runSessions.where().findAll();
  }

  Future<RunSession?> getSession(int id) async {
    final db = await _isar;
    return await db.runSessions.get(id);
  }

  Future<void> deleteSession(int id) async {
    final db = await _isar;
    await db.writeTxn(() async {
      await db.runSessions.delete(id);
    });
  }
}
