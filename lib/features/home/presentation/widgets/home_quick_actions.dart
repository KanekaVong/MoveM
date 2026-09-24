import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class HomeQuickActions extends GetView<HomeController> {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n?.quickActions ?? 'Quick Actions',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            _QuickActionCard(
              icon: const CustomPaint(
                size: Size(26, 26),
                painter: ChallengeIconPainter(),
              ),
              label: l10n?.challengeAction ?? 'Challenge',
              onTap: controller.onChallengeTap,
            ),
            const SizedBox(width: 10),
            _QuickActionCard(
              icon: const Icon(
                Icons.format_list_bulleted_rounded,
                color: Color(0xFF3B6FE8),
                size: 28,
              ),
              label: l10n?.task ?? 'Tasks',
              onTap: controller.onAddTaskTap,
            ),
            const SizedBox(width: 10),
            _QuickActionCard(
              icon: Transform.rotate(
                angle: -0.35,
                child: const Icon(
                  Icons.airplane_ticket_outlined,
                  color: Color(0xFF3B6FE8),
                  size: 28,
                ),
              ),
              label: l10n?.trip ?? 'Trips',
              onTap: controller.onPlanTripsTap,
            ),
            const SizedBox(width: 10),
            _QuickActionCard(
              icon: const CustomPaint(
                size: Size(26, 26),
                painter: FitnessClubIconPainter(),
              ),
              label: l10n?.fitnessClubAction ?? 'Fitness Club',
              onTap: controller.onFitnessClubTap,
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 86,
          decoration: BoxDecoration(
            color: AppColors.chipSurface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 28,
                child: Center(child: icon),
              ),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.accentBlue,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChallengeIconPainter extends CustomPainter {
  final Color color;
  const ChallengeIconPainter({this.color = const Color(0xFF3B6FE8)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width / 2;

    final starPath = Path();
    final starCenter = Offset(cx, size.height * 0.22);
    final outerRadius = size.width * 0.18;
    final innerRadius = outerRadius * 0.45;
    for (int i = 0; i < 10; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (i * 36 - 90) * math.pi / 180;
      final x = starCenter.dx + radius * math.cos(angle);
      final y = starCenter.dy + radius * math.sin(angle);
      if (i == 0) {
        starPath.moveTo(x, y);
      } else {
        starPath.lineTo(x, y);
      }
    }
    starPath.close();
    canvas.drawPath(starPath, paint);

    final podiumPath = Path()
      ..moveTo(cx - 12, size.height * 0.88)
      ..lineTo(cx - 12, size.height * 0.62)
      ..lineTo(cx - 4.5, size.height * 0.62)
      ..lineTo(cx - 4.5, size.height * 0.48)
      ..lineTo(cx + 4.5, size.height * 0.48)
      ..lineTo(cx + 4.5, size.height * 0.68)
      ..lineTo(cx + 12, size.height * 0.68)
      ..lineTo(cx + 12, size.height * 0.88)
      ..close();
    canvas.drawPath(podiumPath, paint);

    canvas.drawLine(Offset(cx - 4.5, size.height * 0.62), Offset(cx - 4.5, size.height * 0.88), paint);
    canvas.drawLine(Offset(cx + 4.5, size.height * 0.68), Offset(cx + 4.5, size.height * 0.88), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FitnessClubIconPainter extends CustomPainter {
  final Color color;
  const FitnessClubIconPainter({this.color = const Color(0xFF3B6FE8)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final shield = Path()
      ..moveTo(w * 0.20, h * 0.18)
      ..lineTo(w * 0.80, h * 0.18)
      ..lineTo(w * 0.80, h * 0.54)
      ..cubicTo(w * 0.80, h * 0.78, w * 0.50, h * 0.92, w * 0.50, h * 0.92)
      ..cubicTo(w * 0.50, h * 0.92, w * 0.20, h * 0.78, w * 0.20, h * 0.54)
      ..close();
    canvas.drawPath(shield, paint);

    final starPath = Path();
    final starCenter = Offset(w * 0.50, h * 0.48);
    final outerRadius = w * 0.16;
    final innerRadius = outerRadius * 0.46;
    for (int i = 0; i < 10; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (i * 36 - 90) * math.pi / 180;
      final x = starCenter.dx + radius * math.cos(angle);
      final y = starCenter.dy + radius * math.sin(angle);
      if (i == 0) {
        starPath.moveTo(x, y);
      } else {
        starPath.lineTo(x, y);
      }
    }
    starPath.close();
    canvas.drawPath(starPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
