import 'package:isar/isar.dart';

part 'track_point.g.dart';

@embedded
class TrackPoint {
  double latitude = 0.0;
  double longitude = 0.0;
  double accuracy = 0.0;
  double? altitude;
  double? speed;
  DateTime timestamp = DateTime.now();
}
