import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/run_session.dart';
import '../../data/models/track_point.dart';
import '../../data/models/solo_challenge_model.dart';
import '../../data/models/workout_model.dart';
import '../../domain/pace_calculator.dart';
import '../../../main_nav/presentation/controllers/main_nav_controller.dart';
import '../controllers/tracking_controller.dart';
import '../controllers/fitness_profile_controller.dart';
import 'running_tracking_screen.dart';
import 'solo_challenge_list_screen.dart';
import '../../../../core/theme/app_colors.dart';

class RunSummaryScreen extends StatelessWidget {
  final RunSession session;
  final FitnessWorkoutSummaryModel? summary;
  final SoloChallengeModel? challenge;

  const RunSummaryScreen({
    super.key,
    required this.session,
    this.summary,
    this.challenge,
  });

  String _formatDurationText(Duration duration) {
    final totalSecs = duration.inSeconds;
    if (totalSecs == 0) return '0MIN';
    final hours = totalSecs ~/ 3600;
    final mins = (totalSecs % 3600) ~/ 60;
    final secs = totalSecs % 60;

    if (hours > 0) {
      return '${hours}HR ${mins}MIN';
    } else if (mins > 0) {
      return '$mins' 'MIN ${secs > 0 ? '$secs' 'S' : ''}'.trim();
    } else {
      return '$secs' 'S';
    }
  }

  String _formatPace(double paceMinPerKm) {
    if (paceMinPerKm <= 0 || paceMinPerKm.isInfinite || paceMinPerKm.isNaN) {
      return '--:-- / KM';
    }
    final minutes = paceMinPerKm.toInt();
    final seconds = ((paceMinPerKm - minutes) * 60).toInt();
    return '$minutes:${seconds.toString().padLeft(2, '0')} / KM';
  }

