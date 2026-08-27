import 'package:flutter/material.dart';
import 'dart:math';

class BottomNavShapeClipper extends CustomClipper<Path> {
  final double curveXPosition;
  final double notchDepth;
  final double notchSpread;

  BottomNavShapeClipper({
    required this.curveXPosition,
    this.notchDepth = 30.0,
    this.notchSpread = 90.0,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    final clampedX = max(0.0, min(curveXPosition, width));

    final startX = clampedX - notchSpread / 2;
    final endX = clampedX + notchSpread / 2;

    path.moveTo(0, 0);
    path.lineTo(startX, 0);

    path.cubicTo(
      startX + (notchSpread * 0.20), 0,
      startX + (notchSpread * 0.20), notchDepth,
      clampedX, notchDepth,
    );

    path.cubicTo(
      endX - (notchSpread * 0.20), notchDepth,
      endX - (notchSpread * 0.20), 0,
      endX, 0,
    );

    path.lineTo(width, 0);
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant BottomNavShapeClipper oldClipper) {
    return oldClipper.curveXPosition != curveXPosition ||
           oldClipper.notchDepth != notchDepth ||
           oldClipper.notchSpread != notchSpread;
  }
}
