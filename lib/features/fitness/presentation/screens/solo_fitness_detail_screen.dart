import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_images.dart';
import '../../data/models/solo_challenge_model.dart';
import '../widgets/notched_card.dart';
import 'push_up_countdown_screen.dart';
import 'running_tracking_screen.dart';

class SoloFitnessDetailScreen extends StatelessWidget {
  final SoloChallengeModel challenge;

  const SoloFitnessDetailScreen({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Hero Section with 3D Push Up Model
                Container(
                  width: double.infinity,
                  height: 340,
                  color: Colors.white,
                  padding: const EdgeInsets.only(top: 60, bottom: 20, left: 24, right: 24),
                  child: Center(
                    child: Image.asset(
                      challenge.heroImagePath.isNotEmpty
                          ? challenge.heroImagePath
                          : AppImages.pushUpHero,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.fitness_center, color: Colors.grey, size: 80),
                      ),
                    ),
                  ),
                ),

                // Dark Bottom Sheet Container
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF091222),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Title & Description + Start Icon Button (replacing Plus icon)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  challenge.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  challenge.description,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    height: 1.45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Start Icon button replacing (+)
                          GestureDetector(
                            onTap: () {
                              Get.to(() => PushUpCountdownScreen(challenge: challenge));
                            },
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF0F1B36),
                                border: Border.all(
                                  color: const Color(0xFF38BDF8),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF38BDF8).withValues(alpha: 0.25),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // More Activity Section
                      const Text(
                        'More Activity',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Running Activity Card
                      _buildRunningCard(context),

                      const SizedBox(height: 14),

                      // Squats Activity Card
                      _buildSquatsCard(context),

                      const SizedBox(height: 36),

                      // Bottom "Start" Action Button
                      GestureDetector(
                        onTap: () {
                          Get.to(() => PushUpCountdownScreen(challenge: challenge));
                        },
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF3E485C),
                                Color(0xFF252E3E),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.play_arrow_outlined,
                                color: Colors.white,
                                size: 22,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Start',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating Back Button
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF8E8E93).withValues(alpha: 0.85),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRunningCard(BuildContext context) {
    return NotchedCard(
      backgroundColor: const Color(0xFF0F1B36),
      borderColor: const Color(0xFF38BDF8).withValues(alpha: 0.4),
      borderWidth: 1.2,
      cornerRadius: 18,
      actionIcon: Icons.play_arrow_rounded,
      actionButtonBorderColor: const Color(0xFF38BDF8),
      onTap: () {
        Get.to(() => const RunningTrackingScreen());
      },
      onActionTap: () {
        Get.to(() => const RunningTrackingScreen());
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                AppImages.runningActivity,
                width: 80,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 72,
                  color: Colors.black26,
                  child: const Icon(Icons.directions_run, color: Colors.white70),
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Running',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 48), // Padding for top-right notch
          ],
        ),
      ),
    );
  }

  Widget _buildSquatsCard(BuildContext context) {
    return NotchedCard(
      backgroundColor: const Color(0xFF0F1B36),
      borderColor: const Color(0xFF38BDF8).withValues(alpha: 0.4),
      borderWidth: 1.2,
      cornerRadius: 18,
      actionIcon: Icons.play_arrow_rounded,
      actionButtonBorderColor: const Color(0xFF38BDF8),
      onTap: () {
        Get.snackbar(
          'Squats Activity',
          'Starting 10 minutes a day squats routine...',
          backgroundColor: const Color(0xFF0F1B36),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      onActionTap: () {
        Get.snackbar(
          'Squats Activity',
          'Starting 10 minutes a day squats routine...',
          backgroundColor: const Color(0xFF0F1B36),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  AppImages.squatsActivity,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.accessibility_new, color: Colors.blueAccent),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Squats',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '10 minutes a day',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 48), // Padding for top-right notch
          ],
        ),
      ),
    );
  }
}
