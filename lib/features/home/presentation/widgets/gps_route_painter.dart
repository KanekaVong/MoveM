import 'package:flutter/material.dart';

class GpsRoutePainter extends CustomPainter {
  final bool colorfulDots;
  final double strokeWidth;

  const GpsRoutePainter({
    this.colorfulDots = false,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFFFBBF24)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final glowPaint = Paint()
      ..color = const Color(0xFFFBBF24).withValues(alpha: 0.22)
      ..strokeWidth = strokeWidth + 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final points = [
      Offset(size.width * 0.50, size.height * 0.10),
      Offset(size.width * 0.92, size.height * 0.32),
      Offset(size.width * 0.78, size.height * 0.58),
      Offset(size.width * 0.28, size.height * 0.88),
      Offset(size.width * 0.08, size.height * 0.42),
    ];

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, linePaint);

    final dotColors = colorfulDots
        ? const [
            Color(0xFFEF4444),
            Color(0xFFF59E0B),
            Color(0xFFFBBF24),
            Color(0xFFF59E0B),
            Color(0xFFF97316),
          ]
        : const [
            Color(0xFFFBBF24),
            Color(0xFFFBBF24),
            Color(0xFFFBBF24),
            Color(0xFFFBBF24),
            Color(0xFFFBBF24),
          ];

    for (int i = 0; i < points.length; i++) {
      final fill = Paint()
        ..color = dotColors[i]
        ..style = PaintingStyle.fill;
      canvas.drawCircle(points[i], colorfulDots ? 6.0 : 3.2, fill);
    }
  }

  @override
  bool shouldRepaint(covariant GpsRoutePainter oldDelegate) {
    return oldDelegate.colorfulDots != colorfulDots || oldDelegate.strokeWidth != strokeWidth;
  }
}
