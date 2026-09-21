import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/base/base_controller.dart';
import '../../data/dto/response/activity_feed_item_response.dart';
import '../controllers/task_activity_feed_controller.dart';

class TaskActivityFeedScreen extends StatelessWidget {
  final String activityId;

  const TaskActivityFeedScreen({super.key, required this.activityId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      TaskActivityFeedController(activityId: activityId),
      tag: activityId,
    );

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading && controller.items.isEmpty) {
                  return const Center(
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
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: controller.fetchFeed,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (controller.items.isEmpty) {
                  return const Center(
                    child: Text(
                      'No activity yet',
                      style: TextStyle(color: AppColors.textCaption, fontSize: 15),
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.taskBluePrimary,
                  backgroundColor: Colors.white,
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

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: SizedBox(
        height: 42,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.chipSurface,
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: const Center(
                    child: Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 24),
                  ),
                ),
              ),
            ),
            const Text(
              'History',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
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
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (item.message.trim().isNotEmpty)
                    TextSpan(
                      text: ' ${item.message.trim()}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _formatTimestamp(item.createdAt),
            style: const TextStyle(
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
