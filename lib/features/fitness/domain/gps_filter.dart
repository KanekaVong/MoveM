import 'package:geolocator/geolocator.dart';
import '../data/models/track_point.dart';

class GpsFilter {
  static const double maxAcceptableAccuracy = 15.0;
  static const double minMovementDistance = 3.0;
  static const double maxPlausibleSpeed = 8.0;

  static bool isValid(Position candidate, TrackPoint? lastAccepted) {

    if (candidate.accuracy > maxAcceptableAccuracy) return false;

    if (lastAccepted == null) return true;

    final distance = Geolocator.distanceBetween(
      lastAccepted.latitude, lastAccepted.longitude,
      candidate.latitude, candidate.longitude,
    );

    if (distance < minMovementDistance) return false;

    final seconds = candidate.timestamp
        .difference(lastAccepted.timestamp).inMilliseconds / 1000.0;
    if (seconds <= 0) return false;

    final impliedSpeed = distance / seconds;
    if (impliedSpeed > maxPlausibleSpeed) return false;

    return true;
  }
}
