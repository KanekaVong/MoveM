import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/dto/response/dashboard_response.dart';

class UpcomingSection extends StatelessWidget {
  final List<DashboardTaskItem>? tasks;
  final FitnessStatistics? fitnessStats;

  const UpcomingSection({
    super.key,
    this.tasks,
    this.fitnessStats,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final taskCount = tasks?.length ?? 0;
    final fitnessCount = fitnessStats?.totalWorkouts ?? 0;
    const tripCount = 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n?.upcoming ?? 'Upcoming',
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF131B2F),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1E293B), width: 1),
          ),
          child: Column(
            children: [
              _buildUpcomingCountItem(
                icon: Icons.assignment,
                color: const Color(0xFF4C8DB3),
                title: '$taskCount ${taskCount == 1 ? (l10n?.task ?? 'task') : (l10n?.allTasks ?? 'tasks')}',
                subtitle: taskCount > 0 ? (l10n?.ongoingTasks ?? 'Upcoming due soon') : (l10n?.noNotifications ?? 'No upcoming tasks'),
                tag: l10n?.task ?? 'Task',
              ),
              const Divider(color: Color(0xFF1E293B), height: 28),
              _buildUpcomingCountItem(
                icon: Icons.fitness_center,
                color: const Color(0xFFE28743),
                title: '$fitnessCount ${l10n?.soloChallenges ?? 'challenges'}',
                subtitle: fitnessCount > 0 ? (l10n?.soloChallenges ?? 'Active challenges') : (l10n?.noNotifications ?? 'No challenges'),
                tag: l10n?.fitness ?? 'Fitness',
              ),
              const Divider(color: Color(0xFF1E293B), height: 28),
              _buildUpcomingCountItem(
                icon: Icons.luggage,
                color: const Color(0xFF9B5DE5),
                title: '$tripCount ${l10n?.trip ?? 'trips'}',
                subtitle: tripCount > 0 ? (l10n?.trip ?? 'Upcoming itinerary') : (l10n?.noNotifications ?? 'No trip plan'),
                tag: l10n?.trip ?? 'Trips',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingCountItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String tag,
  }) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.18),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFFA0AAB2),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            tag,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
