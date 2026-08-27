import 'dart:async';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/models/run_session.dart';
import '../../data/models/track_point.dart';
import '../../data/local/run_session_repository.dart';
import '../../domain/gps_filter.dart';
import '../../domain/pace_calculator.dart';

class TrackingController extends GetxController {
  final RunSessionRepository _repository = RunSessionRepository();

  final session = RunSession().obs;
  final currentPace = 0.0.obs;
  final route = <LatLng>[].obs;
  final autoFollow = true.obs;

  StreamSubscription<Position>? _positionStream;
  Timer? _durationTimer;
  TrackPoint? _lastAccepted;

  @override
  void onInit() {
    super.onInit();
    _repository.init();
  }

  @override
  void onClose() {
    _positionStream?.cancel();
    _durationTimer?.cancel();
    super.onClose();
  }

  Future<bool> _requestPermissions() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      return true;
    }
    return false;
  }

  Future<void> startRun() async {
    final hasPermission = await _requestPermissions();
    if (!hasPermission) {
      Get.snackbar('Permission Denied', 'Location permission is required.');
      return;
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Service Disabled', 'Please enable location services.');
      return;
    }

    final newSession = RunSession()
      ..sessionId = DateTime.now().millisecondsSinceEpoch.toString()
      ..startedAt = DateTime.now()
      ..status = RunStatus.running;

    session.value = newSession;
    _lastAccepted = null;
    route.clear();

    _startTracking();
    _startTimer();
  }

  void pauseRun() {
    session.update((val) {
      val?.status = RunStatus.paused;
    });
    _positionStream?.cancel();
    _durationTimer?.cancel();
  }

  void resumeRun() {
    session.update((val) {
      val?.status = RunStatus.running;
    });
    _lastAccepted = null;
    _startTracking();
    _startTimer();
  }

  Future<void> finishRun() async {
    _positionStream?.cancel();
    _durationTimer?.cancel();

    session.update((val) {
      val?.status = RunStatus.finished;
      val?.endedAt = DateTime.now();
    });

  }

  Future<void> saveRun() async {
    await _repository.saveRunSession(session.value);
  }

  void setAutoFollow(bool value) {
    autoFollow.value = value;
  }

  void _startTimer() {
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (session.value.status == RunStatus.running) {
        session.update((val) {
          if (val != null) {
            val.elapsedDurationMilliseconds += 1000;
          }
        });
      }
    });
  }

  void _startTracking() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 3,
    );

    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {

      if (session.value.status != RunStatus.running) return;

      final isValid = GpsFilter.isValid(position, _lastAccepted);
      if (!isValid) return;

      final trackPoint = TrackPoint()
        ..latitude = position.latitude
        ..longitude = position.longitude
        ..accuracy = position.accuracy
        ..altitude = position.altitude
        ..speed = position.speed
        ..timestamp = position.timestamp;

      double addedDistance = 0.0;
      if (_lastAccepted != null) {
        addedDistance = Geolocator.distanceBetween(
          _lastAccepted!.latitude,
          _lastAccepted!.longitude,
          trackPoint.latitude,
          trackPoint.longitude,
        );
      }

      session.update((val) {
        if (val != null) {
          val.points.add(trackPoint);
          val.totalDistanceMeters += addedDistance;
        }
      });

      _lastAccepted = trackPoint;

      _updateSmoothedRoute(session.value.points);

      _updateCurrentPace(session.value.points);
    });
  }

  void _updateSmoothedRoute(List<TrackPoint> points, {int window = 4}) {
    if (points.length < window) {
      route.value = points.map((p) => LatLng(p.latitude, p.longitude)).toList();
      return;
    }

    final result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      final start = (i - window + 1).clamp(0, points.length);
      final slice = points.sublist(start, i + 1);
      final avgLat = slice.map((p) => p.latitude).reduce((a, b) => a + b) / slice.length;
      final avgLng = slice.map((p) => p.longitude).reduce((a, b) => a + b) / slice.length;
      result.add(LatLng(avgLat, avgLng));
    }
    route.value = result;
  }

  void _updateCurrentPace(List<TrackPoint> points) {
    if (points.length < 2) {
      currentPace.value = 0.0;
      return;
    }

    final now = DateTime.now();
    final recentPoints = points.where((p) => now.difference(p.timestamp).inSeconds <= 30).toList();

    if (recentPoints.length < 2) return;

    double recentDistance = 0.0;
    for (int i = 1; i < recentPoints.length; i++) {
      recentDistance += Geolocator.distanceBetween(
        recentPoints[i - 1].latitude, recentPoints[i - 1].longitude,
        recentPoints[i].latitude, recentPoints[i].longitude,
      );
    }

    final recentDuration = recentPoints.last.timestamp.difference(recentPoints.first.timestamp);
    currentPace.value = PaceCalculator.paceMinPerKm(recentDistance, recentDuration);
  }
}
