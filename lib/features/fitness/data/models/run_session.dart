import 'package:isar/isar.dart';
import 'track_point.dart';

part 'run_session.g.dart';

enum RunStatus {
  idle,
  running,
  paused,
  finished
}

@collection
class RunSession {
  Id id = Isar.autoIncrement;

  String sessionId = '';

  DateTime startedAt = DateTime.now();

  DateTime? endedAt;

  List<TrackPoint> points = [];

  double totalDistanceMeters = 0.0;

  int elapsedDurationMilliseconds = 0;

  @enumerated
  RunStatus status = RunStatus.idle;

  @ignore
  Duration get elapsedDuration => Duration(milliseconds: elapsedDurationMilliseconds);

  set elapsedDuration(Duration value) {
    elapsedDurationMilliseconds = value.inMilliseconds;
  }
}
