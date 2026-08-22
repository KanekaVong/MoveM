import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/dto/response/dashboard_response.dart';

class UpcomingSection extends StatelessWidget {
  final List<DashboardTaskItem>? tasks;

  const UpcomingSection({super.key, this.tasks});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Upcoming',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF131B2F),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1E293B), width: 1),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 11, // centers the line with the icons (icon width is 24)
                top: 20,
                bottom: 20,
                child: Container(
                  width: 1,
                  color: const Color(0xFF2C3E50),
                ),
              ),
              Column(
                children: [
                  if (tasks != null && tasks!.isNotEmpty)
                    ...tasks!.take(5).toList().asMap().entries.map((entry) {
                      final index = entry.key;
                      final task = entry.value;
                      return Column(
                        children: [
                          _buildUpcomingItem(Icons.assignment, const Color(0xFF4C8DB3), _formatDate(task.deadline), task.activityName, 'Task', showIcon: index == 0),
                          const Divider(color: Color(0xFF1E293B), indent: 40),
                        ],
                      );
                    }).toList()
                  else ...[
                    _buildUpcomingItem(Icons.assignment, const Color(0xFF4C8DB3), 'No Due Date', 'No Task Yet', 'Task', showIcon: true),
                    const Divider(color: Color(0xFF1E293B), indent: 40),
                  ],
                  _buildUpcomingItem(Icons.fitness_center, const Color(0xFFE28743), 'No Date', 'No Challenges', 'Fitness', showIcon: true),
                  const Divider(color: Color(0xFF1E293B), indent: 40),
                  _buildUpcomingItem(Icons.luggage, const Color(0xFF9B5DE5), 'No Date', 'No Trip Plan', 'Trips', showIcon: true),
                ],
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

  Widget _buildUpcomingItem(IconData icon, Color color, String dateStr, String title, String tag, {bool showIcon = true}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showIcon 
          ? Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: Icon(icon, color: color, size: 16),
            )
          : Container(
              margin: const EdgeInsets.only(top: 4),
              width: 24,
              height: 24,
              alignment: Alignment.center,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF131B2F), width: 2), // to create a gap from the line
                ),
              ),
            ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dateStr, style: const TextStyle(color: Color(0xFFA0AAB2), fontSize: 10)),
              const SizedBox(height: 2),
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(tag, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
