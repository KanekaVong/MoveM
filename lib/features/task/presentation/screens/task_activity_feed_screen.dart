import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/base/base_controller.dart';
import '../../data/dto/response/activity_feed_item_response.dart';
import '../controllers/task_activity_feed_controller.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/no_data_component.dart';
import '../../../../shared/widgets/top_tool_bar.dart';

class TaskActivityFeedScreen extends StatelessWidget {
  final String activityId;

  const TaskActivityFeedScreen({super.key, required this.activityId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      TaskActivityFeedController(activityId: activityId),
      tag: activityId,
    );

    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            TopToolBar(title: l10n?.historyTitle ?? 'History'),
            Expanded(
              child: Obx(() {
                if (controller.isLoading && controller.items.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.taskBluePrimary),
                  );
                }

                if (controller.state.value == ViewState.error && controller.items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                          ),
                          SizedBox(height: 16),
                          AppButton.secondary(
                            label: l10n?.retry ?? 'Retry',
                            onPressed: controller.fetchFeed,
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
                    title: l10n?.noActivityYet ?? 'No activity yet',
                    subtitle: l10n?.noActivityYetSub ?? 'Updates for this task will appear here.',
                  );
                }

                return RefreshIndicator(
                  color: AppColors.taskBluePrimary,
                  backgroundColor: AppColors.cardSurface,
                  onRefresh: controller.refreshFeed,
                  child: ListView.separated(
                    controller: controller.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    itemCount: controller.items.length + (controller.isLoadingMore.value ? 1 : 0),
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      thickness: 0.6,
                      color: AppColors.textPrimary.withValues(alpha: 0.08),
                    ),
                    itemBuilder: (context, index) {
                      if (index >= controller.items.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.taskBluePrimary),
                            ),
                          ),
                        );
                      }
                      return _ActivityFeedRow(item: controller.items[index]);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityFeedRow extends StatelessWidget {
  final ActivityFeedItemResponse item;

  const _ActivityFeedRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: item.displayName,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (item.message.trim().isNotEmpty)
                    TextSpan(
                      text: ' ${item.message.trim()}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12),
          Text(
            _formatTimestamp(item.createdAt),
            style: TextStyle(
              color: AppColors.textCaption,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(String raw) {
    if (raw.isEmpty) return '';
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    return DateFormat('dd/MM/yyyy h:mma').format(parsed.toLocal());
  }
}
