import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/task_detail_controller.dart';
import '../../data/dto/response/task_response.dart';
import 'edit_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final String activityId;

  const TaskDetailScreen({super.key, required this.activityId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TaskDetailController(activityId: activityId));
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.taskDarkBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppImages.taskDetailBackground,
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
                    Colors.black.withOpacity(0.35),
                    AppColors.taskDarkBackground.withOpacity(0.65),
                    AppColors.taskDarkBackground.withOpacity(0.9),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Obx(() {
              if (controller.isLoading && controller.task.value == null) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.taskBluePrimary),
                );
              }

              final task = controller.task.value;
              if (task == null) {
                return Center(
                  child: Text(l10n?.noNotifications ?? 'Task not found', style: const TextStyle(color: Colors.white)),
                );
              }

              return Column(
                children: [
                  _buildTopBar(controller),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.activityName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'DEADLINES',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatDate(task.deadline),
                                    style: const TextStyle(
                                      color: AppColors.taskTextMuted,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'PRIORITY',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    task.priority?.toUpperCase() ?? 'LOW',
                                    style: TextStyle(
                                      color: _getPriorityColor(task.priority),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 0.5,
                            color: Colors.white.withOpacity(0.12),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'DESCRIPTION',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            task.description ?? 'No description provided',
                            style: const TextStyle(
                              color: AppColors.taskTextBody,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildPropertiesCard(task, controller),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomButton(context, task, controller),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(TaskDetailController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCircleButton(
            icon: Icons.chevron_left,
            iconSize: 22,
            onTap: () => Get.back(),
          ),
          Row(
            children: [
              _buildCircleButton(
                icon: Icons.chat_bubble_outline,
                iconSize: 18,
                onTap: () {},
              ),
              const SizedBox(width: 10),
              _buildCircleButton(
                icon: Icons.access_time,
                iconSize: 18,
                onTap: () {},
              ),
              const SizedBox(width: 10),
              _buildCircleButton(
                icon: Icons.edit_outlined,
                iconSize: 18,
                onTap: () {
                  if (controller.task.value != null) {
                    Get.to(() => const EditTaskScreen(), arguments: controller.task.value)?.then((value) {
                      if (value == true) {
                        controller.fetchTaskDetail(showLoading: false);
                      }
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    double iconSize = 18,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0x33000000),
          border: Border.all(color: Colors.white.withOpacity(0.24), width: 1),
        ),
        child: Center(
          child: Icon(icon, color: Colors.white, size: iconSize),
        ),
      ),
    );
  }

  Widget _buildPropertiesCard(TaskResponse task, TaskDetailController controller) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.taskFigmaCard.withOpacity(0.20),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => controller.toggleCardExpanded(),
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'LABEL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(() => Icon(
                  controller.isCardExpanded.value
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white70,
                  size: 20,
                )),
              ],
            ),
          ),
          Obx(() {
            if (!controller.isCardExpanded.value) return const SizedBox();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildLabels(task),
                const SizedBox(height: 22),
                if (task.checklists != null && task.checklists!.isNotEmpty) ...[
                  Row(
                    children: const [
                      Text(
                        'CHECKLIST',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.add, color: Colors.white, size: 14),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildChecklists(task, controller),
                  const SizedBox(height: 22),
                ],
                const Text(
                  'REPEAT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  task.recurringType ?? (task.recurring ? 'YES' : 'NONE'),
                  style: const TextStyle(
                    color: AppColors.taskTextMuted,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Your Next Reminder',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.calendar_today_outlined, color: Colors.white70, size: 14),
                      ],
                    ),
                    Text(
                      _getNextReminderDate(task),
                      style: const TextStyle(
                        color: AppColors.taskTextMuted,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                if (task.collaborators != null && task.collaborators!.isNotEmpty) ...[
                  const SizedBox(height: 22),
                  Text(
                    'Collaborators (${task.collaborators!.length})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildCollaborators(task),
                ],
                if (task.attachments != null && task.attachments!.isNotEmpty) ...[
                  const SizedBox(height: 22),
                  GestureDetector(
                    onTap: () => controller.toggleAttachmentsExpanded(),
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Attachments (${task.attachments!.length})',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Obx(() => Icon(
                          controller.isAttachmentsExpanded.value
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white70,
                          size: 20,
                        )),
                      ],
                    ),
                  ),
                  Obx(() {
                    if (!controller.isAttachmentsExpanded.value) return const SizedBox();
                    return Column(
                      children: [
                        const SizedBox(height: 12),
                        _buildAttachments(task),
                      ],
                    );
                  }),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLabels(TaskResponse task) {
    if (task.labels == null || task.labels!.isEmpty) {
      return const Text(
        'No labels',
        style: TextStyle(
          color: AppColors.taskTextSecondary,
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: task.labels!.map((label) {
        Color color;
        try {
          color = Color(int.parse(label.color.replaceFirst('#', '0xFF')));
        } catch (_) {
          color = AppColors.taskBluePrimary;
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: color.withOpacity(0.65),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChecklists(TaskResponse task, TaskDetailController controller) {
    return Column(
      children: task.checklists!.map((item) {
        return GestureDetector(
          onTap: () => controller.toggleChecklistItem(item.id, item.completed),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.itemName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: item.completed ? AppColors.taskGreenAccent : AppColors.taskTextSecondary,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(3),
                    color: item.completed ? AppColors.taskGreenAccent.withOpacity(0.2) : Colors.transparent,
                  ),
                  child: item.completed
                      ? const Icon(Icons.check, size: 14, color: AppColors.taskGreenAccent)
                      : null,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCollaborators(TaskResponse task) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: task.collaborators!.map((collaborator) {
        final name = collaborator is Map
            ? (collaborator['name'] ?? collaborator['username'] ?? 'User')
            : collaborator.toString();
        final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.taskAvatarBg,
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(
                color: AppColors.taskTextMuted,
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildAttachments(TaskResponse task) {
    return Column(
      children: task.attachments!.map((attachment) {
        final url = attachment is Map
            ? (attachment['url'] ?? attachment['fileUrl'] ?? '')
            : attachment.toString();
        if (url.isEmpty) return const SizedBox();
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              url,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 100,
                color: AppColors.taskSlateDark,
                child: const Center(
                  child: Icon(Icons.insert_drive_file, color: Colors.white54, size: 36),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomButton(BuildContext context, TaskResponse task, TaskDetailController controller) {
    final l10n = AppLocalizations.of(context);
    final isCompleted = task.status == 'COMPLETE';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: isCompleted ? null : () => controller.markAsComplete(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.taskGreenButton,
            disabledBackgroundColor: AppColors.taskSlateDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
          ),
          child: Text(
            isCompleted ? (l10n?.completedTasks ?? 'Completed') : (l10n?.finish ?? 'Mark Task as Complete'),
            style: TextStyle(
              color: isCompleted ? AppColors.taskTextSecondary : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'Not set';
    try {
      final date = DateTime.parse(dateStr).toLocal();
      String day = DateFormat('d').format(date);
      String suffix = 'th';
      if (day.endsWith('1') && !day.endsWith('11')) {
        suffix = 'st';
      } else if (day.endsWith('2') && !day.endsWith('12')) {
        suffix = 'nd';
      } else if (day.endsWith('3') && !day.endsWith('13')) {
        suffix = 'rd';
      }

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
    if (p == 'LOW') return AppColors.taskGreenAccent;
    if (p == 'NORMAL' || p == 'MEDIUM') return AppColors.taskYellowPriority;
    if (p == 'HIGH' || p == 'URGENT') return AppColors.taskRedPriority;
    return AppColors.taskGreenAccent;
  }
}
