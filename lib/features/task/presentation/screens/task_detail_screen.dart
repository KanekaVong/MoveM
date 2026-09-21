import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/task_detail_controller.dart';
import '../../data/dto/response/task_response.dart';
import '../../data/dto/response/checklist_response.dart';
import 'edit_task_screen.dart';
import 'task_comment_screen.dart';
import 'task_activity_feed_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final String activityId;

  const TaskDetailScreen({super.key, required this.activityId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TaskDetailController(activityId: activityId));
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Obx(() {
              if (controller.isLoading && controller.task.value == null) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.taskBluePrimary),
                );
              }

              final task = controller.task.value;
              if (task == null) {
                return Center(
                  child: Text(l10n?.noNotifications ?? 'Task not found', style: const TextStyle(color: AppColors.textPrimary)),
                );
              }

              return Column(
                children: [
                  _buildTopBar(controller, task),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.activityName,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (task.deadline != null && task.deadline!.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'DEADLINES',
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatDate(task.deadline),
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              if (task.priority != null && task.priority!.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'PRIORITY',
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      task.priority!.toUpperCase(),
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
                          if (task.description != null && task.description!.trim().isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Container(
                              height: 0.5,
                              color: AppColors.textPrimary.withOpacity(0.12),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'DESCRIPTION',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              task.description!.trim(),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                height: 1.4,
                              ),
                            ),
                          ],
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
        );
      }

  Widget _buildTopBar(TaskDetailController controller, TaskResponse task) {
    final isLocked = task.isComplete || task.isPastDeadline;
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
                onTap: () {
                  Get.to(() => TaskCommentScreen(
                    activityId: task.activityId,
                    taskTitle: task.activityName,
                  ));
                },
              ),
              const SizedBox(width: 10),
              _buildCircleButton(
                icon: Icons.access_time,
                iconSize: 18,
                onTap: () {
                  Get.to(() => TaskActivityFeedScreen(activityId: task.activityId));
                },
              ),
              if (!isLocked) ...[
                const SizedBox(width: 10),
                _buildCircleButton(
                  icon: Icons.edit_outlined,
                  iconSize: 18,
                  onTap: () {
                    Get.to(() => const EditTaskScreen(), arguments: task)?.then((value) {
                      if (value == true) {
                        controller.fetchTaskDetail(showLoading: false);
                      }
                    });
                  },
                ),
              ],
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
          border: Border.all(color: AppColors.textPrimary.withOpacity(0.24), width: 1),
        ),
        child: Center(
          child: Icon(icon, color: AppColors.textPrimary, size: iconSize),
        ),
      ),
    );
  }

  Widget _buildPropertiesCard(TaskResponse task, TaskDetailController controller) {
    final hasLabels = task.labels != null && task.labels!.isNotEmpty;
    final hasChecklists = task.checklists != null && task.checklists!.isNotEmpty;
    final hasRepeat = task.recurring == true || (task.recurringType != null && task.recurringType!.isNotEmpty);
    final hasReminders = task.reminders != null && task.reminders!.isNotEmpty;
    final hasCollaborators = task.collaborators != null && task.collaborators!.isNotEmpty;
    final hasAttachments = task.attachments != null && task.attachments!.isNotEmpty;

    if (!hasLabels && !hasChecklists && !hasRepeat && !hasReminders && !hasCollaborators && !hasAttachments) {
      return const SizedBox.shrink();
    }

    final List<Widget> sections = [];

    if (hasLabels) {
      sections.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'LABEL',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildLabels(task),
          ],
        ),
      );
    }

    if (hasChecklists) {
      sections.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CHECKLISTS',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            _buildChecklists(task, controller),
          ],
        ),
      );
    }

    if (hasRepeat) {
      sections.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'REPEAT',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              task.recurringType ?? 'RECURRING',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    if (hasReminders) {
      sections.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Your Next Reminder',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            _buildReminderDateView(task),
          ],
        ),
      );
    }

    if (hasCollaborators) {
      sections.add(_buildCollaboratorsSection(task));
    }

    if (hasAttachments) {
      sections.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Attachments   (${task.attachments!.length})',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.keyboard_arrow_up,
                  color: AppColors.textPrimary,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 14),
            _buildAttachments(task),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.textPrimary.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < sections.length; i++) ...[
            sections[i],
            if (i < sections.length - 1) const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildLabels(TaskResponse task) {
    if (task.labels == null || task.labels!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: task.labels!.map((label) {
        Color color;
        try {
          color = Color(int.parse(label.color.replaceFirst('#', '0xFF')));
        } catch (_) {
          color = const Color(0xFF68B684);
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label.name,
            style: const TextStyle(
              color: AppColors.textPrimary,
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
    if (task.checklists == null || task.checklists!.isEmpty) {
      return const SizedBox.shrink();
    }

    final isLocked = task.isComplete || task.isPastDeadline;
    final List<ChecklistResponse> items = task.checklists!.whereType<ChecklistResponse>().toList();

    return Column(
      children: items.map((item) {
        return GestureDetector(
          onTap: isLocked ? null : () => controller.toggleChecklistItem(item.id, item.completed),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.itemName,
                    style: TextStyle(
                      color: isLocked ? AppColors.textSecondary : AppColors.textPrimary,
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
                      color: item.completed ? const Color(0xFF68B684) : AppColors.textSecondary,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(3),
                    color: item.completed ? const Color(0xFF68B684).withOpacity(0.2) : Colors.transparent,
                  ),
                  child: item.completed
                      ? const Icon(Icons.check, size: 14, color: Color(0xFF68B684))
                      : null,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReminderDateView(TaskResponse task) {
    if (task.reminders == null || task.reminders!.isEmpty) {
      return const SizedBox.shrink();
    }

    final rem = task.reminders!.first;
    String dayMonth = '';
    String year = '';
    try {
      final dt = DateTime.parse(rem.remindAt).toLocal();
      dayMonth = _formatDayMonth(dt);
      year = DateFormat('yyyy').format(dt);
    } catch (_) {
      dayMonth = rem.remindAt;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          dayMonth,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (year.isNotEmpty)
          Text(
            year,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _buildCollaboratorsSection(TaskResponse task) {
    final taskCollaborators = task.collaborators ?? [];
    if (taskCollaborators.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Collaborators   (${taskCollaborators.length})',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: taskCollaborators.map((c) {
            final name = c is Map ? (c['name'] ?? c['username'] ?? 'User') : c.toString();
            final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.cardSurface,
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAttachments(TaskResponse task) {
    if (task.attachments == null || task.attachments!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: task.attachments!.map((attachment) {
        String url = '';
        String fileName = 'Attachment';
        if (attachment is Map) {
          url = attachment['url']?.toString() ?? '';
          final orig = attachment['originalFileName'] ?? attachment['fileName'];
          fileName = (orig != null && orig.toString().isNotEmpty)
              ? orig.toString()
              : (attachment['filePath']?.toString() ?? '').split('/').last;
        } else {
          url = attachment.toString();
          fileName = url.split('/').last;
        }
        if (fileName.isEmpty) fileName = 'Attachment';

        final bool hasValidUrl = url.isNotEmpty &&
            (url.startsWith('http://') || url.startsWith('https://'));

        final isImage = fileName.toLowerCase().endsWith('.jpg') ||
            fileName.toLowerCase().endsWith('.jpeg') ||
            fileName.toLowerCase().endsWith('.png') ||
            fileName.toLowerCase().endsWith('.webp') ||
            fileName.toLowerCase().endsWith('.gif');

        if (hasValidUrl && isImage) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                url,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: AppColors.chipSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.06)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.attach_file, color: AppColors.textSecondary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomButton(BuildContext context, TaskResponse task, TaskDetailController controller) {
    final isCompleted = task.status == 'COMPLETE';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: GestureDetector(
        onTap: isCompleted ? null : () => controller.markAsComplete(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isCompleted
                      ? AppColors.textPrimary.withOpacity(0.12)
                      : AppColors.textPrimary.withOpacity(0.35),
                  width: 1.0,
                ),
                gradient: isCompleted
                    ? null
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF4B9D62).withOpacity(0.65),
                          const Color(0xFF4B9D62).withOpacity(0.45),
                          const Color(0xFF357A49).withOpacity(0.55),
                        ],
                      ),
                color: isCompleted ? AppColors.chipSurface : null,
                boxShadow: isCompleted
                    ? null
                    : [
                        BoxShadow(
                          color: const Color(0xFF4B9D62).withOpacity(0.30),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Stack(
                children: [
                  if (!isCompleted)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 24,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                          gradient: LinearGradient(
                            begin: const Alignment(-0.5, -1.0),
                            end: const Alignment(0.5, 1.0),
                            colors: [
                              AppColors.textPrimary.withOpacity(0.28),
                              AppColors.textPrimary.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Center(
                    child: Text(
                      isCompleted ? 'COMPLETED' : 'MARK AS COMPLETE',
                      style: TextStyle(
                        color: isCompleted ? AppColors.textSecondary : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDayMonth(DateTime date) {
    String day = DateFormat('d').format(date);
    String suffix = 'th';
    if (day.endsWith('1') && !day.endsWith('11')) {
      suffix = 'st';
    } else if (day.endsWith('2') && !day.endsWith('12')) {
      suffix = 'nd';
    } else if (day.endsWith('3') && !day.endsWith('13')) {
      suffix = 'rd';
    }
    String paddedDay = day.padLeft(2, '0');
    return '$paddedDay$suffix ${DateFormat('MMMM').format(date)}';
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

  Color _getPriorityColor(String? priority) {
    String p = priority?.toUpperCase() ?? 'LOW';
    if (p == 'LOW') return const Color(0xFF68B684);
    if (p == 'NORMAL' || p == 'MEDIUM') return AppColors.taskYellowPriority;
    if (p == 'HIGH' || p == 'URGENT') return AppColors.taskRedPriority;
    return const Color(0xFF68B684);
  }
}

