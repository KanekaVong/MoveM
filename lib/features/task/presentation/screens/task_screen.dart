import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_images.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/task_controller.dart';
import 'create_task_screen.dart';
import 'task_detail_screen.dart';
import 'task_invitation_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/no_data_component.dart';

class TaskScreen extends GetView<TaskController> {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<TaskController>()) {
      Get.put(TaskController());
    }

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 380,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  AppImages.taskScreenBackground,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        AppColors.pageBackground,
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                _buildSliverAppBar(),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.pageBackground.withValues(alpha: 0.0),
                          AppColors.pageBackground.withValues(alpha: 0.7),
                          AppColors.pageBackground,
                        ],
                        stops: [0.0, 0.4, 0.85],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Text(
                            'PROGRESS',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(height: 16),
                          Obx(() => _buildProgressCard(context)),
                          SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyHeaderDelegate(
                    minHeight: 48.0 + MediaQuery.of(context).padding.top,
                    maxHeight: 48.0 + MediaQuery.of(context).padding.top,
                    child: Container(
                      color: AppColors.pageBackground,
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        bottom: 10.0,
                        top: MediaQuery.of(context).padding.top,
                      ),
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'ALL TASKS',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                            ),
                          ),
                          _buildFilterButton(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: RefreshIndicator(
              color: const Color(0xFF3B82F6),
              backgroundColor: AppColors.cardSurface,
              onRefresh: () => controller.fetchTasks(),
              child: _buildTaskList(),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 20,
            child: GestureDetector(
              onTap: () => Get.to(() => const TaskInvitationScreen()),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.28),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
                ),
                child: Icon(Icons.mail_outline, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return Obx(() {
      final isFiltered = controller.hasActiveFilter;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isFiltered ? AppColors.chipSurface : AppColors.cardSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isFiltered ? Color(0xFF3B82F6) : AppColors.chipSurface,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _showFilterBottomSheet(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.filter_list_rounded,
                    color: isFiltered ? Color(0xFF60A5FA) : AppColors.textCaption,
                    size: 16,
                  ),
                  SizedBox(width: 6),
                  Text(
                    isFiltered ? controller.filterSummary : 'Filter',
                    style: TextStyle(
                      color: isFiltered ? Colors.white : AppColors.textCaption,
                      fontSize: 12,
                      fontWeight: isFiltered ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (isFiltered) ...[
              SizedBox(width: 6),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  controller.clearFilters();
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Color(0xFF2563EB),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: AppColors.textPrimary,
                    size: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  void _showFilterBottomSheet(BuildContext context) {
    String? tempStatus = controller.selectedStatus.value;
    String? tempPriority = controller.selectedPriority.value;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardSurface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final statusOptions = [
              {'label': 'All', 'value': null},
              {'label': 'Upcoming', 'value': 'UPCOMING'},
              {'label': 'Pending', 'value': 'PENDING'},
              {'label': 'In Progress', 'value': 'IN_PROGRESS'},
              {'label': 'Complete', 'value': 'COMPLETE'},
              {'label': 'Cancelled', 'value': 'CANCELLED'},
              {'label': 'Deleted', 'value': 'DELETED'},
            ];

            final priorityOptions = [
              {'label': 'All', 'value': null},
              {'label': 'Urgent', 'value': 'URGENT'},
              {'label': 'High', 'value': 'HIGH'},
              {'label': 'Medium', 'value': 'MEDIUM'},
              {'label': 'Low', 'value': 'LOW'},
            ];

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 16.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.borderLight,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter Tasks',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (tempStatus != null || tempPriority != null)
                          GestureDetector(
                            onTap: () {
                              setModalState(() {
                                tempStatus = null;
                                tempPriority = null;
                              });
                            },
                            child: Text(
                              'Reset',
                              style: TextStyle(
                                color: Color(0xFF3B82F6),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'STATUS',
                      style: TextStyle(
                        color: AppColors.textCaption,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: statusOptions.map((opt) {
                        final isSelected = tempStatus == opt['value'];
                        return ChoiceChip(
                          showCheckmark: false,
                          label: Text(
                            opt['label'] as String,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textCaption,
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: const Color(0xFF3B82F6),
                          backgroundColor: AppColors.cardSurface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected
                                  ? const Color(0xFF3B82F6)
                                  : AppColors.chipSurface,
                            ),
                          ),
                          onSelected: (_) {
                            setModalState(() {
                              tempStatus = opt['value'];
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'PRIORITY',
                      style: TextStyle(
                        color: AppColors.textCaption,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: priorityOptions.map((opt) {
                        final isSelected = tempPriority == opt['value'];
                        return ChoiceChip(
                          showCheckmark: false,
                          label: Text(
                            opt['label'] as String,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textCaption,
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: const Color(0xFF3B82F6),
                          backgroundColor: AppColors.cardSurface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected
                                  ? const Color(0xFF3B82F6)
                                  : AppColors.chipSurface,
                            ),
                          ),
                          onSelected: (_) {
                            setModalState(() {
                              tempPriority = opt['value'];
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      label: 'Apply Filters',
                      onPressed: () {
                        Navigator.pop(bottomSheetContext);
                        controller.setFilters(
                          status: tempStatus,
                          priority: tempPriority,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 180,
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: false,
      flexibleSpace: const FlexibleSpaceBar(
        background: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              'Ready To Elevate Your\nTask To Another Level?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
                height: 1.35,
                shadows: [
                  Shadow(
                    color: Colors.black87,
                    blurRadius: 12,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 8),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'COMPLETED TASKS',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCircularProgressRing(),
              const SizedBox(width: 20),
              Expanded(
                child: _buildTasksSummaryRight(),
              ),
            ],
          ),
          SizedBox(height: 24),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Get.to(() => const CreateTaskScreen())
                  ?.then((_) => controller.fetchTasks());
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'CREATE TASK',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.add,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Let your brain relax, put it here.',
                  style: TextStyle(
                    color: AppColors.textCaption,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularProgressRing() {
    final total = controller.tasks.length;
    final completed = controller.completedTasksCount;
    final progress = total > 0 ? (completed / total).clamp(0.0, 1.0) : 0.0;

    return SizedBox(
      width: 136,
      height: 136,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 136,
            height: 136,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 10,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.borderLight.withValues(alpha: 0.9),
              ),
            ),
          ),
          if (progress > 0)
            SizedBox(
              width: 136,
              height: 136,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 10,
                strokeCap: StrokeCap.round,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF3B82F6),
                ),
              ),
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$completed',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'COMPLETED',
                style: TextStyle(
                  color: AppColors.textCaption,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTasksSummaryRight() {
    final upcoming = controller.tasks
        .where((t) =>
            t.status != 'COMPLETE' &&
            t.status != 'CANCELLED' &&
            t.deadline != null)
        .toList();

    final ongoing = controller.tasks
        .where((t) => t.status == 'IN_PROGRESS' || t.status == 'PENDING')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Upcoming Tasks',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6),
        if (upcoming.isNotEmpty) ...[
          for (int i = 0; i < upcoming.length && i < 2; i++) ...[
            _buildUpcomingItem(upcoming[i]),
            if (i < upcoming.length - 1 && i < 1) SizedBox(height: 4),
          ],
        ] else ...[
          Text(
            'No upcoming tasks',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
        SizedBox(height: 16),
        Text(
          'On-Going Tasks',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6),
        if (ongoing.isNotEmpty) ...[
          _buildOngoingItem(ongoing.first),
        ] else ...[
          Text(
            'No ongoing tasks',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ],
    );
  }

  Widget _buildUpcomingItem(dynamic task) {
    String dueText = 'Due Soon';
    if (task.deadline != null) {
      try {
        final date = DateTime.parse(task.deadline!);
        final diff = date.difference(DateTime.now()).inDays;
        if (diff < 0) {
          dueText = 'Overdue';
        } else if (diff == 0) {
          dueText = 'Due Today';
        } else if (diff == 1) {
          dueText = 'Due Tomorrow';
        } else if (diff <= 7) {
          dueText = 'Due Next Week';
        } else if (diff <= 30) {
          dueText = 'Due Next Month';
        } else {
          dueText = 'Due ${DateFormat('d MMM').format(date)}';
        }
      } catch (_) {}
    }

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: '${task.activityName} ',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: dueText,
            style: const TextStyle(
              color: Color(0xFFEF4444),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockUpcomingItem(String title, String due) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title ',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: due,
            style: const TextStyle(
              color: Color(0xFFEF4444),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOngoingItem(dynamic task) {
    String dueText = 'Due Next Month';
    if (task.deadline != null) {
      try {
        final date = DateTime.parse(task.deadline!);
        final diff = date.difference(DateTime.now()).inDays;
        if (diff <= 30) {
          dueText = 'Due Next Month';
        } else {
          dueText = 'Due ${DateFormat('d MMM').format(date)}';
        }
      } catch (_) {}
    }

    double prog = 0.5;
    if (task.totalChecklistItems != null && task.totalChecklistItems > 0) {
      prog = task.completedChecklistItems / task.totalChecklistItems;
    } else if (task.checklistProgress != null) {
      prog = task.checklistProgress;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: [
              TextSpan(
                text: '${task.activityName} ',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: dueText,
                style: TextStyle(
                  color: Color(0xFF4ADE80),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Container(
            height: 4,
            width: double.infinity,
            color: AppColors.chipSurface,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: prog.clamp(0.05, 1.0),
              child: Container(
                color: const Color(0xFF4ADE80),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMockOngoingItem(String title, String due, double prog) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: [
              TextSpan(
                text: '$title ',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: due,
                style: TextStyle(
                  color: Color(0xFF4ADE80),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Container(
            height: 4,
            width: double.infinity,
            color: AppColors.chipSurface,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: prog.clamp(0.05, 1.0),
              child: Container(
                color: const Color(0xFF4ADE80),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    return Obx(() {
      if (controller.isLoading && controller.tasks.isEmpty) {
        return Container(
          color: AppColors.pageBackground,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: 80),
              Center(
                child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
              ),
            ],
          ),
        );
      }

      if (controller.tasks.isEmpty) {
        return Container(
          color: AppColors.pageBackground,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 120.0),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: NoDataComponent(
                title: AppLocalizations.of(Get.context!)?.noTasksYet ?? 'No tasks yet',
                subtitle: AppLocalizations.of(Get.context!)?.createTaskToStart ?? 'Create a task to get started.',
              ),
            ),
          ),
        );
      }

      return Container(
        color: AppColors.pageBackground,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 120.0),
          itemCount: controller.tasks.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final task = controller.tasks[index];
            return _buildDismissibleTaskTile(context, task);
          },
        ),
      );
    });
  }

  Widget _buildDismissibleTaskTile(BuildContext context, dynamic task) {
    final l10n = AppLocalizations.of(context);
    return Dismissible(
      key: Key('task_${task.activityId}'),
      direction: DismissDirection.endToStart,
      dismissThresholds: const {
        DismissDirection.endToStart: 0.25,
      },
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmationDialog(context, task);
      },
      onDismissed: (direction) async {
        final success = await controller.deleteTask(task.activityId);
        if (success) {
          Get.snackbar(
            l10n?.deleteTask ?? 'Delete Task',
            l10n?.taskDeletedSuccess ?? 'Task deleted successfully',
            backgroundColor: AppColors.emerald,
            colorText: Colors.white,
            icon: const Icon(Icons.check_circle_outline, color: Color(0xFF22C55E)),
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(16),
            borderRadius: 16,
            duration: const Duration(seconds: 2),
          );
        }
      },
      background: _buildSwipeDeleteBackground(),
      child: _buildTaskTile(task),
    );
  }

  Widget _buildSwipeDeleteBackground() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFDC2626),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDC2626).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(
      BuildContext context, dynamic task) async {
    final l10n = AppLocalizations.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 44),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.chipSurface,
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: Color(0xFFEF4444),
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      l10n?.deleteTask ?? 'Delete Task',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  l10n?.deleteTaskConfirm ??
                      'Are you sure you want to delete this task? This action cannot be undone.',
                  style: TextStyle(
                    color: AppColors.textCaption,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AppButton.secondary(
                        label: l10n?.cancel ?? 'Cancel',
                        onPressed: () =>
                            Navigator.of(dialogContext).pop(false),
                        height: 46,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton.danger(
                        label: l10n?.delete ?? 'Delete',
                        onPressed: () =>
                            Navigator.of(dialogContext).pop(true),
                        height: 46,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    return result ?? false;
  }

  Widget _buildTaskTile(dynamic task) {
    String formattedDate = 'Not set';
    if (task.deadline != null) {
      try {
        final date = DateTime.parse(task.deadline!);

        String day = DateFormat('d').format(date.toLocal());
        String suffix = 'th';
        if (day.endsWith('1') && !day.endsWith('11')) {
          suffix = 'st';
        } else if (day.endsWith('2') && !day.endsWith('12')) {
          suffix = 'nd';
        } else if (day.endsWith('3') && !day.endsWith('13')) {
          suffix = 'rd';
        }

        formattedDate =
            '$day$suffix ${DateFormat('MMMM yyyy').format(date.toLocal())}';
      } catch (_) {}
    }

    Color priorityColor = const Color(0xFF4ADE80);
    Color priorityBgColor = const Color(0xFFECFDF3);
    Color priorityBorderColor = const Color(0xFF22C55E).withValues(alpha: 0.3);
    String priorityText = task.priority ?? 'Low';

    if (priorityText.toUpperCase() == 'LOW') {
      priorityColor = const Color(0xFF4ADE80);
      priorityBgColor = const Color(0xFFECFDF3);
      priorityBorderColor = const Color(0xFF22C55E).withValues(alpha: 0.3);
    } else if (priorityText.toUpperCase() == 'NORMAL' ||
        priorityText.toUpperCase() == 'MEDIUM') {
      priorityColor = const Color(0xFFFBBF24);
      priorityBgColor = const Color(0xFFFFFBEB);
      priorityBorderColor = const Color(0xFFF59E0B).withValues(alpha: 0.3);
    } else if (priorityText.toUpperCase() == 'HIGH' ||
        priorityText.toUpperCase() == 'URGENT') {
      priorityColor = const Color(0xFFF87171);
      priorityBgColor = const Color(0xFFFEF2F2);
      priorityBorderColor = const Color(0xFFEF4444).withValues(alpha: 0.3);
    }

    Color indicatorColor = const Color(0xFF22C55E);
    if (priorityText.toUpperCase() == 'HIGH' || priorityText.toUpperCase() == 'URGENT') {
      indicatorColor = const Color(0xFFEF4444);
    } else if (priorityText.toUpperCase() == 'NORMAL' || priorityText.toUpperCase() == 'MEDIUM') {
      indicatorColor = const Color(0xFFF59E0B);
    }

    double progression = 0.0;
    if (task.totalChecklistItems != null && task.totalChecklistItems > 0) {
      progression = task.completedChecklistItems / task.totalChecklistItems;
    } else if (task.checklistProgress != null) {
      progression = task.checklistProgress;
    } else if (task.status == 'COMPLETE') {
      progression = 1.0;
    }
    int progressionPercent = (progression * 100).toInt();

    final isComplete = task.status == 'COMPLETE';
    final isPastDeadline = _isPastDeadline(task);
    final isFaded = isComplete || isPastDeadline;

    return Opacity(
      opacity: isFaded ? 0.65 : 1.0,
      child: GestureDetector(
        onTap: () {
          Get.to(() => TaskDetailScreen(activityId: task.activityId))
              ?.then((_) => controller.fetchTasks());
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.borderLight,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4,
                    height: 34,
                    decoration: BoxDecoration(
                      color: indicatorColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.activityName,
                          style: TextStyle(
                            color: isFaded
                                ? AppColors.textCaption
                                : AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: priorityBgColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: priorityBorderColor,
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                priorityText.toLowerCase().capitalizeFirst ??
                                    priorityText,
                                style: TextStyle(
                                  color: priorityColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Dateline : $formattedDate',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.chipSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.chipSurface.withValues(alpha: 0.6),
                        width: 1.2,
                      ),
                    ),
                    child: Icon(
                      Icons.assignment_outlined,
                      color: Color(0xFF3B82F6),
                      size: 24,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Container(
                  height: 6,
                  width: double.infinity,
                  color: AppColors.borderLight,
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progression.clamp(0.0, 1.0),
                    child: Container(
                      color: const Color(0xFF22C55E),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Progression : $progressionPercent%',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (task.labels != null && task.labels!.isNotEmpty)
                    Flexible(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        alignment: WrapAlignment.end,
                        children: task.labels!.map<Widget>((label) {
                          Color labelColor;
                          try {
                            labelColor = Color(int.parse(
                                label.color.replaceFirst('#', '0xFF')));
                          } catch (_) {
                            labelColor = const Color(0xFF4ADE80);
                          }
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: labelColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: labelColor.withValues(alpha: 0.5),
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              label.name,
                              style: TextStyle(
                                color: labelColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isPastDeadline(dynamic task) {
    final deadline = task.deadline;
    if (deadline == null || deadline.toString().isEmpty) return false;
    try {
      return DateTime.parse(deadline.toString()).toLocal().isBefore(DateTime.now());
    } catch (_) {
      return false;
    }
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}