  @override
  Widget build(BuildContext context) {
    final distanceKm = (summary != null && summary!.distance > 0)
        ? summary!.distance
        : session.totalDistanceMeters / 1000.0;

    final distanceStr = distanceKm >= 1
        ? '${distanceKm % 1 == 0 ? distanceKm.toInt() : distanceKm.toStringAsFixed(1)}KM'
        : '${(distanceKm * 1000).toInt()}M';

    final duration = (summary != null && summary!.durationSeconds > 0)
        ? Duration(seconds: summary!.durationSeconds)
        : session.elapsedDuration;

    final durationText = _formatDurationText(duration);

    final avgPace = distanceKm > 0
        ? PaceCalculator.paceMinPerKm(distanceKm * 1000, duration)
        : 0.0;

    final steps = (summary != null && summary!.steps > 0)
        ? summary!.steps
        : (session.totalDistanceMeters * 1.3).toInt();

    final calories = (summary != null && summary!.caloriesBurned > 0)
        ? summary!.caloriesBurned.round()
        : (distanceKm * 60).toInt();

    final challengeTitle = challenge?.name ?? 'RUNNING SESSION';

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: _goHome,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.cardSurface.withValues(alpha: 0.75),
                          border: Border.all(
                            color: AppColors.textPrimary.withValues(alpha: 0.2),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.textPrimary,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Workout Details',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 230,
                        child: CustomPaint(
                          painter: RoutePolygonPainter(points: session.points),
                          child: Center(
                            child: Text(
                              distanceStr,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 44,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 36),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildMetricTile(
                              label: 'STEPS',
                              value: '$steps 👟',
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          ),
                          Expanded(
                            child: _buildMetricTile(
                              label: 'DURATIONS',
                              value: durationText,
                              crossAxisAlignment: CrossAxisAlignment.end,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 36),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildMetricTile(
                              label: 'CALORIES',
                              value: '$calories 🔥',
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          ),
                          Expanded(
                            child: _buildMetricTile(
                              label: 'AVERAGE PACE',
                              value: _formatPace(avgPace),
                              crossAxisAlignment: CrossAxisAlignment.end,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 48),

                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            fontFamily: 'Roboto',
                          ),
                          children: [
                            TextSpan(
                              text: 'CHALLENGE: ${challengeTitle.toUpperCase()} ',
                              style: const TextStyle(color: AppColors.textPrimary),
                            ),
                            const TextSpan(
                              text: 'COMPLETED 🔥',
                              style: TextStyle(color: Color(0xFFFFA000)),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 48),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildCircleActionButton(
                              icon: Icons.share_outlined,
                              label: 'SHARE',
                              onTap: () {
                                Get.snackbar(
                                  'Share Workout',
                                  'Sharing $distanceStr running workout details...',
                                  backgroundColor: AppColors.textPrimary,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              },
                            ),

                            _buildCircleActionButton(
                              icon: Icons.replay_rounded,
                              label: 'REDO',
                              onTap: () {
                                Get.off(() => RunningTrackingScreen(challenge: challenge));
                              },
                            ),

                            _buildCircleActionButton(
                              icon: Icons.fitness_center_rounded,
                              label: 'MORE',
                              onTap: () {
                                Get.to(() => const SoloChallengeListScreen());
                              },
                            ),

                            _buildCircleActionButton(
                              icon: Icons.home_outlined,
                              label: 'HOME',
                              onTap: _goHome,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required CrossAxisAlignment crossAxisAlignment,
  }) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8E9BAE),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildCircleActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                color: AppColors.textPrimary.withValues(alpha: 0.35),
                width: 1.4,
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                color: AppColors.textPrimary,
                size: 22,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 9.5,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  void _goHome() {
    if (Get.isRegistered<FitnessProfileController>()) {
      Get.find<FitnessProfileController>().fetchSoloChallenges();
      Get.find<FitnessProfileController>().fetchStatistics();
    }
    if (Get.isRegistered<MainNavController>()) {
      Get.find<MainNavController>().changeTab(0);
    }
    if (Get.isRegistered<TrackingController>()) {
      Get.delete<TrackingController>();
    }
    Get.until((route) => route.isFirst);
  }
}

class RoutePolygonPainter extends CustomPainter {
  final List<TrackPoint> points;

  RoutePolygonPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFFFFA000)
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = const Color(0xFFFFA000).withValues(alpha: 0.3)
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    final nodePaint = Paint()
      ..color = const Color(0xFFFFB300)
      ..style = PaintingStyle.fill;

    final redNodePaint = Paint()
      ..color = const Color(0xFFFF5252)
      ..style = PaintingStyle.fill;

    final nodeOutlinePaint = Paint()
      ..color = AppColors.textPrimary.withValues(alpha: 0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    if (points.length < 3) {
      // Draw reference polygon loop matching design screenshot
      final p1 = Offset(size.width * 0.54, size.height * 0.12);
      final p2 = Offset(size.width * 0.88, size.height * 0.38);
      final p3 = Offset(size.width * 0.69, size.height * 0.65);
      final p4 = Offset(size.width * 0.31, size.height * 0.84);
      final p5 = Offset(size.width * 0.18, size.height * 0.42);

      final path = Path()
        ..moveTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy)
        ..lineTo(p3.dx, p3.dy)
        ..lineTo(p4.dx, p4.dy)
        ..lineTo(p5.dx, p5.dy)
        ..close();

      canvas.drawPath(path, glowPaint);
      canvas.drawPath(path, linePaint);

      // Red start dot
      canvas.drawCircle(p1, 6.0, redNodePaint);
      canvas.drawCircle(p1, 6.0, nodeOutlinePaint);

      // Orange dots for other vertices
      for (final pt in [p2, p3, p4, p5]) {
        canvas.drawCircle(pt, 5.5, nodePaint);
        canvas.drawCircle(pt, 5.5, nodeOutlinePaint);
      }
      return;
    }

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    final latSpan = maxLat - minLat;
    final lngSpan = maxLng - minLng;

    const padding = 36.0;
    final drawW = size.width - (padding * 2);
    final drawH = size.height - (padding * 2);

    final maxSpan = math.max(latSpan, lngSpan);
    final scale = maxSpan > 0.000001 ? math.min(drawW, drawH) / maxSpan : 1.0;

    final centerCanvasX = size.width / 2;
    final centerCanvasY = size.height / 2;
    final centerLat = (minLat + maxLat) / 2;
    final centerLng = (minLng + maxLng) / 2;

    Offset toOffset(TrackPoint p) {
      final dx = centerCanvasX + (p.longitude - centerLng) * scale;
      final dy = centerCanvasY - (p.latitude - centerLat) * scale;
      return Offset(dx, dy);
    }

    final path = Path();
    final firstOffset = toOffset(points.first);
    path.moveTo(firstOffset.dx, firstOffset.dy);

    for (int i = 1; i < points.length; i++) {
      final off = toOffset(points[i]);
      path.lineTo(off.dx, off.dy);
    }

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, linePaint);

    // Intermediate nodes
    if (points.length >= 6) {
      final step = (points.length / 5).floor().clamp(1, points.length);
      for (int i = step; i < points.length - 1; i += step) {
        final off = toOffset(points[i]);
        canvas.drawCircle(off, 4.5, nodePaint);
      }
    }

    // Start point (Red dot)
    canvas.drawCircle(firstOffset, 6.0, redNodePaint);
    canvas.drawCircle(firstOffset, 6.0, nodeOutlinePaint);

    // End point (Amber dot)
    final endOffset = toOffset(points.last);
    canvas.drawCircle(endOffset, 6.0, nodePaint);
    canvas.drawCircle(endOffset, 6.0, nodeOutlinePaint);
  }

  @override
  bool shouldRepaint(covariant RoutePolygonPainter oldDelegate) =>
      oldDelegate.points.length != points.length;
}
