import 'package:geolocator/geolocator.dart';
import '../data/models/track_point.dart';

class GpsFilter {
  static const double maxAcceptableAccuracy = 45.0;
  static const double minMovementDistance = 2.0;
  static const double maxPlausibleSpeed = 8.0;

  static bool isValid(Position candidate, TrackPoint? lastAccepted) {
    if (candidate.accuracy > maxAcceptableAccuracy) return false;

    if (lastAccepted == null) return true;

    final distance = Geolocator.distanceBetween(
      lastAccepted.latitude, lastAccepted.longitude,
      candidate.latitude, candidate.longitude,
    );

    if (distance < minMovementDistance) return false;

    var seconds = candidate.timestamp
        .difference(lastAccepted.timestamp).inMilliseconds / 1000.0;
    // Some devices repeat the same GPS timestamp. Dropping those fixes
    // freezes steps, distance, and pace after the first few samples.
    if (seconds <= 0) seconds = 1.0;

    final impliedSpeed = distance / seconds;
    if (impliedSpeed > maxPlausibleSpeed) return false;

    return true;
  }
}
