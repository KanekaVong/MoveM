import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/dto/response/dashboard_response.dart';

class OverdueSection extends StatelessWidget {
  final List<DashboardTaskItem> tasks;

  const OverdueSection({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Overdue',
              style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Text('View All', style: TextStyle(color: Colors.white, fontSize: 12)),
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
            children: tasks.take(5).map((task) => Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: _buildOverdueCard(
                'https://images.unsplash.com/photo-1584438784894-089d6a62b8fa?q=80&w=600&auto=format&fit=crop', // urgent/time related placeholder
                const Color(0xFFD32F2F), // Red tint for overdue
                Icons.warning_amber_rounded,
                'Overdue Task',
                task.activityName,
                task.priority,
                task.deadline != null ? task.deadline! : 'Unknown Deadline',
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildOverdueCard(String imageUrl, Color tintColor, IconData icon, String type, String title, String mainStat, String subStat) {
    return Container(
      width: 160,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: CachedNetworkImageProvider(imageUrl),
          fit: BoxFit.cover,
        ),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5), width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              tintColor.withValues(alpha: 0.7),
              tintColor.withValues(alpha: 0.9),
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
              Text(subStat, style: const TextStyle(color: Color(0xFFFFCDD2), fontSize: 10)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Text('Resolve', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 10),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
