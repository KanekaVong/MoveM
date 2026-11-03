import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class CameraPosePainter extends CustomPainter {
  final List<Pose> poses;
  final Size imageSize;
  final InputImageRotation rotation;
  final bool isFrontCamera;
  final double currentAngle;
  final bool isSquat;

  CameraPosePainter({
    required this.poses,
    required this.imageSize,
    required this.rotation,
    this.isFrontCamera = true,
    this.currentAngle = 170.0,
    this.isSquat = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (poses.isEmpty || imageSize.width == 0 || imageSize.height == 0) return;

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final formPaint = Paint()
      ..color = _getAngleColor(currentAngle).withValues(alpha: 0.9)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final jointFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final jointGlow = Paint()
      ..color = _getAngleColor(currentAngle).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    for (final pose in poses) {
      Offset? translatePoint(PoseLandmark? landmark) {
        if (landmark == null || landmark.likelihood < 0.4) return null;

        double x = landmark.x;
        double y = landmark.y;

        double scaleX = size.width / imageSize.width;
        double scaleY = size.height / imageSize.height;

        if (Platform.isAndroid) {
          if (rotation == InputImageRotation.rotation90deg ||
              rotation == InputImageRotation.rotation270deg) {
            scaleX = size.width / imageSize.height;
            scaleY = size.height / imageSize.width;
          }
        }

        double destX = x * scaleX;
        double destY = y * scaleY;

        if (isFrontCamera) {
          destX = size.width - destX;
        }

        return Offset(destX, destY);
      }

      void drawLineBetween(
        PoseLandmarkType type1,
        PoseLandmarkType type2, {
        Paint? customPaint,
      }) {
        final p1 = translatePoint(pose.landmarks[type1]);
        final p2 = translatePoint(pose.landmarks[type2]);
        if (p1 != null && p2 != null) {
          canvas.drawLine(p1, p2, customPaint ?? linePaint);
        }
      }

      drawLineBetween(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, customPaint: isSquat ? linePaint : formPaint);
      drawLineBetween(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, customPaint: isSquat ? linePaint : formPaint);
      drawLineBetween(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, customPaint: isSquat ? linePaint : formPaint);
      drawLineBetween(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, customPaint: isSquat ? linePaint : formPaint);

      drawLineBetween(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder);
      drawLineBetween(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip);
      drawLineBetween(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip);
      drawLineBetween(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip);

      drawLineBetween(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, customPaint: isSquat ? formPaint : linePaint);
      drawLineBetween(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, customPaint: isSquat ? formPaint : linePaint);
      drawLineBetween(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, customPaint: isSquat ? formPaint : linePaint);
      drawLineBetween(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, customPaint: isSquat ? formPaint : linePaint);

      for (final landmark in pose.landmarks.values) {
        final pt = translatePoint(landmark);
        if (pt != null) {
          final isPrimaryJoint = isSquat
              ? (landmark.type == PoseLandmarkType.leftKnee ||
                  landmark.type == PoseLandmarkType.rightKnee ||
                  landmark.type == PoseLandmarkType.leftHip ||
                  landmark.type == PoseLandmarkType.rightHip ||
                  landmark.type == PoseLandmarkType.leftAnkle ||
                  landmark.type == PoseLandmarkType.rightAnkle)
              : (landmark.type == PoseLandmarkType.leftElbow ||
                  landmark.type == PoseLandmarkType.rightElbow ||
                  landmark.type == PoseLandmarkType.leftShoulder ||
                  landmark.type == PoseLandmarkType.rightShoulder);

          if (isPrimaryJoint) {
            canvas.drawCircle(pt, 8.0, jointGlow);
            canvas.drawCircle(pt, 4.0, jointFill);
          } else {
            canvas.drawCircle(pt, 4.0, jointFill);
          }
        }
      }
    }
  }

  Color _getAngleColor(double angle) {
    if (angle <= 95.0) {
      return const Color(0xFF10B981);
    } else if (angle <= 125.0) {
      return const Color(0xFFF59E0B);
    } else {
      return const Color(0xFF38BDF8);
    }
  }

  @override
  bool shouldRepaint(covariant CameraPosePainter oldDelegate) {
    return oldDelegate.poses != poses ||
        oldDelegate.currentAngle != currentAngle ||
        oldDelegate.isFrontCamera != isFrontCamera ||
        oldDelegate.isSquat != isSquat;
  }
}
