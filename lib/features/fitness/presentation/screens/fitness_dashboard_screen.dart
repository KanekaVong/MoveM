import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/fitness_profile_controller.dart';
import 'running_tracking_screen.dart';
import 'create_group_screen.dart';
import 'setup_goal_screen.dart';

class FitnessDashboardScreen extends StatelessWidget {
  final FitnessProfileController controller;
  const FitnessDashboardScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopCard(),
              const SizedBox(height: 24),
              _buildCaloriesCard(),
              const SizedBox(height: 16),
              _buildStatsRow(),
              const SizedBox(height: 24),
              const Text('MoveM Club', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildGroupActivity(),
              const SizedBox(height: 24),
              _buildYourGoal(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Solo Challenges', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('see all', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14)),
                ],
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.isLoadingChallenges.value) {
                  return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
                }
                if (controller.soloChallenges.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No trending challenges available', style: TextStyle(color: Colors.white70)),
                    ),
                  );
                }
                return Column(
                  children: controller.soloChallenges.take(5).map((challenge) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: _buildChallengeCard(
                        challenge.name,
                        '${challenge.targetValue} ${challenge.targetUnit} • ${challenge.workoutLevel.replaceAll('_', ' ').toLowerCase().capitalizeFirst ?? challenge.workoutLevel}',
                        '0%',
                        false,
                        Icons.local_fire_department,
                      ),
                    );
                  }).toList(),
                );
              }),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Today's Workout", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),

              const Icon(Icons.directions_run, color: Colors.blueAccent, size: 32),
            ],
          ),
          const SizedBox(height: 32),
          const Text("Small step, big changes\nStart tracking your Fitness Journey with us now", style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCaloriesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0B2B6A),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Calories Burned', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  SizedBox(height: 4),
                  Text('0 kcal', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.bar_chart, color: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildChartBar('Mon', 0.1),
              _buildChartBar('Tue', 0.1),
              _buildChartBar('Wed', 0.1),
              _buildChartBar('Thu', 0.1),
              _buildChartBar('Fri', 0.1),
              _buildChartBar('Sat', 0.1, isActive: true),
              _buildChartBar('Sun', 0.1),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildChartBar(String label, double heightRatio, {bool isActive = false}) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 4,
          decoration: BoxDecoration(
            color: isActive ? Colors.blueAccent : Colors.white,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: isActive ? Colors.blueAccent : Colors.white70, fontSize: 10)),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0B2B6A),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Obx(() {
        final w = controller.profile.value?.weight ?? 0;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem('Weight', '${w}kg'),
            Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
            _buildStatItem('Target weight', '${(w * 0.9).round()}kg'),
            Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
            _buildStatItem('Challenge', '0', showDots: true),
          ],
        );
      }),
    );
  }

  Widget _buildStatItem(String label, String value, {bool showDots = false}) {
    return Column(
      children: [
        if (showDots) const Icon(Icons.more_horiz, color: Colors.white, size: 16),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildGroupActivity() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0B2B6A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.login, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text('Join Club', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Find an active club', style: TextStyle(color: Colors.white70, fontSize: 10)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.to(() => const CreateGroupScreen());
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0B2B6A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text('Create Club', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Create Your Own\nCommunity', style: TextStyle(color: Colors.white70, fontSize: 10)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChallengeCard(String title, String subtitle, String progressText, bool isComplete, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0B2B6A),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
                  color: Colors.black26,
                ),
                child: const Icon(Icons.image, color: Colors.white54, size: 40),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: isComplete ? 1.0 : 0.35,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(progressText, style: const TextStyle(color: Colors.white, fontSize: 10)),
                        const SizedBox(width: 16),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isComplete ? Colors.blueAccent : Colors.transparent),
                color: isComplete ? Colors.transparent : Colors.black12,
              ),
              child: Icon(icon, color: isComplete ? Colors.blueAccent : Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYourGoal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Your Goal', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            Get.to(() => const SetupGoalScreen());
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF0B2B6A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Set Up Your Fitness Goal Now 🔥',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
