import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/fitness_profile_controller.dart';
import '../controllers/fitness_club_controller.dart';
import '../widgets/solo_challenge_card.dart';
import 'fitness_club_screen.dart';
import 'fitness_profile_goal_screen.dart';
import 'solo_challenge_list_screen.dart';
import 'workout_history_screen.dart';
import '../controllers/workout_history_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/no_data_component.dart';

class FitnessDashboardScreen extends StatelessWidget {
  final FitnessProfileController controller;
  const FitnessDashboardScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final clubController = Get.isRegistered<FitnessClubController>()
        ? Get.find<FitnessClubController>()
        : Get.put(FitnessClubController());

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: RefreshIndicator(
          color: Colors.blueAccent,
          backgroundColor: AppColors.chipSurface,
          onRefresh: () async {
            await Future.wait([
              controller.refreshData(),
              clubController.loadClubs(),
            ]);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 120.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopCard(),
                SizedBox(height: 16),

                _buildCaloriesCard(),
                SizedBox(height: 22),

                _buildQuickAction(),
                SizedBox(height: 26),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n?.soloChallenges ?? 'Solo Challenges',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const SoloChallengeListScreen());
                      },
                      child: Text(
                        l10n?.viewAll ?? 'See All',
                        style: TextStyle(
                          color: AppColors.textPrimary.withValues(alpha: 0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                Obx(() {
                  if (controller.isLoadingChallenges.value && controller.soloChallenges.isEmpty) {
                    return Center(child: CircularProgressIndicator(color: Colors.blueAccent));
                  }
                  if (controller.soloChallenges.isEmpty) {
                    return NoDataComponent(
                      compact: true,
                      title: l10n?.noSoloChallenges ?? 'No solo challenges available',
                    );
                  }
                  return Column(
                    children: controller.soloChallenges.map((challenge) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: SoloChallengeCard(
                          challenge: challenge,
                        ),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 14, 18),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.chipSurface),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Workout",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 28),
                Text(
                  "Small step, big changes",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Start tracking your Fitness Journey with us now",
                  style: TextStyle(
                    color: AppColors.textPrimary.withValues(alpha: 0.8),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              AppImages.workoutDetailsHero,
              width: 100,
              height: 90,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Image.asset(
                AppImages.runningActivity,
                width: 88,
                height: 88,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaloriesCard() {
    final currentWeekday = DateTime.now().weekday;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.chipSurface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calories Burned',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  SizedBox(height: 4),
                  Obx(() {
                    final stats = controller.statistics.value;
                    final calories = stats != null && stats.caloriesToday > 0
                        ? stats.caloriesToday.toInt()
                        : (stats != null && stats.totalCalories > 0
                            ? stats.totalCalories.toInt()
                            : 0);
                    return RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$calories ',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'kcal',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.chipSurface,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF1E356D), width: 1),
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDayPill('Mon', isActive: currentWeekday == 1),
              _buildDayPill('Tue', isActive: currentWeekday == 2),
              _buildDayPill('Wed', isActive: currentWeekday == 3),
              _buildDayPill('Thu', isActive: currentWeekday == 4),
              _buildDayPill('Fri', isActive: currentWeekday == 5),
              _buildDayPill('Sat', isActive: currentWeekday == 6),
              _buildDayPill('Sun', isActive: currentWeekday == 7),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayPill(String day, {required bool isActive}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 4,
          decoration: BoxDecoration(
            color: isActive ? AppColors.accentBlue : AppColors.borderMuted,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            color: isActive ? AppColors.accentBlue : AppColors.textSecondary,
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction() {
    final l10n = AppLocalizations.of(Get.context!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n?.quickActions ?? 'Quick Action',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 14),
        Row(
          children: [
            _quickActionCard(
              label: l10n?.fitnessClubAction ?? 'Fitness Club',
              onTap: () => Get.to(() => const FitnessClubScreen()),
              icon: CustomPaint(
                size: const Size(26, 26),
                painter: const FitnessClubShieldPainter(color: Color(0xFF5B9BF6)),
              ),
            ),
            SizedBox(width: 10),
            _quickActionCard(
              label: l10n?.goals ?? 'Goals',
              onTap: () async {
                await Get.to(() => const FitnessProfileGoalScreen());
                controller.fetchProfile();
              },
              icon: CustomPaint(
                size: const Size(26, 26),
                painter: const GoalsBurstPainter(color: Color(0xFF5B9BF6)),
              ),
            ),
            SizedBox(width: 10),
            _quickActionCard(
              label: l10n?.history ?? 'History',
              onTap: () {
                if (Get.isRegistered<WorkoutHistoryController>()) {
                  Get.delete<WorkoutHistoryController>(force: true);
                }
                Get.to(() => const WorkoutHistoryScreen());
              },
              icon: Icon(Icons.history, color: Color(0xFF5B9BF6), size: 26),
            ),
          ],
        ),
      ],
    );
  }

  Widget _quickActionCard({
    required String label,
    required VoidCallback onTap,
    required Widget icon,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 96,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderLight, width: 1.2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FitnessClubShieldPainter extends CustomPainter {
  final Color color;
  const FitnessClubShieldPainter({this.color = const Color(0xFF5B9BF6)});

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
      ..moveTo(w * 0.18, h * 0.15)
      ..lineTo(w * 0.82, h * 0.15)
      ..lineTo(w * 0.82, h * 0.52)
      ..cubicTo(w * 0.82, h * 0.78, w * 0.50, h * 0.94, w * 0.50, h * 0.94)
      ..cubicTo(w * 0.50, h * 0.94, w * 0.18, h * 0.78, w * 0.18, h * 0.52)
      ..close();
    canvas.drawPath(shield, paint);

    final starPath = Path();
    final starCenter = Offset(w * 0.50, h * 0.46);
    final outerRadius = w * 0.17;
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

class GoalsBurstPainter extends CustomPainter {
  final Color color;
  const GoalsBurstPainter({this.color = const Color(0xFF5B9BF6)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Center star
    final starPath = Path();
    final starR = size.width * 0.15;
    final innerR = starR * 0.45;
    for (int i = 0; i < 8; i++) {
      final r = i.isEven ? starR : innerR;
      final angle = (i * 45 - 90) * math.pi / 180;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      if (i == 0) {
        starPath.moveTo(x, y);
      } else {
        starPath.lineTo(x, y);
      }
    }
    starPath.close();
    canvas.drawPath(starPath, paint);

    // Radiating rays
    final rayStart = size.width * 0.24;
    final rayEnd = size.width * 0.46;
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * math.pi / 180;
      final x1 = cx + rayStart * math.cos(angle);
      final y1 = cy + rayStart * math.sin(angle);
      final x2 = cx + rayEnd * math.cos(angle);
      final y2 = cy + rayEnd * math.sin(angle);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
