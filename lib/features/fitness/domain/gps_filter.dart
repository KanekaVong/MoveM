import 'package:geolocator/geolocator.dart';
import '../data/models/track_point.dart';

class GpsFilter {
  static const double maxAcceptableAccuracy = 15.0; // meters
  static const double minMovementDistance = 3.0;    // meters
  static const double maxPlausibleSpeed = 8.0;       // m/s (~28.8 km/h, faster than any runner)

  static bool isValid(Position candidate, TrackPoint? lastAccepted) {
    // 1. Reject low-accuracy fixes
    if (candidate.accuracy > maxAcceptableAccuracy) return false;

    if (lastAccepted == null) return true; // first point always accepted

    final distance = Geolocator.distanceBetween(
      lastAccepted.latitude, lastAccepted.longitude,
      candidate.latitude, candidate.longitude,
    );

    // 2. Reject sub-threshold "jitter" movement
    if (distance < minMovementDistance) return false;

    // 3. Reject implausible teleport/speed spikes
    final seconds = candidate.timestamp
        .difference(lastAccepted.timestamp).inMilliseconds / 1000.0;
    if (seconds <= 0) return false;
    
    final impliedSpeed = distance / seconds;
    if (impliedSpeed > maxPlausibleSpeed) return false;

    return true;
  }
}
