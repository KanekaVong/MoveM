import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/models/workout_model.dart';
import '../controllers/workout_history_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/no_data_component.dart';
import '../../../../shared/widgets/top_tool_bar.dart';

class WorkoutHistoryScreen extends StatelessWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WorkoutHistoryController());
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: TopToolBar(title: l10n?.workoutHistory ?? 'Workout History'),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return Center(
            child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
          );
        }

        if (controller.errorMessage.isNotEmpty && controller.items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, color: AppColors.textCaption, size: 56),
                  SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  SizedBox(height: 20),
                  AppButton.secondary(
                    label: l10n?.tryAgain ?? 'Try again',
                    onPressed: controller.fetchHistory,
                    width: null,
                    height: 40,
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.items.isEmpty) {
          return NoDataComponent(
            title: l10n?.noWorkoutsYet ?? 'No workouts yet',
            subtitle: l10n?.noWorkoutsYetSub ?? 'Finish a run or workout to see it here.',
          );
        }

        return RefreshIndicator(
          color: const Color(0xFF3B82F6),
          backgroundColor: AppColors.cardSurface,
          onRefresh: controller.fetchHistory,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            itemCount: controller.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _WorkoutHistoryCard(item: controller.items[index]),
          ),
        );
      }),
    );
  }
}

class _WorkoutHistoryCard extends StatelessWidget {
  final WorkoutHistoryItemModel item;
  const _WorkoutHistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final type = _workoutLabel(item.workoutType);
    final icon = _workoutIcon(item.workoutType);
    final accent = _workoutColor(item.workoutType);
    final status = _statusLabel(item.status);
    final statusColor = _statusColor(item.status);
    final date = DateFormat('d MMM yyyy • h:mm a').format(item.startedAt.toLocal());

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E2E4A), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accent.withValues(alpha: 0.35)),
                ),
                child: Icon(icon, color: accent, size: 22),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      date,
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _stat(Icons.timer_outlined, _formatDuration(item.durationSeconds)),
              if (item.distance > 0)
                _stat(Icons.route_outlined, _formatDistance(item.distance)),
              _stat(Icons.local_fire_department_rounded, '${item.caloriesBurned.round()}Cals'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 15),
        SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _workoutLabel(String type) {
    final value = type.toUpperCase();
    if (value.contains('PUSH')) return 'Push Up';
    if (value.contains('SQUAT')) return 'Squat';
    if (value.contains('RUN')) return 'Running';
    if (value.contains('BODY')) return 'Bodyweight';
    return type.replaceAll('_', ' ');
  }

  IconData _workoutIcon(String type) {
    final value = type.toUpperCase();
    if (value.contains('PUSH') || value.contains('SQUAT') || value.contains('BODY')) {
      return Icons.fitness_center;
    }
    return Icons.directions_run;
  }

  Color _workoutColor(String type) {
    final value = type.toUpperCase();
    if (value.contains('PUSH')) return const Color(0xFFF97316);
    if (value.contains('SQUAT')) return const Color(0xFFA78BFA);
    if (value.contains('RUN')) return const Color(0xFF5B9BF6);
    return const Color(0xFF68B684);
  }

  String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
      case 'COMPLETE':
      case 'FINISHED':
        return 'Completed';
      case 'IN_PROGRESS':
        return 'In progress';
      case 'PAUSED':
        return 'Paused';
      case 'NOT_STARTED':
        return 'Not started';
      default:
        return status.replaceAll('_', ' ');
    }
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
      case 'COMPLETE':
      case 'FINISHED':
        return const Color(0xFF4ADE80);
      case 'IN_PROGRESS':
        return const Color(0xFF60A5FA);
      case 'PAUSED':
        return const Color(0xFFFBBF24);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  String _formatDuration(int seconds) {
    if (seconds <= 0) return '0Mins';
    final hours = seconds ~/ 3600;
    final mins = ((seconds % 3600) / 60).round();
    if (hours > 0) {
      if (mins > 0) return '${hours}Hr ${mins}Mins';
      return '${hours}Hr';
    }
    if (mins > 0) return '${mins}Mins';
    return '${seconds}s';
  }

  String _formatDistance(double distance) {
    if (distance >= 1) return '${distance.toStringAsFixed(distance == distance.roundToDouble() ? 0 : 1)}KM';
    return '${distance.toStringAsFixed(2)}KM';
  }
}
