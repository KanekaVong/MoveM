import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/dto/response/dashboard_response.dart';

class OngoingSection extends StatelessWidget {
  final List<DashboardTaskItem>? tasks;
  final FitnessStatistics? fitnessStats;

  const OngoingSection({super.key, this.tasks, this.fitnessStats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n?.ongoingTasks ?? 'Ongoing',
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text(l10n?.viewAll ?? 'View All', style: const TextStyle(color: Colors.white, fontSize: 12)),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 10),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              if (tasks != null && tasks!.isNotEmpty)
                ...tasks!.take(5).map((task) => Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: _buildOngoingCard(
                    'https://images.unsplash.com/photo-1498050108023-c5249f4df085?q=80&w=600&auto=format&fit=crop',
                    const Color(0xFF4C8DB3),
                    Icons.check_box,
                    'Task',
                    task.activityName,
                    task.priority,
                    task.deadline != null ? _formatDate(task.deadline) : 'No Due Date',
                    progress: 0,
                  ),
                ))
              else
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: _buildOngoingCard(
                    'https://images.unsplash.com/photo-1498050108023-c5249f4df085?q=80&w=600&auto=format&fit=crop',
                    const Color(0xFF4C8DB3),
                    Icons.check_box,
                    'Task',
                    'Create A New Task',
                    '',
                    'No Due Date',
                  ),
                ),
              Builder(
                builder: (context) {
                  MetricGoal? stepGoal;
                  if (fitnessStats != null && fitnessStats!.metricGoals != null) {
                    try {
                      stepGoal = fitnessStats!.metricGoals!.firstWhere((goal) => goal.metricType == 'DAILY_STEPS');
                    } catch (_) {}
                  }

                  final current = stepGoal?.current ?? 0;
                  final target = stepGoal?.target ?? 5000;
                  final progress = (stepGoal?.progressPercent != null) ? (stepGoal!.progressPercent * 100).toInt() : 0;

                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: _buildOngoingCard(
                      'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?q=80&w=600&auto=format&fit=crop',
                      const Color(0xFFE28743),
                      Icons.directions_run,
                      'Fitness',
                      'Daily Steps Goal',
                      '$current / $target',
                      'Steps',
                      progress: progress,
                    ),
                  );
                }
              ),
              _buildOngoingCard(
                'https://images.unsplash.com/photo-1542281286-9e0a16bb7366?q=80&w=600&auto=format&fit=crop',
                const Color(0xFF9B5DE5),
                Icons.flight,
                'Trip Plans',
                'Set Up Your Trip Plans',
                '0 Days left',
                'Until Your Next Trip',
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'No Due Date';
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return DateFormat('MMM d, h:mm a').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildOngoingCard(String imageUrl, Color tintColor, IconData icon, String type, String title, String mainStat, String subStat, {int progress = 0}) {
    return Container(
      width: 160,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: CachedNetworkImageProvider(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              tintColor.withValues(alpha: 0.6),
              tintColor.withValues(alpha: 0.8),
            ],
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(type, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            if (mainStat.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(mainStat, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
            if (subStat.isNotEmpty)
              Text(subStat, style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 10)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Text('Start', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 10),
                  ],
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                  ),
                  child: Center(
                    child: Text('$progress%', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
