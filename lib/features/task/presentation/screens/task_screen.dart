import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../shared/widgets/custom_image.dart';
import 'create_task_screen.dart';

import '../controllers/task_controller.dart';
import 'package:intl/intl.dart';

class TaskScreen extends GetView<TaskController> {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TaskController());
    
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF3B82F6)));
        }
        
        return CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Progress',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCreateTaskBanner(),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: _buildCompletedTasksCard(),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              _buildMiniCard('Upcoming Tasks', '${controller.upcomingTasksCount}'),
                              const SizedBox(height: 16),
                              _buildMiniCard('On-Going Tasks', '${controller.ongoingTasksCount}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'All Tasks',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTaskList(),
                    const SizedBox(height: 100), // Padding for bottom nav
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 280,
      backgroundColor: const Color(0xFF0F172A),
      pinned: true,
      actions: [
        const Padding(
          padding: EdgeInsets.only(right: 24.0, top: 8.0),
          child: CircleAvatar(
            radius: 18,
            backgroundImage: CachedNetworkImageProvider('https://images.unsplash.com/photo-1543852786-1cf6624b9987?q=80&w=200&auto=format&fit=crop'), // Placeholder leopard
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=1200&auto=format&fit=crop', // Snowy mountain night
              fit: BoxFit.cover,
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black45,
                    Color(0xFF0F172A),
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
            const Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Ready To Elevate Your\nTask To Another Level?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFE2E8F0),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateTaskBanner() {
    return GestureDetector(
      onTap: () {
        Get.to(() => const CreateTaskScreen())?.then((_) => controller.fetchTasks());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2F),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Create Task', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                SizedBox(height: 4),
                Text('Let your brain relax, put it here.', style: TextStyle(color: Color(0xFFA0AAB2), fontSize: 10, fontStyle: FontStyle.italic)),
              ],
            ),
            const Icon(Icons.add, color: Colors.white, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedTasksCard() {
    final total = controller.tasks.length;
    final completed = controller.completedTasksCount;
    final progress = total > 0 ? completed / total : 0.0;
    
    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Completed Tasks', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
          const Spacer(),
          Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: const Color(0xFF1E293B),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$completed', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        const Text('Completed', style: TextStyle(color: Color(0xFFA0AAB2), fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildMiniCard(String title, String subtitle) {
    return Container(
      width: double.infinity,
      height: 82,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
          const SizedBox(height: 8),
          Center(child: Text(subtitle, style: const TextStyle(color: Color(0xFFA0AAB2), fontSize: 12, fontStyle: FontStyle.italic))),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    if (controller.tasks.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text(
            'Empty',
            style: TextStyle(color: Color(0xFF334155), fontSize: 32, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.tasks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final task = controller.tasks[index];
        return _buildTaskTile(task);
      },
    );
  }

  Widget _buildTaskTile(dynamic task) {
    // Format deadline
    String formattedDate = 'Not set';
    if (task.deadline != null) {
      try {
        final date = DateTime.parse(task.deadline!);
        
        // Format with ordinal suffix (st, nd, rd, th)
        String day = DateFormat('d').format(date.toLocal());
        String suffix = 'th';
        if (day.endsWith('1') && !day.endsWith('11')) {
          suffix = 'st';
        } else if (day.endsWith('2') && !day.endsWith('12')) {
          suffix = 'nd';
        } else if (day.endsWith('3') && !day.endsWith('13')) {
          suffix = 'rd';
        }
        
        formattedDate = '$day$suffix ${DateFormat('MMMM yyyy').format(date.toLocal())}';
      } catch (_) {}
    }

    // Determine priority color
    Color priorityColor = Colors.grey;
    Color priorityBgColor = const Color(0xFF1E293B);
    String priorityText = task.priority ?? 'Low';
    
    if (priorityText.toUpperCase() == 'LOW') {
      priorityColor = const Color(0xFF65A30D); // Green
      priorityBgColor = const Color(0xFF1A2E20); // Dark Green
    } else if (priorityText.toUpperCase() == 'NORMAL') {
      priorityColor = const Color(0xFFEAB308); // Yellow
      priorityBgColor = const Color(0xFF422006); // Dark Yellow/Brown
    } else if (priorityText.toUpperCase() == 'HIGH' || priorityText.toUpperCase() == 'URGENT') {
      priorityColor = const Color(0xFFEF4444); // Red
      priorityBgColor = const Color(0xFF450A0A); // Dark Red
    }

    // Left indicator color (Orange in screenshot, maybe based on status)
    Color indicatorColor = task.status == 'COMPLETE' ? const Color(0xFF22C55E) : const Color(0xFFF97316);

    double progression = 0.0;
    if (task.totalChecklistItems != null && task.totalChecklistItems > 0) {
      progression = task.completedChecklistItems / task.totalChecklistItems;
    } else if (task.checklistProgress != null) {
      progression = task.checklistProgress;
    } else if (task.status == 'COMPLETE') {
      progression = 1.0;
    }
    int progressionPercent = (progression * 100).toInt();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side indicator
              Container(
                width: 6,
                height: 48,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.activityName,
                      style: TextStyle(
                        color: task.status == 'COMPLETE' ? const Color(0xFFA0AAB2) : Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        decoration: task.status == 'COMPLETE' ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                          decoration: BoxDecoration(
                            color: priorityBgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            priorityText.toLowerCase().capitalizeFirst ?? priorityText,
                            style: TextStyle(
                              color: priorityColor,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Dateline : $formattedDate',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Icon Container
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF131B2F), // Same as bg, using border to give depth
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2A344A), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: const Icon(
                  Icons.assignment_outlined,
                  color: Color(0xFF3B82F6),
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Progress bar track
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B), // Dark track
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: Colors.black.withValues(alpha: 0.5), width: 0.5),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: progressionPercent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                Expanded(
                  flex: 100 - progressionPercent,
                  child: const SizedBox(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Progression : $progressionPercent%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
