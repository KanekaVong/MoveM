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
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/top_tool_bar.dart';

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
                return Center(
                  child: CircularProgressIndicator(color: AppColors.taskBluePrimary),
                );
              }

              final task = controller.task.value;
              if (task == null) {
                return Center(
                  child: Text(l10n?.noNotifications ?? 'Task not found', style: TextStyle(color: AppColors.textPrimary)),
                );
              }

              return Column(
                children: [
                  _buildTopBar(controller, task),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.activityName,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
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
                                    Text(
                                      'DEADLINES',
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      _formatDate(task.deadline),
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              if (task.priority != null && task.priority!.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n?.priorityLabel ?? 'PRIORITY',
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
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          if (task.description != null && task.description!.trim().isNotEmpty) ...[
                            SizedBox(height: 12),
                            Container(
                              height: 0.5,
                              color: AppColors.textPrimary.withOpacity(0.12),
                            ),
                            SizedBox(height: 12),
                            Text(
                              l10n?.descriptionLabel ?? 'DESCRIPTION',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              task.description!.trim(),
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 12,
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
    return TopToolBar(
      title: task.activityName,
      actions: [
        TopToolBarAction(
          icon: Icons.chat_bubble_outline,
          onTap: () {
            Get.to(() => TaskCommentScreen(
              activityId: task.activityId,
              taskTitle: task.activityName,
            ));
          },
        ),
        TopToolBarAction(
          icon: Icons.access_time,
          onTap: () {
            Get.to(() => TaskActivityFeedScreen(activityId: task.activityId));
          },
        ),
        if (!isLocked)
          TopToolBarAction(
            icon: Icons.edit_outlined,
            onTap: () {
              Get.to(() => const EditTaskScreen(), arguments: task)?.then((value) {
                if (value == true) {
                  controller.fetchTaskDetail(showLoading: false);
                }
              });
            },
          ),
      ],
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
      return SizedBox.shrink();
    }

    final List<Widget> sections = [];

    if (hasLabels) {
      sections.add(_buildLabels(task));
    }

    if (hasChecklists) {
      sections.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CHECKLISTS',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 12),
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
            Text(
              'REPEAT',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 6),
            Text(
              task.recurringType ?? 'RECURRING',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
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
            Text(
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
        _CollapsibleSection(
          title: Text(
            'Attachments   (${task.attachments!.length})',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          contentGap: 14,
          child: _buildAttachments(task),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.textPrimary.withOpacity(0.06)),
      ),
      child: _CollapsibleSection(
        title: Text(
          hasLabels ? 'LABEL' : 'DETAILS',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        spreadHeader: true,
        contentGap: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < sections.length; i++) ...[
              sections[i],
              if (i < sections.length - 1) const SizedBox(height: 20),
            ],
          ],
        ),
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
          color = Color(0xFF68B684);
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label.name,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
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
            padding: EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.itemName,
                    style: TextStyle(
                      color: isLocked ? AppColors.textSecondary : AppColors.textPrimary,
                      fontSize: 13,
                    ),
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: item.completed ? Color(0xFF68B684) : AppColors.textSecondary,
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
      return SizedBox.shrink();
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
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (year.isNotEmpty)
          Text(
            year,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _buildCollaboratorsSection(TaskResponse task) {
    final taskCollaborators = task.collaborators ?? [];
    if (taskCollaborators.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Collaborators   (${taskCollaborators.length})',
          style: TextStyle(
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
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  name,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
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

    final images = <String>[];
    final files = <Widget>[];

    for (final attachment in task.attachments!) {
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
          images.add(url);
          continue;
        }

        files.add(Container(
          margin: EdgeInsets.only(bottom: 8.0),
          padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
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
                child: Icon(Icons.attach_file, color: AppColors.textSecondary, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (images.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: files.isEmpty ? 0 : 10),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < images.length; i++)
                  _AttachmentThumbnail(
                    url: images[i],
                    onTap: () => Get.to(
                      () => _AttachmentImageViewer(urls: images, initialIndex: i),
                      transition: Transition.fadeIn,
                    ),
                  ),
              ],
            ),
          ),
        ...files,
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context, TaskResponse task, TaskDetailController controller) {
    final isCompleted = task.status == 'COMPLETE';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: AppButton(
        label: isCompleted ? 'Completed' : 'Mark as Complete',
        onPressed: isCompleted ? null : () => controller.markAsComplete(),
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

class _CollapsibleSection extends StatefulWidget {
  const _CollapsibleSection({
    required this.title,
    required this.child,
    this.spreadHeader = false,
    this.contentGap = 12,
  });

  final Widget title;
  final Widget child;
  final bool spreadHeader;
  final double contentGap;

  @override
  State<_CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<_CollapsibleSection>
    with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 320);

  bool _expanded = true;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _duration,
    value: 1,
  );
  late final Animation<double> _size = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );
  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.25, 1, curve: Curves.easeOut),
    reverseCurve: const Interval(0, 0.6, curve: Curves.easeIn),
  );
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, -0.04),
    end: Offset.zero,
  ).animate(_size);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final arrow = AnimatedRotation(
      turns: _expanded ? 0 : 0.5,
      duration: _duration,
      curve: Curves.easeOutBack,
      child: Icon(
        Icons.keyboard_arrow_up,
        color: AppColors.textSecondary,
        size: 20,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: _toggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment:
                  widget.spreadHeader ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
              children: [
                widget.title,
                if (!widget.spreadHeader) const SizedBox(width: 6),
                arrow,
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _size,
          alignment: Alignment.topCenter,
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Padding(
                padding: EdgeInsets.only(top: widget.contentGap - 4),
                child: SizedBox(width: double.infinity, child: widget.child),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AttachmentThumbnail extends StatelessWidget {
  const _AttachmentThumbnail({required this.url, required this.onTap});

  static const double size = 88;

  final String url;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: size,
          height: size,
          color: AppColors.chipSurface,
          child: Image.network(
            url,
            fit: BoxFit.cover,
            cacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).round(),
            loadingBuilder: (context, child, progress) => progress == null
                ? child
                : const Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
            errorBuilder: (_, __, ___) => Icon(
              Icons.broken_image_outlined,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _AttachmentImageViewer extends StatefulWidget {
  const _AttachmentImageViewer({required this.urls, required this.initialIndex});

  final List<String> urls;
  final int initialIndex;

  @override
  State<_AttachmentImageViewer> createState() => _AttachmentImageViewerState();
}

class _AttachmentImageViewerState extends State<_AttachmentImageViewer> {
  late final PageController _pageController = PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.urls.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) => InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Center(
                child: Image.network(
                  widget.urls[i],
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image_outlined, color: Colors.white54, size: 48),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                  const Spacer(),
                  if (widget.urls.length > 1)
                    Text(
                      '${_index + 1} / ${widget.urls.length}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

