import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_images.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/task_controller.dart';
import 'create_task_screen.dart';
import 'task_detail_screen.dart';

class TaskScreen extends GetView<TaskController> {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TaskController());
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0E0A07),
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
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Color(0xFF0E0A07),
                      ],
                      stops: [0.0, 0.6, 1.0],
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
                          const Color(0xFF0E0A07).withValues(alpha: 0.0),
                          const Color(0xFF0E0A07).withValues(alpha: 0.6),
                          const Color(0xFF0E0A07),
                        ],
                        stops: const [0.0, 0.4, 0.8],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            l10n?.todayProgress ?? 'Progress',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildCreateTaskBanner(context),
                          const SizedBox(height: 16),
                          Obx(() => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: _buildCompletedTasksCard(context),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  children: [
                                    _buildMiniCard(
                                        l10n?.upcoming ?? 'Upcoming Tasks',
                                        '${controller.upcomingTasksCount}'),
                                    const SizedBox(height: 16),
                                    _buildMiniCard(
                                        l10n?.ongoingTasks ??
                                            'On-Going Tasks',
                                        '${controller.ongoingTasksCount}'),
                                  ],
                                ),
                              ),
                            ],
                          )),
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
                      color: const Color(0xFF0E0A07),
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
                            l10n?.allTasks ?? 'All Tasks',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
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
              backgroundColor: const Color(0xFF131B2F),
              onRefresh: () => controller.fetchTasks(),
              child: _buildTaskList(),
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
          color: isFiltered ? const Color(0xFF1E3A8A) : const Color(0xFF131B2F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isFiltered ? const Color(0xFF3B82F6) : const Color(0xFF1E293B),
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
                    color: isFiltered ? const Color(0xFF60A5FA) : const Color(0xFFA0AAB2),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isFiltered ? controller.filterSummary : 'Filter',
                    style: TextStyle(
                      color: isFiltered ? Colors.white : const Color(0xFFA0AAB2),
                      fontSize: 12,
                      fontWeight: isFiltered ? FontWeight.bold : FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            if (isFiltered) ...[
              const SizedBox(width: 6),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  controller.clearFilters();
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2563EB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
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
      backgroundColor: const Color(0xFF131B2F),
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
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter Tasks',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
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
                            child: const Text(
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
                    const SizedBox(height: 20),
                    const Text(
                      'STATUS',
                      style: TextStyle(
                        color: Color(0xFFA0AAB2),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                                  : const Color(0xFFA0AAB2),
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: const Color(0xFF3B82F6),
                          backgroundColor: const Color(0xFF0E1626),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected
                                  ? const Color(0xFF3B82F6)
                                  : const Color(0xFF1E293B),
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
                    const SizedBox(height: 20),
                    const Text(
                      'PRIORITY',
                      style: TextStyle(
                        color: Color(0xFFA0AAB2),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                                  : const Color(0xFFA0AAB2),
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: const Color(0xFF3B82F6),
                          backgroundColor: const Color(0xFF0E1626),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected
                                  ? const Color(0xFF3B82F6)
                                  : const Color(0xFF1E293B),
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
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(bottomSheetContext);
                          controller.setFilters(
                            status: tempStatus,
                            priority: tempPriority,
                          );
                        },
                        child: const Text(
                          'Apply Filters',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
          child: Text(
            'Ready To Elevate Your\nTask To Another Level?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFE2E8F0),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              shadows: [
                Shadow(
                  color: Colors.black87,
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateTaskBanner(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () {
        Get.to(() => const CreateTaskScreen())
            ?.then((_) => controller.fetchTasks());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              children: [
                Text(l10n?.createTask ?? 'Create Task',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic)),
                const SizedBox(height: 4),
                const Text('Let your brain relax, put it here.',
                    style: TextStyle(
                        color: Color(0xFFA0AAB2),
                        fontSize: 10,
                        fontStyle: FontStyle.italic)),
              ],
            ),
            const Icon(Icons.add, color: Colors.white, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedTasksCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final total = controller.tasks.length;
    final completed = controller.completedTasksCount;
    final progress = total > 0 ? completed / total : 0.0;

    return Container(
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n?.completedTasks ?? 'Completed Tasks',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic)),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
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
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF3B82F6)),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('$completed',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                          const Text('Completed',
                              style: TextStyle(
                                  color: Color(0xFFA0AAB2), fontSize: 10)),
                        ],
                      ),
                    ),
                  ],
                ),
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
      height: 72,
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
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic)),
          const SizedBox(height: 8),
          Center(
              child: Text(subtitle,
                  style: const TextStyle(
                      color: Color(0xFFA0AAB2),
                      fontSize: 12,
                      fontStyle: FontStyle.italic))),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return Obx(() {
      if (controller.isLoading && controller.tasks.isEmpty) {
        return Container(
          color: const Color(0xFF0E0A07),
          child: const Center(
            child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
          ),
        );
      }

      if (controller.tasks.isEmpty) {
        return Container(
          color: const Color(0xFF0E0A07),
          child: const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 120.0),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'Empty',
                  style: TextStyle(
                      color: Color(0xFF334155),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ),
        );
      }

      return Container(
        color: const Color(0xFF0E0A07),
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
            backgroundColor: const Color(0xFF131B2F),
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
              color: const Color(0xFF131B2F),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFF1E293B),
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
                        color: const Color(0xFF450A0A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Color(0xFFEF4444),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      l10n?.deleteTask ?? 'Delete Task',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  l10n?.deleteTaskConfirm ??
                      'Are you sure you want to delete this task? This action cannot be undone.',
                  style: const TextStyle(
                    color: Color(0xFFA0AAB2),
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 32,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () =>
                            Navigator.of(dialogContext).pop(false),
                        child: Text(
                          l10n?.cancel ?? 'Cancel',
                          style: const TextStyle(
                            color: Color(0xFFA0AAB2),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC2626),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () =>
                            Navigator.of(dialogContext).pop(true),
                        child: Text(
                          l10n?.delete ?? 'Delete',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

    Color priorityColor = Colors.grey;
    Color priorityBgColor = const Color(0xFF1E293B);
    String priorityText = task.priority ?? 'Low';

    if (priorityText.toUpperCase() == 'LOW') {
      priorityColor = const Color(0xFF65A30D);
      priorityBgColor = const Color(0xFF1A2E20);
    } else if (priorityText.toUpperCase() == 'NORMAL' ||
        priorityText.toUpperCase() == 'MEDIUM') {
      priorityColor = const Color(0xFFEAB308);
      priorityBgColor = const Color(0xFF422006);
    } else if (priorityText.toUpperCase() == 'HIGH' ||
        priorityText.toUpperCase() == 'URGENT') {
      priorityColor = const Color(0xFFEF4444);
      priorityBgColor = const Color(0xFF450A0A);
    }

    Color indicatorColor = task.status == 'COMPLETE'
        ? const Color(0xFF22C55E)
        : const Color(0xFFF97316);

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

    return Opacity(
      opacity: isComplete ? 0.55 : 1.0,
      child: GestureDetector(
        onTap: () {
          Get.to(() => TaskDetailScreen(activityId: task.activityId))
              ?.then((_) => controller.fetchTasks());
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF002468).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.14),
                  width: 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 46,
                        decoration: BoxDecoration(
                          color: indicatorColor,
                          borderRadius: BorderRadius.circular(3),
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
                                color: isComplete
                                    ? const Color(0xFFA0AAB2)
                                    : Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: priorityBgColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    priorityText.toLowerCase().capitalizeFirst ??
                                        priorityText,
                                    style: TextStyle(
                                      color: priorityColor,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Dateline : $formattedDate',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
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
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A1428).withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF1E3A8A).withValues(alpha: 0.6),
                            width: 1.2,
                          ),
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
                  const SizedBox(height: 10),
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.4),
                        width: 0.5,
                      ),
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
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Progression : $progressionPercent%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
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
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic,
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
        ),
      ),
    );
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




