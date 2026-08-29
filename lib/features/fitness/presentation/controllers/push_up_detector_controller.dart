import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/models/push_up_session_model.dart';
import '../../data/models/solo_challenge_model.dart';
import '../../domain/push_up_angle_calculator.dart';
import '../../domain/push_up_state_machine.dart';
import '../screens/push_up_summary_screen.dart';

class PushUpDetectorController extends GetxController {
  final SoloChallengeModel challenge;

  PushUpDetectorController({required this.challenge});

  CameraController? cameraController;
  PoseDetector? _poseDetector;

  final isCameraInitialized = false.obs;
  final isProcessingFrame = false.obs;
  final hasPermission = false.obs;
  final permissionDenied = false.obs;
  final isSimulationMode = false.obs;

  final detectedPoses = <Pose>[].obs;
  final currentElbowAngle = 175.0.obs;
  final currentFeedback = 'Get in push-up position'.obs;
  final currentState = PushUpState.up.obs;
  final completedReps = 0.obs;
  final currentSet = 1.obs;
  final durationSeconds = 0.obs;
  final isPaused = false.obs;

  late final PushUpStateMachine _stateMachine;
  late final PushUpSession currentSession;
  Timer? _durationTimer;
  int _lastFrameProcessTimestamp = 0;
  List<CameraDescription> _availableCameras = [];
  int _selectedCameraIndex = 0;

  @override
  void onInit() {
    super.onInit();
    currentSession = PushUpSession(
      challengeId: challenge.id,
      challengeName: challenge.name,
      targetReps: challenge.repsPerSet * challenge.sets,
      sets: challenge.sets,
      startTime: DateTime.now(),
    );

    _stateMachine = PushUpStateMachine(
      upThreshold: 155.0,
      downThreshold: 90.0,
      onRepCompleted: (rep) {
        completedReps.value = _stateMachine.completedReps;
        currentSession.reps.add(rep);
        currentSession.totalReps = completedReps.value;

        // Check set completion
        if (completedReps.value % challenge.repsPerSet == 0 &&
            completedReps.value > 0) {
          _onSetCompleted();
        }
      },
      onStateChanged: (state, angle, feedback) {
        currentState.value = state;
        currentElbowAngle.value = angle;
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

        // Prefer front camera
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
    } catch (e) {
      _enableSimulationMode('Camera initialization error: $e');
    }
  }

  Future<void> _startCameraStream(CameraDescription camera) async {
    try {
      cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      await cameraController!.initialize();
      isCameraInitialized.value = true;

      await cameraController!.startImageStream((image) {
        if (!isPaused.value) {
          _processCameraImage(image, camera);
        }
      });
    } catch (e) {
      _enableSimulationMode('Failed to stream camera: $e');
    }
  }

  void _enableSimulationMode(String reason) {
    if (kDebugMode) {
      print('Switching to Simulation Mode: $reason');
    }
    isSimulationMode.value = true;
    isCameraInitialized.value = true;
    currentFeedback.value = 'Simulation Mode Active • Tap screen to count rep';
  }

  Future<void> switchCamera() async {
    if (_availableCameras.length < 2 || isSimulationMode.value) return;

    _selectedCameraIndex = (_selectedCameraIndex + 1) % _availableCameras.length;
    isCameraInitialized.value = false;

    if (cameraController != null) {
      await cameraController!.stopImageStream();
      await cameraController!.dispose();
    }

    await _startCameraStream(_availableCameras[_selectedCameraIndex]);
  }

  void _processCameraImage(CameraImage image, CameraDescription camera) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    // Throttle ML frame processing to ~15 fps (every 65ms) to preserve UI performance
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

        // Calculate left arm angle
        final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
        final leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
        final leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];

        final leftAngle = PushUpAngleCalculator.calculateElbowAngle(
          shoulder: leftShoulder,
          elbow: leftElbow,
          wrist: leftWrist,
        );

        // Calculate right arm angle
        final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
        final rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];
        final rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];

        final rightAngle = PushUpAngleCalculator.calculateElbowAngle(
          shoulder: rightShoulder,
          elbow: rightElbow,
          wrist: rightWrist,
        );

        double? activeAngle;
        double confidence = 1.0;

        if (leftAngle != null && rightAngle != null) {
          final leftConf = (leftShoulder!.likelihood +
                  leftElbow!.likelihood +
                  leftWrist!.likelihood) /
              3.0;
          final rightConf = (rightShoulder!.likelihood +
                  rightElbow!.likelihood +
                  rightWrist!.likelihood) /
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
          currentFeedback.value = 'Position shoulders and arms in frame';
        }
      } else {
        currentFeedback.value = 'No person detected in frame';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error processing frame: $e');
      }
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
        var rotationCompensation = orientations[cameraController?.value.deviceOrientation];
        if (rotationCompensation == null) return null;
        if (camera.lensDirection == CameraLensDirection.front) {
          rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
        } else {
          rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
        }
        rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
      }
      rotation ??= InputImageRotation.rotation0deg;

      final format = InputImageFormatValue.fromRawValue(image.format.raw);
      if (format == null) return null;

      if (image.planes.isEmpty) return null;

      // Handle byte consolidation
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
    } catch (e) {
      return null;
    }
  }

  /// Manual rep trigger (for simulation or tap-to-count)
  void simulateRep() {
    if (isPaused.value) return;

    // Simulate down angle then up
    _stateMachine.processAngle(80.0, confidence: 1.0);
    _stateMachine.processAngle(165.0, confidence: 1.0);
  }

  void togglePause() {
    isPaused.value = !isPaused.value;
  }

  void resetCurrentSetReps() {
    _stateMachine.reset();
    completedReps.value = 0;
    currentElbowAngle.value = 175.0;
  }

  void _onSetCompleted() {
    if (currentSet.value < challenge.sets) {
      Get.dialog(
        AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF38BDF8), width: 1.5),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF38BDF8), size: 28),
              SizedBox(width: 10),
              Text(
                'Set Completed!',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            'Awesome form! You completed Set ${currentSet.value} of ${challenge.sets}. Ready for the next set?',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                currentSet.value++;
              },
              child: const Text(
                'Start Next Set',
                style: TextStyle(
                  color: Color(0xFF38BDF8),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } else {
      finishWorkout(completedNormally: true);
    }
  }

  void finishWorkout({bool completedNormally = false}) {
    _durationTimer?.cancel();
    currentSession.endTime = DateTime.now();
    currentSession.totalReps = completedReps.value;
    currentSession.isCompleted = completedNormally ||
        completedReps.value >= (challenge.repsPerSet * challenge.sets);

    Get.off(
      () => PushUpSummaryScreen(session: currentSession, challenge: challenge),
      transition: Transition.fadeIn,
    );
  }

  @override
  void onClose() {
    _durationTimer?.cancel();
    _poseDetector?.close();
    cameraController?.stopImageStream();
    cameraController?.dispose();
    super.onClose();
  }
}
