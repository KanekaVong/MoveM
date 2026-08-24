import 'package:flutter/material.dart';
import '../../data/dto/response/dashboard_response.dart';

class TodaysProgressCard extends StatelessWidget {
  final FitnessStatistics? fitnessStats;

  const TodaysProgressCard({super.key, this.fitnessStats});

  MetricGoal? _getGoal(String type) {
    if (fitnessStats?.metricGoals == null) return null;
    try {
      return fitnessStats!.metricGoals!.firstWhere((goal) => goal.metricType == type);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final stepsGoal = _getGoal('DAILY_STEPS');
    final stepsTarget = stepsGoal?.target.toInt() ?? 10000;
    final stepsProgress = stepsGoal?.progressPercent ?? ((fitnessStats?.stepsToday ?? 0) / stepsTarget);

    final calsGoal = _getGoal('DAILY_CALORIES');
    final calsTarget = calsGoal?.target.toInt() ?? 2000;
    final calsProgress = calsGoal?.progressPercent ?? ((fitnessStats?.caloriesToday ?? 0) / calsTarget);

    final workoutsGoal = _getGoal('DAILY_WORKOUTS');
    final workoutsProgress = workoutsGoal?.progressPercent ?? 
        ((fitnessStats?.workoutsThisWeek ?? 1) > 0 ? (fitnessStats?.workoutsToday ?? 0) / (fitnessStats?.workoutsThisWeek ?? 1) : 0.0);

    final List<double> progresses = [
      workoutsProgress.clamp(0.0, 1.0),
      stepsProgress.clamp(0.0, 1.0),
      calsProgress.clamp(0.0, 1.0),
    ];
    final overallProgress = progresses.reduce((a, b) => a + b) / progresses.length;
    final overallProgressPercent = (overallProgress * 100).toInt();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2F), // Dark card background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Progress",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildProgressStat(Icons.check_box, const Color(0xFF4C8DB3), '${fitnessStats?.workoutsToday ?? 0} / ${fitnessStats?.workoutsThisWeek ?? 0}', 'Workouts (Today/Week)', workoutsProgress)),
              Container(width: 1, height: 60, color: const Color(0xFF1E293B), margin: const EdgeInsets.symmetric(horizontal: 10)),
              Expanded(child: _buildProgressStat(Icons.directions_run, const Color(0xFFE28743), '${fitnessStats?.stepsToday ?? 0} / $stepsTarget', 'Steps Today', stepsProgress)),
              Container(width: 1, height: 60, color: const Color(0xFF1E293B), margin: const EdgeInsets.symmetric(horizontal: 10)),
              Expanded(child: _buildProgressStat(Icons.local_fire_department, const Color(0xFF9B5DE5), '${fitnessStats?.caloriesToday?.toStringAsFixed(0) ?? 0}', 'Calories', calsProgress)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Overall Progress', style: TextStyle(color: Colors.white, fontSize: 12)),
                    const SizedBox(height: 8),
                    Stack(
                      children: [
                        Container(
                          height: 4,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: overallProgress.clamp(0.0, 1.0),
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4C8DB3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$overallProgressPercent%',
                style: const TextStyle(color: Color(0xFF4C8DB3), fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat(IconData icon, Color color, String value, String label, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 12),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Color(0xFFA0AAB2), fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 3,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress.isNaN ? 0.0 : progress.clamp(0.0, 1.0),
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
