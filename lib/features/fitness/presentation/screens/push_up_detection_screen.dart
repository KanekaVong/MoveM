import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../../../../core/utils/app_images.dart';
import '../../data/models/solo_challenge_model.dart';
import '../controllers/push_up_detector_controller.dart';
import '../widgets/camera_pose_painter.dart';

class PushUpDetectionScreen extends StatelessWidget {
  final SoloChallengeModel challenge;

  const PushUpDetectionScreen({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PushUpDetectorController(challenge: challenge));
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (controller.isSimulationMode.value) {
              controller.simulateRep();
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Camera Preview or Fallback Scenic Simulation
              if (controller.isCameraInitialized.value &&
                  !controller.isSimulationMode.value &&
                  controller.cameraController != null)
                Positioned.fill(
                  child: AspectRatio(
                    aspectRatio: controller.cameraController!.value.aspectRatio,
                    child: CameraPreview(controller.cameraController!),
                  ),
                )
              else
                Positioned.fill(
                  child: Image.asset(
                    AppImages.pushupExerciseBg,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),

              // Live Skeleton Overlay
              if (controller.isCameraInitialized.value &&
                  !controller.isSimulationMode.value &&
                  controller.cameraController != null)
                Positioned.fill(
                  child: CustomPaint(
                    painter: CameraPosePainter(
                      poses: controller.detectedPoses,
                      imageSize: controller.cameraController!.value.previewSize ??
                          const Size(480, 640),
                      rotation: InputImageRotation.rotation0deg,
                      isFrontCamera: controller.cameraController!.description.lensDirection == CameraLensDirection.front,
                      currentAngle: controller.currentElbowAngle.value,
                    ),
                  ),
                ),

              // Top Bar
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back / Exit Button
                        GestureDetector(
                          onTap: () => _confirmExit(context, controller),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: 0.45),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                                width: 1.5,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),

                        // Center Reps Pill [ 7 REPS (↺) ]
                        Container(
                          height: 52,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF9EA3AE).withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.45),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${controller.completedReps.value}',
                                style: const TextStyle(
                                  color: Color(0xFF0A1E3F),
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'REPS',
                                style: TextStyle(
                                  color: Color(0xFF0A1E3F),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: controller.resetCurrentSetReps,
                                child: Container(
                                  width: 34,
                                  height: 34,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF0A1E3F),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.refresh_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Camera Flip / Mode Toggle Button
                        GestureDetector(
                          onTap: controller.switchCamera,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: 0.45),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                                width: 1.5,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.flip_camera_ios_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Live Form Coaching & Angle Badge
              Positioned(
                top: 96,
                left: 20,
                right: 20,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _getFeedbackColor(controller.currentElbowAngle.value),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _getFeedbackColor(controller.currentElbowAngle.value).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _getFeedbackColor(controller.currentElbowAngle.value),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${controller.currentElbowAngle.value.toInt()}°',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          controller.currentFeedback.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Frosted Stats Card [ SET 1/4 | DURATION mm:ss (||) | GOAL 15 ]
              Positioned(
                left: 20,
                right: 20,
                bottom: 34,
                child: SafeArea(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // SET Column
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'SET',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${controller.currentSet.value}/${challenge.sets}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Divider 1
                            Container(
                              width: 1,
                              height: 50,
                              color: Colors.white.withValues(alpha: 0.2),
                            ),

                            // DURATION Column with Pause & Stop Controls
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'DURATION',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _formatSeconds(controller.durationSeconds.value),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Pause / Play Button
                                      GestureDetector(
                                        onTap: controller.togglePause,
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white.withValues(alpha: 0.9),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              controller.isPaused.value
                                                  ? Icons.play_arrow_rounded
                                                  : Icons.pause_rounded,
                                              color: const Color(0xFF0A1E3F),
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Finish / Stop Workout Button
                                      GestureDetector(
                                        onTap: () => controller.finishWorkout(),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent.withValues(alpha: 0.85),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.stop, color: Colors.white, size: 16),
                                              SizedBox(width: 4),
                                              Text(
                                                'Stop',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Divider 2
                            Container(
                              width: 1,
                              height: 50,
                              color: Colors.white.withValues(alpha: 0.2),
                            ),

                            // GOAL Column
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'GOAL',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${challenge.repsPerSet}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Color _getFeedbackColor(double angle) {
    if (angle <= 90) return const Color(0xFF10B981);
    if (angle <= 120) return const Color(0xFFF59E0B);
    return const Color(0xFF38BDF8);
  }

  String _formatSeconds(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString();
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _confirmExit(BuildContext context, PushUpDetectorController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF38BDF8), width: 1.2),
        ),
        title: const Text('End Workout?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'Would you like to stop this session and see your summary?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Continue', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B82F6)),
            onPressed: () {
              Get.back();
              controller.finishWorkout();
            },
            child: const Text('View Summary', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
