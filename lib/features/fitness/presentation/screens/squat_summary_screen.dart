import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../main_nav/presentation/controllers/main_nav_controller.dart';
import '../../data/models/solo_challenge_model.dart';
import '../../data/models/squat_session_model.dart';
import '../../data/models/workout_model.dart';
import '../controllers/fitness_profile_controller.dart';
import 'solo_challenge_list_screen.dart';
import 'squat_detection_screen.dart';
import '../../../../core/theme/app_colors.dart';

class SquatSummaryScreen extends StatelessWidget {
  final SquatSession session;
  final SoloChallengeModel challenge;
  final FitnessWorkoutSummaryModel? summary;

  const SquatSummaryScreen({
    super.key,
    required this.session,
    required this.challenge,
    this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final duration = session.duration;
    final totalMinutes = duration.inMinutes;
    final durationDisplay = totalMinutes >= 1
        ? '$totalMinutes MINS'
        : '${duration.inSeconds} SECS';

    final calories = (summary != null && summary!.caloriesBurned > 0)
        ? summary!.caloriesBurned.round()
        : (session.caloriesBurned > 0
            ? session.caloriesBurned
            : (session.totalReps * 0.35).round());

    final completedSets = challenge.repsPerSet > 0
        ? (session.totalReps / challenge.repsPerSet).floor().clamp(0, challenge.sets)
        : challenge.sets;
    final setsDisplay = '$completedSets / ${challenge.sets}';

    final isAllCompleted = session.isCompleted ||
        (challenge.sets > 0 &&
            challenge.repsPerSet > 0 &&
            session.totalReps >= (challenge.sets * challenge.repsPerSet));

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 320,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                      child: Image.asset(
                        AppImages.squatsActivity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          AppImages.workoutDetailsHero,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      height: 320,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.5),
                            Colors.transparent,
                            AppColors.pageBackground.withValues(alpha: 0.9),
                            AppColors.pageBackground,
                          ],
                          stops: const [0.0, 0.4, 0.85, 1.0],
                        ),
                      ),
                    ),

                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: _goHome,
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.chipSurface,
                                    border: Border.all(
                                      color: AppColors.textPrimary.withValues(alpha: 0.25),
                                      width: 1.5,
                                    ),
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
                            Text(
                              l10n?.workoutDetails ?? 'Workout Details',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricColumn(
                        label: 'SET',
                        value: '$setsDisplay 💪',
                      ),

                      _buildMetricColumn(
                        label: 'CALORIES',
                        value: '$calories 🔥',
                      ),

                      _buildMetricColumn(
                        label: 'DURATIONS',
                        value: durationDisplay,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                Column(
                  children: [
                    const Text(
                      'CHALLENGE',
                      style: TextStyle(
                        color: AppColors.textCaption,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      challenge.name.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isAllCompleted ? 'COMPLETED 🔥' : 'FINISHED 🔥',
                      style: const TextStyle(
                        color: Color(0xFFF59E0B),
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 64),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCircleActionButton(
                        icon: Icons.share_outlined,
                        label: 'SHARE',
                        onTap: () {
                          Get.snackbar(
                            'Share Workout',
                            'Sharing "${challenge.name}" workout summary...',
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
                          Get.off(() => SquatDetectionScreen(challenge: challenge));
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

                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn({
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textCaption,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
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
                width: 1.5,
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
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  void _goHome() {
    if (Get.isRegistered<FitnessProfileController>()) {
      final controller = Get.find<FitnessProfileController>();
      controller.fetchSoloChallenges();
      controller.fetchStatistics();
    }
    if (Get.isRegistered<MainNavController>()) {
      Get.find<MainNavController>().changeTab(0);
    }
    Get.until((route) => route.isFirst);
  }
}
