import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PushUpAngleCalculator {
  PushUpAngleCalculator._();

  /// Calculates the interior angle in degrees (0.0 to 180.0) at joint [b]
  /// formed by vectors [b -> a] and [b -> c].
  static double calculateAngle(Offset a, Offset b, Offset c) {
    final double radians = math.atan2(c.dy - b.dy, c.dx - b.dx) -
        math.atan2(a.dy - b.dy, a.dx - b.dx);
    double angle = radians.abs() * 180.0 / math.pi;

    if (angle > 180.0) {
      angle = 360.0 - angle;
    }
    return angle;
  }

  /// Calculates elbow angle from ML Kit PoseLandmarks
  static double? calculateElbowAngle({
    required PoseLandmark? shoulder,
    required PoseLandmark? elbow,
    required PoseLandmark? wrist,
    double minLikelihood = 0.5,
  }) {
    if (shoulder == null || elbow == null || wrist == null) return null;
    if (shoulder.likelihood < minLikelihood ||
        elbow.likelihood < minLikelihood ||
        wrist.likelihood < minLikelihood) {
      return null;
    }

    final p1 = Offset(shoulder.x, shoulder.y);
    final p2 = Offset(elbow.x, elbow.y);
    final p3 = Offset(wrist.x, wrist.y);

    return calculateAngle(p1, p2, p3);
  }

  /// Calculates body hip alignment angle (shoulder - hip - ankle) to evaluate torso plank form
  static double? calculateHipAlignmentAngle({
    required PoseLandmark? shoulder,
    required PoseLandmark? hip,
    required PoseLandmark? ankle,
    double minLikelihood = 0.5,
  }) {
    if (shoulder == null || hip == null || ankle == null) return null;
    if (shoulder.likelihood < minLikelihood ||
        hip.likelihood < minLikelihood ||
        ankle.likelihood < minLikelihood) {
      return null;
    }

    final p1 = Offset(shoulder.x, shoulder.y);
    final p2 = Offset(hip.x, hip.y);
    final p3 = Offset(ankle.x, ankle.y);

    return calculateAngle(p1, p2, p3);
  }
}
