import 'dart:math' as math;

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:movem/features/trip/presentation/models/create_trip_stop_draft.dart';

class TripRouteCalculator {


  double distanceBetween(
      LatLng a,
      LatLng b,
      ) {
    const earthRadius = 6371000.0;

    final lat1 = a.latitude * math.pi / 180;
    final lat2 = b.latitude * math.pi / 180;

    final deltaLat =
        (b.latitude - a.latitude) * math.pi / 180;

    final deltaLng =
        (b.longitude - a.longitude) * math.pi / 180;

    final h =
        math.sin(deltaLat / 2) *
            math.sin(deltaLat / 2) +
            math.cos(lat1) *
                math.cos(lat2) *
                math.sin(deltaLng / 2) *
                math.sin(deltaLng / 2);

    final c =
        2 * math.atan2(
          math.sqrt(h),
          math.sqrt(1 - h),
        );

    return earthRadius * c;
  }


  double distanceToSegment(
      LatLng point,
      LatLng start,
      LatLng end,
      ) {
    final x = point.longitude;
    final y = point.latitude;

    final x1 = start.longitude;
    final y1 = start.latitude;

    final x2 = end.longitude;
    final y2 = end.latitude;

    final dx = x2 - x1;
    final dy = y2 - y1;

    if (dx == 0 && dy == 0) {
      return distanceBetween(point, start);
    }

    final t =
        ((x - x1) * dx + (y - y1) * dy) /
            (dx * dx + dy * dy);

    final clampedT = t.clamp(0.0, 1.0);

    final closestPoint = LatLng(
      y1 + clampedT * dy,
      x1 + clampedT * dx,
    );

    return distanceBetween(
      point,
      closestPoint,
    );
  }

  bool isNearCurrentRoute({
    required LatLng location,
    required List<LatLng> routePoints,
    double toleranceMeters = 100.0,
  }) {
    if (routePoints.length < 2) {
      return false;
    }

    for (int i = 0; i < routePoints.length - 1; i++) {
      final distance = distanceToSegment(
        location,
        routePoints[i],
        routePoints[i + 1],
      );

      if (distance <= toleranceMeters) {
        return true;
      }
    }

    return false;
  }

  double getRouteProgress({
    required LatLng location,
    required List<LatLng> routePoints,
  }) {
    if (routePoints.length < 2) {
      return double.infinity;
    }

    double totalRouteDistance = 0.0;

    final segmentDistances = <double>[];

    for (int i = 0; i < routePoints.length - 1; i++) {
      final segmentLength = distanceBetween(
        routePoints[i],
        routePoints[i + 1],
      );

      segmentDistances.add(segmentLength);
      totalRouteDistance += segmentLength;
    }

    if (totalRouteDistance == 0) {
      return 0;
    }

    double bestDistance = double.infinity;
    double bestDistanceAlongRoute = 0.0;

    double distanceAlongRoute = 0.0;

    for (int i = 0; i < routePoints.length - 1; i++) {
      final start = routePoints[i];
      final end = routePoints[i + 1];

      final segmentLength = segmentDistances[i];

      final projectionRatio =
      _getProjectionRatio(
        location,
        start,
        end,
      );

      final projectedPoint = LatLng(
        start.latitude +
            (end.latitude - start.latitude) *
                projectionRatio,
        start.longitude +
            (end.longitude - start.longitude) *
                projectionRatio,
      );

      final distanceToRoute =
      distanceBetween(
        location,
        projectedPoint,
      );

      if (distanceToRoute < bestDistance) {
        bestDistance = distanceToRoute;

        bestDistanceAlongRoute =
            distanceAlongRoute +
                segmentLength * projectionRatio;
      }

      distanceAlongRoute += segmentLength;
    }

    return bestDistanceAlongRoute /
        totalRouteDistance;
  }


  int findBestStopIndex({
    required LatLng newStop,
    required List<CreateTripStopDraft> stops,
    required List<LatLng> routePoints,
  }) {
    if (stops.isEmpty) {
      return 0;
    }

    final newProgress = getRouteProgress(
      location: newStop,
      routePoints: routePoints,
    );

    if (newProgress == double.infinity) {
      return stops.length;
    }

    for (int i = 0; i < stops.length; i++) {
      final stop = stops[i];

      if (stop.lat == null || stop.lng == null) {
        continue;
      }

      final stopProgress = getRouteProgress(
        location: LatLng(
          stop.lat!,
          stop.lng!,
        ),
        routePoints: routePoints,
      );

      if (newProgress < stopProgress) {
        return i;
      }
    }

    return stops.length;
  }

  double _getProjectionRatio(
      LatLng point,
      LatLng start,
      LatLng end,
      ) {
    final x = point.longitude;
    final y = point.latitude;

    final x1 = start.longitude;
    final y1 = start.latitude;

    final x2 = end.longitude;
    final y2 = end.latitude;

    final dx = x2 - x1;
    final dy = y2 - y1;

    if (dx == 0 && dy == 0) {
      return 0;
    }

    final ratio =
        ((x - x1) * dx + (y - y1) * dy) /
            (dx * dx + dy * dy);

    return ratio.clamp(0.0, 1.0);
  }

  List<LatLng> simplifyRoute(
      List<LatLng> points, {
        double toleranceMeters = 20.0,
      }) {
    if (points.length <= 2) {
      return List<LatLng>.from(points);
    }

    final keep = List<bool>.filled(points.length, false);

    keep[0] = true;
    keep[points.length - 1] = true;

    _simplifySection(
      points,
      0,
      points.length - 1,
      toleranceMeters,
      keep,
    );

    final simplified = <LatLng>[];

    for (int i = 0; i < points.length; i++) {
      if (keep[i]) {
        simplified.add(points[i]);
      }
    }

    return simplified;
  }

  void _simplifySection(
      List<LatLng> points,
      int startIndex,
      int endIndex,
      double toleranceMeters,
      List<bool> keep,
      ) {
    if (endIndex <= startIndex + 1) {
      return;
    }

    final start = points[startIndex];
    final end = points[endIndex];

    double maxDistance = 0.0;
    int maxIndex = -1;

    for (int i = startIndex + 1; i < endIndex; i++) {
      final distance = distanceToSegment(
        points[i],
        start,
        end,
      );

      if (distance > maxDistance) {
        maxDistance = distance;
        maxIndex = i;
      }
    }

    if (maxDistance > toleranceMeters && maxIndex != -1) {
      keep[maxIndex] = true;

      _simplifySection(
        points,
        startIndex,
        maxIndex,
        toleranceMeters,
        keep,
      );

      _simplifySection(
        points,
        maxIndex,
        endIndex,
        toleranceMeters,
        keep,
      );
    }
  }

}