import 'package:isar/isar.dart';

part 'track_point.g.dart';

@embedded
class TrackPoint {
  double latitude = 0.0;
  double longitude = 0.0;
  double accuracy = 0.0; // meters
  double? altitude;
  double? speed; // m/s, from GPS directly
  DateTime timestamp = DateTime.now();
}
