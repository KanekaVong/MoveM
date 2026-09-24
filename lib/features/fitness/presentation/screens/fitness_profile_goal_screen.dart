import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/fitness_profile_controller.dart';
import 'fitness_onboarding_screen.dart';
import 'setup_goal_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../l10n/app_localizations.dart';

class FitnessProfileGoalScreen extends StatefulWidget {
  const FitnessProfileGoalScreen({super.key});

  @override
  State<FitnessProfileGoalScreen> createState() => _FitnessProfileGoalScreenState();
}

class _FitnessProfileGoalScreenState extends State<FitnessProfileGoalScreen> {
  late final FitnessProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<FitnessProfileController>()
        ? Get.find<FitnessProfileController>()
        : Get.put(FitnessProfileController());
  }

  String _formatNumber(double value) {
    if (value <= 0) return '0';
    return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
  }

  Future<void> _editProfile() async {
    await Get.to(
      () => FitnessOnboardingScreen(controller: controller, isEditing: true),
    );
    await controller.fetchProfile();
  }

  Future<void> _editGoal() async {
    final res = await Get.to(() => const SetupGoalScreen());
    if (res == true) {
      await controller.fetchProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Obx(() {
        final profile = controller.profile.value;
        final goal = profile?.fitnessGoal;
        final weight = _formatNumber(profile?.weight ?? 0);
        final height = _formatNumber(profile?.height ?? 0);
        final hasLevel = goal != null && goal.workoutLevel.isNotEmpty;
        final level = hasLevel ? goal.formattedWorkoutLevel : (l10n?.noneValue ?? 'None');
        final targetDate = (goal == null || goal.targetTimeline.isEmpty)
            ? '0'
            : goal.formattedTargetDate;
        final targetWeight = (goal == null || goal.targetWeight <= 0)
            ? '0'
            : _formatNumber(goal.targetWeight);

        return Column(
          children: [
            _buildHero(l10n?.profileAndGoal ?? 'PROFILE & GOAL'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLink(
                      l10n?.editFitnessProfile ?? 'Edit Fitness Profile >>',
                      _editProfile,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                            icon: Icons.accessibility_new_rounded,
                            title: l10n?.currentWeight ?? 'Current Weight',
                            value: '$weight ${l10n?.kgUnit ?? 'KG'}'.toUpperCase(),
                            height: 148,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _statCard(
                            icon: Icons.accessibility_new_rounded,
                            title: l10n?.currentHeight ?? 'Current Height',
                            value: '$height CM',
                            height: 148,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    _sectionLink(
                      l10n?.editFitnessGoal ?? 'Edit Fitness Goal >>',
                      _editGoal,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 268,
                      child: Row(
                        children: [
                          Expanded(
                            child: _statCard(
                              icon: Icons.directions_run_rounded,
                              title: l10n?.fitnessLevel ?? 'Fitness Level',
                              value: level,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: _statCard(
                                    icon: Icons.gps_fixed_rounded,
                                    title: l10n?.targetDateLabel ?? 'Target Date',
                                    value: targetDate,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Expanded(
                                  child: _statCard(
                                    icon: Icons.accessibility_new_rounded,
                                    title: l10n?.targetWeightLabel ?? 'Target Weight',
                                    value: targetWeight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHero(String title) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppImages.runningActivity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Image.asset(
              AppImages.workoutDetailsHero,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.18),
                  Colors.black.withValues(alpha: 0.55),
                ],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.22),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
                    ),
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 26),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, -0.08),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                title.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 2.2,
                  shadows: [
                    Shadow(color: Colors.black54, blurRadius: 12, offset: Offset(0, 2)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLink(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    double? height,
  }) {
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF5B9BF6), size: 28),
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
