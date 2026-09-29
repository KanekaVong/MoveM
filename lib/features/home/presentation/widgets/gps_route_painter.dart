import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../domain/models/home_feed_item.dart';

class GpsRoutePainter extends CustomPainter {
  final bool colorfulDots;
  final double strokeWidth;
  final List<FeedRoutePoint> routePoints;

  const GpsRoutePainter({
    this.colorfulDots = false,
    this.strokeWidth = 2.0,
    this.routePoints = const [],
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

    final points = routePoints.length >= 2 ? _project(routePoints, size) : _placeholder(size);

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    if (routePoints.length < 2) {
      path.close();
    }

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

    if (routePoints.length >= 2) {
      final startFill = Paint()
        ..color = const Color(0xFFEF4444)
        ..style = PaintingStyle.fill;
      final endFill = Paint()
        ..color = const Color(0xFFFBBF24)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(points.first, colorfulDots ? 6.0 : 3.6, startFill);
      canvas.drawCircle(points.last, colorfulDots ? 6.0 : 3.6, endFill);
      return;
    }

    for (int i = 0; i < points.length; i++) {
      final fill = Paint()
        ..color = dotColors[i % dotColors.length]
        ..style = PaintingStyle.fill;
      canvas.drawCircle(points[i], colorfulDots ? 6.0 : 3.2, fill);
    }
  }

  List<Offset> _placeholder(Size size) {
    return [
      Offset(size.width * 0.50, size.height * 0.10),
      Offset(size.width * 0.92, size.height * 0.32),
      Offset(size.width * 0.78, size.height * 0.58),
      Offset(size.width * 0.28, size.height * 0.88),
      Offset(size.width * 0.08, size.height * 0.42),
    ];
  }

  List<Offset> _project(List<FeedRoutePoint> source, Size size) {
    var minLat = source.first.latitude;
    var maxLat = source.first.latitude;
    var minLng = source.first.longitude;
    var maxLng = source.first.longitude;
    for (final point in source) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    final latSpan = math.max(maxLat - minLat, 0.00001);
    final lngSpan = math.max(maxLng - minLng, 0.00001);
    const padding = 16.0;
    final drawW = size.width - padding * 2;
    final drawH = size.height - padding * 2;
    final scale = math.min(drawW / lngSpan, drawH / latSpan);
    final usedW = lngSpan * scale;
    final usedH = latSpan * scale;
    final originX = (size.width - usedW) / 2;
    final originY = (size.height - usedH) / 2;

    return source
        .map((point) => Offset(
              originX + (point.longitude - minLng) * scale,
              originY + (maxLat - point.latitude) * scale,
            ))
        .toList();
  }

  @override
  bool shouldRepaint(covariant GpsRoutePainter oldDelegate) {
    return oldDelegate.colorfulDots != colorfulDots ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.routePoints.length != routePoints.length ||
        (routePoints.isNotEmpty &&
            oldDelegate.routePoints.isNotEmpty &&
            (oldDelegate.routePoints.first.latitude != routePoints.first.latitude ||
                oldDelegate.routePoints.last.longitude != routePoints.last.longitude));
  }
}
