import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/dto/response/dashboard_response.dart';

class RemindersSection extends StatelessWidget {
  final List<DashboardReminderItem> reminders;

  const RemindersSection({super.key, required this.reminders});

  @override
  Widget build(BuildContext context) {
    if (reminders.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Upcoming Reminders',
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
                children: reminders.take(3).map((reminder) => Column(
                  children: [
                    _buildReminderItem(
                      _getIconForType(reminder.type ?? ''), 
                      _getColorForType(reminder.type ?? ''), 
                      _formatDate(reminder.remindAt), 
                      _getTitleForType(reminder.type ?? ''), 
                      reminder.type ?? 'Reminder',
                      reminder.sent
                    ),
                    if (reminder != reminders.take(3).last)
                      const Divider(color: Color(0xFF1E293B), indent: 40),
                  ],
                )).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'No Date';
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return DateFormat('MMM d, h:mm a').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  IconData _getIconForType(String type) {
    switch (type.toUpperCase()) {
      case 'DUE_DATE':
        return Icons.event_note;
      case 'FITNESS':
        return Icons.fitness_center;
      default:
        return Icons.notifications;
    }
  }

  Color _getColorForType(String type) {
    switch (type.toUpperCase()) {
      case 'DUE_DATE':
        return const Color(0xFFE28743);
      case 'FITNESS':
        return const Color(0xFF4C8DB3);
      default:
        return const Color(0xFF9B5DE5);
    }
  }

  String _getTitleForType(String type) {
    switch (type.toUpperCase()) {
      case 'DUE_DATE':
        return 'Task Due Soon';
      case 'FITNESS':
        return 'Time for a Workout';
      default:
        return 'Upcoming Reminder';
    }
  }

  Widget _buildReminderItem(IconData icon, Color color, String dateStr, String title, String tag, bool sent) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: sent ? const Color(0xFF1E293B) : color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(4),
          child: Icon(icon, color: sent ? Colors.grey : color, size: 16),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dateStr, style: const TextStyle(color: Color(0xFFA0AAB2), fontSize: 10)),
              const SizedBox(height: 2),
              Text(title, style: TextStyle(color: sent ? Colors.grey : Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: sent ? const Color(0xFF1E293B) : color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(tag, style: TextStyle(color: sent ? Colors.grey : color, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
