import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/models/run_session.dart';
import '../../data/models/track_point.dart';
import '../../data/models/workout_model.dart';
import '../../data/models/solo_challenge_model.dart';
import '../../data/local/run_session_repository.dart';
import '../../data/repositories/fitness_workout_repository.dart';
import '../../domain/gps_filter.dart';
import '../../domain/pace_calculator.dart';

class TrackingController extends GetxController {
  final SoloChallengeModel? challenge;

  final RunSessionRepository _repository;
  final FitnessWorkoutRepository _workoutRepo;

  TrackingController({
    this.challenge,
    RunSessionRepository? repository,
    FitnessWorkoutRepository? workoutRepo,
  })  : _repository = repository ?? RunSessionRepository(),
        _workoutRepo = workoutRepo ?? FitnessWorkoutRepository();

  final session = RunSession().obs;
  final currentPace = 0.0.obs;
  final route = <LatLng>[].obs;
  final autoFollow = true.obs;
  final initialPosition = Rxn<LatLng>();
  int? remoteSessionId;
  Future<void>? _startWorkoutFuture;

  final countdown = 5.obs;
  final isCountingDown = true.obs;
  Timer? _countdownTimer;

  StreamSubscription<Position>? _positionStream;
  Timer? _durationTimer;
  TrackPoint? _lastAccepted;

  int get steps => (session.value.totalDistanceMeters * 1.3).toInt();
  int get calories => ((session.value.totalDistanceMeters / 1000.0) * 60).toInt();

  String get formattedDuration {
    final secs = session.value.elapsedDurationMilliseconds ~/ 1000;
    if (secs == 0 && session.value.status == RunStatus.idle) {
      return '0';
    }
    final m = (secs ~/ 60).toString().padLeft(2, '0');
    final s = (secs % 60).toString().padLeft(2, '0');
    if (secs >= 3600) {
      final h = (secs ~/ 3600).toString().padLeft(2, '0');
      return '$h:$m:$s';
    }
    return '$m:$s';
  }

  @override
  void onInit() {
    super.onInit();
    _repository.init();
    _fetchInitialLocation();
    startCountdown();
  }

  Future<void> _fetchInitialLocation() async {
    try {
      final hasPermission = await _requestPermissions();
      if (!hasPermission) return;

      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null && initialPosition.value == null) {
        initialPosition.value = LatLng(lastKnown.latitude, lastKnown.longitude);
      }

      final current = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 4),
        ),
      );
      initialPosition.value = LatLng(current.latitude, current.longitude);
    } catch (_) {
      // Ignore timeout or location errors, fallback gracefully
    }
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    _positionStream?.cancel();
    _durationTimer?.cancel();
    super.onClose();
  }

  void startCountdown() {
    countdown.value = 5;
    isCountingDown.value = true;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 1) {
        countdown.value--;
      } else {
        _countdownTimer?.cancel();
        isCountingDown.value = false;
        startRun();
      }
    });
  }

  void skipCountdown() {
    _countdownTimer?.cancel();
    isCountingDown.value = false;
    startRun();
  }

  Future<bool> _requestPermissions() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      return true;
    }
    status = await Permission.location.request();
    return status.isGranted;
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

    _startWorkoutFuture = _workoutRepo.startWorkout(StartWorkoutRequest(
      workoutType: 'RUNNING',
      soloChallengeId: challenge != null && challenge!.id > 0 ? challenge!.id : null,
    )).then((res) {
      if (res.isSuccess && res.data != null) {
        remoteSessionId = res.data!.sessionId;
      }
    });

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

  Future<FitnessWorkoutSummaryModel?> finishRun() async {
    _positionStream?.cancel();
    _durationTimer?.cancel();

    session.update((val) {
      val?.status = RunStatus.finished;
      val?.endedAt = DateTime.now();
    });

    FitnessWorkoutSummaryModel? summaryModel;

    if (_startWorkoutFuture != null) {
      await _startWorkoutFuture;
    }

    if (remoteSessionId != null) {
      // 1. Submit GPS route points
      if (session.value.points.isNotEmpty) {
        try {
          final points = <RoutePointRequest>[];
          for (int i = 0; i < session.value.points.length; i++) {
            final pt = session.value.points[i];
            points.add(RoutePointRequest(
              pointSequence: i + 1,
              latitude: pt.latitude,
              longitude: pt.longitude,
              accuracy: pt.accuracy,
              altitude: pt.altitude,
              recordedAt: pt.timestamp,
            ));
          }
          await _workoutRepo.addRoutePoints(
            remoteSessionId!,
            WorkoutRoutePointsRequest(points: points),
          );
        } catch (_) {}
      } else if (route.isNotEmpty) {
        try {
          final points = <RoutePointRequest>[];
          for (int i = 0; i < route.length; i++) {
            points.add(RoutePointRequest(
              pointSequence: i + 1,
              latitude: route[i].latitude,
              longitude: route[i].longitude,
              recordedAt: DateTime.now(),
            ));
          }
          await _workoutRepo.addRoutePoints(
            remoteSessionId!,
            WorkoutRoutePointsRequest(points: points),
          );
        } catch (_) {}
      }

      // 2. Finish workout session
      try {
        final finishRes = await _workoutRepo.finishWorkout(
          remoteSessionId!,
          FinishWorkoutRequest(
            durationSeconds: session.value.elapsedDuration.inSeconds,
            steps: steps,
            distance: session.value.totalDistanceMeters / 1000.0,
          ),
        );
        if (finishRes.isSuccess && finishRes.data != null) {
          summaryModel = finishRes.data!.toSummaryModel();
        }
      } catch (_) {}
    }

    await saveRun();
    return summaryModel;
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
    final LocationSettings locationSettings = defaultTargetPlatform == TargetPlatform.android
        ? AndroidSettings(
            accuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 1,
            forceLocationManager: false,
            intervalDuration: const Duration(seconds: 1),
          )
        : const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 1,
          );

    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      if (session.value.status != RunStatus.running) {
        return;
      }

      final isValid = GpsFilter.isValid(position, _lastAccepted);
      if (!isValid) {
        return;
      }

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
      initialPosition.value ??= LatLng(trackPoint.latitude, trackPoint.longitude);

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
