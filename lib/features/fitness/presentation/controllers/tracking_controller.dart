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
import '../../../../l10n/app_localizations.dart';

class TrackingController extends GetxController {
  static const double _startFixMaxAccuracyMeters = 50.0;
  static const Duration _gpsTimeout = Duration(seconds: 20);

  AppLocalizations? get _l10n {
    final ctx = Get.context;
    return ctx == null ? null : AppLocalizations.of(ctx);
  }

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
  final isCountingDown = false.obs;
  final isAcquiringGps = true.obs;
  final gpsFailed = false.obs;
  Timer? _countdownTimer;

  StreamSubscription<Position>? _positionStream;
  StreamSubscription<Position>? _lockStream;
  Timer? _durationTimer;
  Timer? _gpsTimeoutTimer;
  TrackPoint? _lastAccepted;
  Position? _startFix;
  bool _runStarted = false;

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
    _acquireGpsLock();
  }

  Future<void> _acquireGpsLock() async {
    isAcquiringGps.value = true;
    gpsFailed.value = false;
    isCountingDown.value = false;
    _startFix = null;
    _countdownTimer?.cancel();
    _gpsTimeoutTimer?.cancel();
    await _lockStream?.cancel();
    _lockStream = null;

    final hasPermission = await _requestPermissions();
    if (!hasPermission) {
      isAcquiringGps.value = false;
      gpsFailed.value = true;
      Get.snackbar(
        _l10n?.permissionDeniedTitle ?? 'Permission Denied',
        _l10n?.locationRequired ?? 'Location permission is required.',
      );
      return;
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      isAcquiringGps.value = false;
      gpsFailed.value = true;
      Get.snackbar(
        _l10n?.serviceDisabledTitle ?? 'Service Disabled',
        _l10n?.enableLocation ?? 'Please enable location services.',
      );
      return;
    }

    try {
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null && initialPosition.value == null) {
        initialPosition.value = LatLng(lastKnown.latitude, lastKnown.longitude);
      }
    } catch (_) {}

    _gpsTimeoutTimer = Timer(_gpsTimeout, () {
      if (_startFix != null || _runStarted) return;
      _lockStream?.cancel();
      _lockStream = null;
      isAcquiringGps.value = false;
      gpsFailed.value = true;
      Get.snackbar(
        _l10n?.errorTitle ?? 'GPS',
        'Could not get your current location. Move outdoors and try again.',
      );
    });

    try {
      final current = await Geolocator.getCurrentPosition(
        locationSettings: _lockLocationSettings(timeLimit: const Duration(seconds: 8)),
      );
      if (_acceptStartFix(current)) {
        return;
      }
    } catch (_) {}

    if (_startFix != null || _runStarted) return;

    _lockStream = Geolocator.getPositionStream(
      locationSettings: _trackingLocationSettings(),
    ).listen((position) {
      _acceptStartFix(position);
    });
  }

  LocationSettings _lockLocationSettings({Duration? timeLimit}) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidSettings(
        accuracy: LocationAccuracy.best,
        timeLimit: timeLimit,
      );
    }
    return LocationSettings(
      accuracy: LocationAccuracy.best,
      timeLimit: timeLimit,
    );
  }

  LocationSettings _trackingLocationSettings() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 1,
        forceLocationManager: false,
        intervalDuration: const Duration(seconds: 1),
      );
    }
    return const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 1,
    );
  }

  bool _acceptStartFix(Position position) {
    if (_startFix != null || _runStarted) return true;
    if (position.accuracy > _startFixMaxAccuracyMeters) {
      initialPosition.value = LatLng(position.latitude, position.longitude);
      return false;
    }

    _startFix = position;
    initialPosition.value = LatLng(position.latitude, position.longitude);
    _gpsTimeoutTimer?.cancel();
    _lockStream?.cancel();
    _lockStream = null;
    isAcquiringGps.value = false;
    gpsFailed.value = false;
    startCountdown();
    return true;
  }

  Future<void> retryGpsLock() => _acquireGpsLock();

  @override
  void onClose() {
    _countdownTimer?.cancel();
    _gpsTimeoutTimer?.cancel();
    _lockStream?.cancel();
    _positionStream?.cancel();
    _durationTimer?.cancel();
    super.onClose();
  }

  void startCountdown() {
    if (_startFix == null) return;
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
    if (_startFix == null) return;
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
    if (_runStarted) return;
    if (_startFix == null) {
      await _acquireGpsLock();
      return;
    }

    final hasPermission = await _requestPermissions();
    if (!hasPermission) {
      Get.snackbar(
        _l10n?.permissionDeniedTitle ?? 'Permission Denied',
        _l10n?.locationRequired ?? 'Location permission is required.',
      );
      return;
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        _l10n?.serviceDisabledTitle ?? 'Service Disabled',
        _l10n?.enableLocation ?? 'Please enable location services.',
      );
      return;
    }

    _runStarted = true;
    final startFix = _startFix!;
    final startPoint = _trackPointFrom(startFix);

    final newSession = RunSession()
      ..sessionId = DateTime.now().millisecondsSinceEpoch.toString()
      ..startedAt = DateTime.now()
      ..status = RunStatus.running
      ..points.add(startPoint);

    session.value = newSession;
    _lastAccepted = startPoint;
    route.assignAll([LatLng(startPoint.latitude, startPoint.longitude)]);
    initialPosition.value = LatLng(startPoint.latitude, startPoint.longitude);

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

  TrackPoint _trackPointFrom(Position position) {
    return TrackPoint()
      ..latitude = position.latitude
      ..longitude = position.longitude
      ..accuracy = position.accuracy
      ..altitude = position.altitude
      ..speed = position.speed
      ..timestamp = position.timestamp;
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
    _positionStream?.cancel();
    _positionStream = Geolocator.getPositionStream(
      locationSettings: _trackingLocationSettings(),
    ).listen((Position position) {
      if (session.value.status != RunStatus.running) {
        return;
      }

      final isValid = GpsFilter.isValid(position, _lastAccepted);
      if (!isValid) {
        return;
      }

      final trackPoint = _trackPointFrom(position);

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
