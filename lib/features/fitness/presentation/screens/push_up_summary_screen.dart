import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_images.dart';
import '../../data/models/push_up_session_model.dart';
import '../../data/models/solo_challenge_model.dart';
import '../controllers/fitness_profile_controller.dart';
import 'push_up_countdown_screen.dart';

class PushUpSummaryScreen extends StatelessWidget {
  final PushUpSession session;
  final SoloChallengeModel challenge;

  const PushUpSummaryScreen({
    super.key,
    required this.session,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    final duration = session.duration;
    final totalMinutes = duration.inMinutes;
    final durationDisplay = totalMinutes >= 1
        ? '$totalMinutes MINS'
        : '${duration.inSeconds} SECS';

    final calories = session.caloriesBurned > 0
        ? session.caloriesBurned
        : (challenge.calories > 0 ? challenge.calories : 120);

    final completedSets = (session.totalReps / challenge.repsPerSet).ceil();
    final setsDisplay = '${completedSets > 0 ? completedSets.clamp(1, challenge.sets) : challenge.sets} / ${challenge.sets}';

    final isAllCompleted = session.isCompleted || session.totalReps >= (challenge.sets * challenge.repsPerSet);

    return Scaffold(
      backgroundColor: const Color(0xFF09101F),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Top Hero Section with Gym Athlete Image
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 320,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                      child: Image.asset(
                        AppImages.workoutDetailsHero,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          AppImages.pushUpCard,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Dark gradient scrim
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
                            const Color(0xFF09101F).withValues(alpha: 0.9),
                            const Color(0xFF09101F),
                          ],
                          stops: const [0.0, 0.4, 0.85, 1.0],
                        ),
                      ),
                    ),

                    // Top Bar (Back Button + Workout Details Title)
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () => _goHome(),
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withValues(alpha: 0.45),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.25),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              'Workout Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
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

                // 3 Stats Metrics Row [ SET | CALORIES | DURATIONS ]
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // SET
                      _buildMetricColumn(
                        label: 'SET',
                        value: '$setsDisplay 💪',
                      ),

                      // CALORIES
                      _buildMetricColumn(
                        label: 'CALORIES',
                        value: '$calories 🔥',
                      ),

                      // DURATIONS
                      _buildMetricColumn(
                        label: 'DURATIONS',
                        value: durationDisplay,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // Challenge Section
                Column(
                  children: [
                    const Text(
                      'CHALLENGE',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      challenge.name.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
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

                // 4 Action Icons Row [ SHARE | REDO | FITNESS | HOME ]
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Share Action
                      _buildCircleActionButton(
                        icon: Icons.share_outlined,
                        label: 'SHARE',
                        onTap: () {
                          Get.snackbar(
                            'Share Workout',
                            'Sharing "${challenge.name}" workout summary...',
                            backgroundColor: const Color(0xFF0F1B36),
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                      ),

                      // Redo Action
                      _buildCircleActionButton(
                        icon: Icons.replay_rounded,
                        label: 'REDO',
                        onTap: () {
                          Get.off(() => PushUpCountdownScreen(challenge: challenge));
                        },
                      ),

                      // Fitness / Detail Action
                      _buildCircleActionButton(
                        icon: Icons.fitness_center_rounded,
                        label: 'FITNESS',
                        onTap: () {
                          _goHome();
                        },
                      ),

                      // Home Action
                      _buildCircleActionButton(
                        icon: Icons.home_outlined,
                        label: 'HOME',
                        onTap: () {
                          _goHome();
                        },
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
            color: Colors.white60,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
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
                color: Colors.white.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
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
    }
    Get.back();
  }
}
