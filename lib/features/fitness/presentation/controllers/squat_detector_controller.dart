import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/network/api_result.dart';
import '../../data/models/solo_challenge_model.dart';
import '../../data/models/squat_session_model.dart';
import '../../data/models/workout_model.dart';
import '../../data/repositories/fitness_workout_repository.dart';
import '../../domain/squat_angle_calculator.dart';
import '../../domain/squat_state_machine.dart';
import '../screens/squat_summary_screen.dart';

class SquatDetectorController extends GetxController {
  final SoloChallengeModel challenge;
  final FitnessWorkoutRepository _workoutRepo;
  int? remoteSessionId;

  SquatDetectorController({
    required this.challenge,
    FitnessWorkoutRepository? workoutRepo,
  }) : _workoutRepo = workoutRepo ?? FitnessWorkoutRepository();

  CameraController? cameraController;
  PoseDetector? _poseDetector;

  final isCameraInitialized = false.obs;
  final isProcessingFrame = false.obs;
  final hasPermission = false.obs;
  final permissionDenied = false.obs;
  final isSimulationMode = false.obs;

  final detectedPoses = <Pose>[].obs;
  final currentKneeAngle = 175.0.obs;
  final currentFeedback = 'Stand in full view of the camera'.obs;
  final currentState = SquatState.up.obs;
  final completedReps = 0.obs;
  final currentSet = 1.obs;
  final durationSeconds = 0.obs;
  final isPaused = false.obs;
  final isFinishing = false.obs;

  late final SquatStateMachine _stateMachine;
  late final SquatSession currentSession;
  Timer? _durationTimer;
  int _lastFrameProcessTimestamp = 0;
  List<CameraDescription> _availableCameras = [];
  int _selectedCameraIndex = 0;
  Future<ApiResult<FitnessWorkoutSessionModel>>? _startWorkoutFuture;

  @override
  void onInit() {
    super.onInit();
    currentSession = SquatSession(
      challengeId: challenge.id,
      challengeName: challenge.name.isNotEmpty ? challenge.name : 'Squats',
      targetReps: challenge.repsPerSet * challenge.sets,
      sets: challenge.sets,
      startTime: DateTime.now(),
    );

    _startWorkoutFuture = _workoutRepo.startWorkout(StartWorkoutRequest(
      workoutType: 'BODYWEIGHT',
      soloChallengeId: challenge.id > 0 ? challenge.id : null,
    ));
    _startWorkoutFuture!.then((res) {
      if (res.isSuccess && res.data != null) {
        remoteSessionId = res.data!.sessionId;
      }
    });

    _stateMachine = SquatStateMachine(
      upThreshold: 155.0,
      downThreshold: 95.0,
      onRepCompleted: (rep) {
        completedReps.value = _stateMachine.completedReps;
        currentSession.reps.add(rep);
        currentSession.totalReps = completedReps.value;

        if (completedReps.value % challenge.repsPerSet == 0 &&
            completedReps.value > 0) {
          _onSetCompleted();
        }
      },
      onStateChanged: (state, angle, feedback) {
        currentState.value = state;
        currentKneeAngle.value = angle;
        currentFeedback.value = feedback;
      },
    );

    _initPoseDetector();
    _initCamera();
    _startTimer();
  }

