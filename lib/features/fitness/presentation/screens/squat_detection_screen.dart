import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../../../../core/utils/app_images.dart';
import '../../data/models/solo_challenge_model.dart';
import '../controllers/squat_detector_controller.dart';
import '../widgets/camera_pose_painter.dart';

class SquatDetectionScreen extends StatelessWidget {
  final SoloChallengeModel challenge;

  const SquatDetectionScreen({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<SquatDetectorController>()
        ? Get.find<SquatDetectorController>()
        : Get.put(SquatDetectorController(challenge: challenge));

    return Obx(
      () => PopScope(
      canPop: !controller.isFinishing.value,
      child: Scaffold(
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
                  child: Container(
                    color: const Color(0xFF0A1128),
                    child: Center(
                      child: Image.asset(
                        AppImages.squatsActivity,
                        fit: BoxFit.contain,
                        width: 260,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ),
                ),

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
                      currentAngle: controller.currentKneeAngle.value,
                      isSquat: true,
                    ),
                  ),
                ),

              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.timer_outlined, color: Colors.white70, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                _formatDuration(controller.durationSeconds.value),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.switchCamera(),
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
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 100,
                left: 20,
                right: 20,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFF38BDF8).withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          controller.currentFeedback.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 30,
                left: 20,
                right: 20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildMetricPill(
                          label: 'REPS',
                          value: '${controller.completedReps.value}',
                          target: '${challenge.repsPerSet}',
                          color: const Color(0xFF10B981),
                        ),
                        const SizedBox(width: 12),
                        _buildMetricPill(
                          label: 'SET',
                          value: '${controller.currentSet.value}',
                          target: '${challenge.sets}',
                          color: const Color(0xFF38BDF8),
                        ),
                        const SizedBox(width: 12),
                        _buildMetricPill(
                          label: 'KNEE ANGLE',
                          value: '${controller.currentKneeAngle.value.toInt()}°',
                          target: null,
                          color: controller.currentKneeAngle.value <= 95
                              ? const Color(0xFF10B981)
                              : const Color(0xFFF59E0B),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => controller.togglePause(),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: controller.isPaused.value
                                  ? const Color(0xFF10B981)
                                  : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: (controller.isPaused.value
                                          ? const Color(0xFF10B981)
                                          : Colors.white)
                                      .withValues(alpha: 0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                controller.isPaused.value
                                    ? Icons.play_arrow_rounded
                                    : Icons.pause_rounded,
                                color: controller.isPaused.value
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                                size: 26,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (controller.isPaused.value)
                      GestureDetector(
                        onTap: () => controller.finishWorkout(),
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFF333C4D),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.stop_rounded, color: Colors.white, size: 24),
                              SizedBox(width: 8),
                              Text(
                                'End',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Full-screen finishing overlay – blocks all interaction
              if (controller.isFinishing.value)
                Positioned.fill(
                  child: IgnorePointer(
                    ignoring: false,
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.72),
                      child: Center(
                        child: SizedBox(
                          width: 64,
                          height: 64,
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              const Color(0xFF38BDF8),
                            ),
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
      ),
    ),
    );
  }

  Widget _buildMetricPill({
    required String label,
    required String value,
    required String? target,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              text: value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              children: target != null
                  ? [
                      TextSpan(
                        text: ' / $target',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _confirmExit(BuildContext context, SquatDetectorController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Exit Squats Workout?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'Your progress for this workout will be ended.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Continue Workout', style: TextStyle(color: Color(0xFF38BDF8))),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.finishWorkout();
            },
            child: const Text('Finish & Save', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
