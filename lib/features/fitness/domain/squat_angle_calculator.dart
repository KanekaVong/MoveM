import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class SquatAngleCalculator {
  SquatAngleCalculator._();

  static double calculateAngle(Offset a, Offset b, Offset c) {
    final double radians = math.atan2(c.dy - b.dy, c.dx - b.dx) -
        math.atan2(a.dy - b.dy, a.dx - b.dx);
    double angle = radians.abs() * 180.0 / math.pi;

    if (angle > 180.0) {
      angle = 360.0 - angle;
    }
    return angle;
  }

  static double? calculateKneeAngle({
    required PoseLandmark? hip,
    required PoseLandmark? knee,
    required PoseLandmark? ankle,
    double minLikelihood = 0.5,
  }) {
    if (hip == null || knee == null || ankle == null) return null;
    if (hip.likelihood < minLikelihood ||
        knee.likelihood < minLikelihood ||
        ankle.likelihood < minLikelihood) {
      return null;
    }

    final p1 = Offset(hip.x, hip.y);
    final p2 = Offset(knee.x, knee.y);
    final p3 = Offset(ankle.x, ankle.y);

    return calculateAngle(p1, p2, p3);
  }

  static double? calculateHipAngle({
    required PoseLandmark? shoulder,
    required PoseLandmark? hip,
    required PoseLandmark? knee,
    double minLikelihood = 0.5,
  }) {
    if (shoulder == null || hip == null || knee == null) return null;
    if (shoulder.likelihood < minLikelihood ||
        hip.likelihood < minLikelihood ||
        knee.likelihood < minLikelihood) {
      return null;
    }

    final p1 = Offset(shoulder.x, shoulder.y);
    final p2 = Offset(hip.x, hip.y);
    final p3 = Offset(knee.x, knee.y);

    return calculateAngle(p1, p2, p3);
  }
}
