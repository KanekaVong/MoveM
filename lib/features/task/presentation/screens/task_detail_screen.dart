import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/task_detail_controller.dart';
import '../../data/dto/response/task_response.dart';
import 'edit_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final String activityId;

  const TaskDetailScreen({super.key, required this.activityId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TaskDetailController(activityId: activityId));

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [

          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=1200&auto=format&fit=crop',
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    const Color(0xFF0F172A).withOpacity(0.8),
                    const Color(0xFF0F172A),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Obx(() {
              if (controller.isLoading && controller.task.value == null) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF3B82F6)));
              }

              final task = controller.task.value;
              if (task == null) {
                return const Center(child: Text('Task not found', style: TextStyle(color: Colors.white)));
              }

              return Column(
                children: [
                  _buildAppBar(controller),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('DEADLINES'),
                          const SizedBox(height: 8),
                          Text(
                            _formatDate(task.deadline),
                            style: const TextStyle(color: Color(0xFF475569), fontSize: 12, fontStyle: FontStyle.italic),
                          ),
                          _buildDivider(),

                          _buildSectionTitle('PRIORITY'),
                          const SizedBox(height: 8),
                          Text(
                            task.priority?.toUpperCase() ?? 'LOW',
                            style: TextStyle(
                              color: _getPriorityColor(task.priority),
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildDivider(),

                          _buildSectionTitle('DESCRIPTION'),
                          const SizedBox(height: 8),
                          Text(
                            task.description ?? 'No description provided',
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontStyle: FontStyle.italic, height: 1.5),
                          ),
                          _buildDivider(),

                          Container(
                            padding: const EdgeInsets.all(24.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white.withOpacity(0.1)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('LABEL'),
                                const SizedBox(height: 12),
                                _buildLabels(task),
                                const SizedBox(height: 32),

                                _buildSectionTitle('CHECKLISTS'),
                                const SizedBox(height: 16),
                                _buildChecklists(task),
                                const SizedBox(height: 32),

                                _buildSectionTitle('REPEAT'),
                                const SizedBox(height: 8),
                                Text(
                                  task.recurringType ?? (task.recurring ? 'YES' : 'NONE'),
                                  style: const TextStyle(color: Color(0xFF475569), fontSize: 12, fontStyle: FontStyle.italic),
                                ),
                                const SizedBox(height: 48),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Your Next Reminder',
                                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      _getNextReminderDate(task),
                                      style: const TextStyle(color: Color(0xFF475569), fontSize: 12, fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: task.status == 'COMPLETE' ? null : () => controller.markAsComplete(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4ADE80),
                          disabledBackgroundColor: const Color(0xFF1E293B),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          task.status == 'COMPLETE' ? 'Completed' : 'Mark Task as Complete',
                          style: TextStyle(
                            color: task.status == 'COMPLETE' ? const Color(0xFF64748B) : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(TaskDetailController controller) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Obx(() {
                final task = controller.task.value;
                return Text(
                  task?.activityName ?? 'Task Details',
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              }),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
            ),
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.white, size: 20),
              onPressed: () {
                if (controller.task.value != null) {
                  Get.to(() => const EditTaskScreen(), arguments: controller.task.value)?.then((value) {
                    if (value == true) {
                      controller.fetchTaskDetail(showLoading: false);
                    }
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        height: 1,
        color: Colors.white.withOpacity(0.1),
      ),
    );
  }

  Widget _buildLabels(TaskResponse task) {
    if (task.labels == null || task.labels!.isEmpty) {
      return const Text('No labels', style: TextStyle(color: Color(0xFF64748B), fontSize: 14, fontStyle: FontStyle.italic));
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: task.labels!.map((label) {
        final color = Color(int.parse(label.color.replaceFirst('#', '0xFF')));
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            label.name,
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChecklists(TaskResponse task) {
    if (task.checklists == null || task.checklists!.isEmpty) {
      return const Text('No checklists', style: TextStyle(color: Color(0xFF475569), fontSize: 12, fontStyle: FontStyle.italic));
    }

    final controller = Get.find<TaskDetailController>();

    return Column(
      children: task.checklists!.map((item) {
        return GestureDetector(
          onTap: () => controller.toggleChecklistItem(item.id, item.completed),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    item.itemName,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: item.completed
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Not set';
    try {
      final date = DateTime.parse(dateStr).toLocal();
      String day = DateFormat('d').format(date);
      String suffix = 'th';
      if (day.endsWith('1') && !day.endsWith('11')) suffix = 'st';
      else if (day.endsWith('2') && !day.endsWith('12')) suffix = 'nd';
      else if (day.endsWith('3') && !day.endsWith('13')) suffix = 'rd';

      return '$day$suffix ${DateFormat('MMMM yyyy').format(date)}';
    } catch (_) {
      return dateStr;
    }
  }

  String _getNextReminderDate(TaskResponse task) {
    if (task.reminders != null && task.reminders!.isNotEmpty) {

      final reminder = task.reminders!.first;
      return _formatDate(reminder.remindAt);
    }
    return 'None';
  }

  Color _getPriorityColor(String? priority) {
    String p = priority?.toUpperCase() ?? 'LOW';
    if (p == 'LOW') return const Color(0xFF4ADE80);
    if (p == 'NORMAL') return const Color(0xFFFACC15);
    if (p == 'HIGH' || p == 'URGENT') return const Color(0xFFF87171);
    return Colors.white;
  }
}