  void _startTimer() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused.value) {
        durationSeconds.value++;
      }
    });
  }

  void _initPoseDetector() {
    final options = PoseDetectorOptions(
      mode: PoseDetectionMode.stream,
      model: PoseDetectionModel.base,
    );
    _poseDetector = PoseDetector(options: options);
  }

  Future<void> _initCamera() async {
    try {
      final status = await Permission.camera.request();
      if (status.isGranted) {
        hasPermission.value = true;
        _availableCameras = await availableCameras();

        if (_availableCameras.isEmpty) {
          _enableSimulationMode('No cameras detected on device');
          return;
        }

        _selectedCameraIndex = _availableCameras.indexWhere(
          (c) => c.lensDirection == CameraLensDirection.front,
        );
        if (_selectedCameraIndex == -1) _selectedCameraIndex = 0;

        await _startCameraStream(_availableCameras[_selectedCameraIndex]);
      } else {
        hasPermission.value = false;
        permissionDenied.value = true;
        _enableSimulationMode('Camera permission not granted');
      }
    } catch (_) {
      _enableSimulationMode('Adjust positioning for camera tracking');
    }
  }

  Future<void> _startCameraStream(CameraDescription camera) async {
    try {
      final ctrl = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      cameraController = ctrl;
      await ctrl.initialize();

      if (!ctrl.value.isInitialized) {
        _enableSimulationMode('Camera failed to initialize');
        return;
      }

      isCameraInitialized.value = true;
      await ctrl.startImageStream((image) => _processCameraImage(image, camera));
    } catch (_) {
      _enableSimulationMode('Camera stream error');
    }
  }

  void _enableSimulationMode(String reason) {
    isSimulationMode.value = true;
    isCameraInitialized.value = false;
    currentFeedback.value = 'Tap anywhere to count reps (Simulation Mode)';
  }

  void simulateRep() {
    _stateMachine.processAngle(170.0);
    Future.delayed(const Duration(milliseconds: 300), () {
      _stateMachine.processAngle(85.0);
      Future.delayed(const Duration(milliseconds: 350), () {
        _stateMachine.processAngle(165.0);
      });
    });
  }

  Future<void> switchCamera() async {
    if (_availableCameras.length < 2) return;

    _selectedCameraIndex = (_selectedCameraIndex + 1) % _availableCameras.length;
    isCameraInitialized.value = false;

    if (cameraController != null) {
      await cameraController?.stopImageStream();
      await cameraController?.dispose();
      cameraController = null;
    }

    await _startCameraStream(_availableCameras[_selectedCameraIndex]);
  }

  void _processCameraImage(CameraImage image, CameraDescription camera) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (isProcessingFrame.value || now - _lastFrameProcessTimestamp < 65) {
      return;
    }

    isProcessingFrame.value = true;
    _lastFrameProcessTimestamp = now;

    try {
      final inputImage = _inputImageFromCameraImage(image, camera);
      if (inputImage == null) {
        isProcessingFrame.value = false;
        return;
      }

      final poses = await _poseDetector?.processImage(inputImage) ?? [];
      detectedPoses.value = poses;

      if (poses.isNotEmpty) {
        final pose = poses.first;

        final leftHip = pose.landmarks[PoseLandmarkType.leftHip];
        final leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
        final leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];

        final leftAngle = SquatAngleCalculator.calculateKneeAngle(
          hip: leftHip,
          knee: leftKnee,
          ankle: leftAnkle,
        );

        final rightHip = pose.landmarks[PoseLandmarkType.rightHip];
        final rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
        final rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];

        final rightAngle = SquatAngleCalculator.calculateKneeAngle(
          hip: rightHip,
          knee: rightKnee,
          ankle: rightAnkle,
        );

        double? activeAngle;
        double confidence = 1.0;

        if (leftAngle != null && rightAngle != null) {
          final leftConf = (leftHip!.likelihood +
                  leftKnee!.likelihood +
                  leftAnkle!.likelihood) /
              3.0;
          final rightConf = (rightHip!.likelihood +
                  rightKnee!.likelihood +
                  rightAnkle!.likelihood) /
              3.0;

          if (leftConf >= rightConf) {
            activeAngle = leftAngle;
            confidence = leftConf;
          } else {
            activeAngle = rightAngle;
            confidence = rightConf;
          }
        } else if (leftAngle != null) {
          activeAngle = leftAngle;
        } else if (rightAngle != null) {
          activeAngle = rightAngle;
        }

        if (activeAngle != null) {
          _stateMachine.processAngle(activeAngle, confidence: confidence);
        } else {
          currentFeedback.value = 'Step back so legs are visible';
        }
      } else {
        currentFeedback.value = 'No person detected in frame';
      }
    } catch (_) {
      currentFeedback.value = 'Adjust positioning for camera tracking';
    } finally {
      isProcessingFrame.value = false;
    }
  }

  InputImage? _inputImageFromCameraImage(
    CameraImage image,
    CameraDescription camera,
  ) {
    try {
      final orientations = {
        DeviceOrientation.portraitUp: 0,
        DeviceOrientation.landscapeLeft: 90,
        DeviceOrientation.portraitDown: 180,
        DeviceOrientation.landscapeRight: 270,
      };

      final sensorOrientation = camera.sensorOrientation;
      InputImageRotation? rotation;

      if (Platform.isIOS) {
        rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
      } else if (Platform.isAndroid) {
        var rotationCompensation =
            orientations[cameraController!.value.deviceOrientation];
        if (rotationCompensation == null) return null;
        if (camera.lensDirection == CameraLensDirection.front) {
          rotationCompensation =
              (sensorOrientation + rotationCompensation) % 360;
        } else {
          rotationCompensation =
              (sensorOrientation - rotationCompensation + 360) % 360;
        }
        rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
      }

      if (rotation == null) return null;

      final format = InputImageFormatValue.fromRawValue(image.format.raw);
      if (format == null) return null;

      if (image.planes.length == 1) {
        return InputImage.fromBytes(
          bytes: image.planes[0].bytes,
          metadata: InputImageMetadata(
            size: Size(image.width.toDouble(), image.height.toDouble()),
            rotation: rotation,
            format: format,
            bytesPerRow: image.planes[0].bytesPerRow,
          ),
        );
      }

      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      return InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );
    } catch (_) {
      return null;
    }
  }

  void _onSetCompleted() {
    if (currentSet.value < challenge.sets) {
      currentSet.value++;
      currentFeedback.value = 'Set ${currentSet.value - 1} Complete! Take a quick rest.';
    } else {
      currentSession.isCompleted = true;
      currentFeedback.value = 'Challenge Complete! 🏆';
    }
  }

  void togglePause() {
    isPaused.value = !isPaused.value;
    if (isPaused.value) {
      currentFeedback.value = 'Workout Paused';
    } else {
      currentFeedback.value = 'Resuming... Let\'s squat!';
    }
  }

  void finishWorkout() async {
    if (isFinishing.value) return;
    isFinishing.value = true;
    _durationTimer?.cancel();
    currentSession.endTime = DateTime.now();

    if (cameraController != null && cameraController!.value.isStreamingImages) {
      await cameraController?.stopImageStream();
    }

    FitnessWorkoutSummaryModel? summaryModel;

    if (_startWorkoutFuture != null) {
      await _startWorkoutFuture;
    }

    if (remoteSessionId != null) {
      try {
        final finishRes = await _workoutRepo.finishWorkout(
          remoteSessionId!,
          FinishWorkoutRequest(
            durationSeconds: durationSeconds.value,
            steps: completedReps.value,
            distance: 0.0,
          ),
        );
        if (finishRes.isSuccess && finishRes.data != null) {
          summaryModel = finishRes.data!.toSummaryModel();
        }
      } catch (_) {}
    }

    Get.off(() => SquatSummaryScreen(
          session: currentSession,
          challenge: challenge,
          summary: summaryModel,
        ));
  }

  @override
  void onClose() {
    _durationTimer?.cancel();
    cameraController?.stopImageStream();
    cameraController?.dispose();
    _poseDetector?.close();
    super.onClose();
  }
}
