import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/fitness_achievement_controller.dart';
import '../../data/models/achievement_model.dart';
import '../../../../core/theme/app_colors.dart';

class FitnessAchievementsScreen extends StatelessWidget {
  const FitnessAchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FitnessAchievementController());

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppColors.pageBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Achievements & Badges',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingAchievements.value && controller.achievements.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
        }

        final earnedCount = controller.earnedCount;
        final totalCount = controller.achievements.length;
        final percent = totalCount > 0 ? (earnedCount / totalCount) : 0.0;

        return Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.chipSurface, AppColors.cardSurface],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.5), width: 2),
                    ),
                    child: const Icon(Icons.emoji_events, color: Colors.amber, size: 36),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$earnedCount of $totalCount Unlocked',
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percent,
                            backgroundColor: AppColors.textPrimary.withValues(alpha: 0.1),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${(percent * 100).toInt()}% completed • Keep pushing!',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = controller.categories[index];
                  final isSelected = controller.selectedCategory.value == cat;
                  return ChoiceChip(
                    label: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFF2563EB),
                    backgroundColor: AppColors.chipSurface,
                    side: BorderSide(
                      color: isSelected ? Colors.blueAccent : AppColors.textPrimary.withValues(alpha: 0.1),
                    ),
                    onSelected: (_) => controller.selectedCategory.value = cat,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: RefreshIndicator(
                color: Colors.blueAccent,
                backgroundColor: AppColors.chipSurface,
                onRefresh: () => controller.loadAchievements(),
                child: controller.filteredAchievements.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 80),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.emoji_events_outlined, color: AppColors.textCaption, size: 56),
                                SizedBox(height: 16),
                                Text(
                                  'No achievements found',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Complete workouts and challenges to unlock badges!',
                                  style: TextStyle(color: AppColors.textCaption, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.filteredAchievements.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final achievement = controller.filteredAchievements[index];
                          return _buildAchievementCard(achievement);
                        },
                      ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildAchievementCard(AchievementModel achievement) {
    final isEarned = achievement.earned;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEarned ? AppColors.chipSurface : AppColors.chipSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEarned ? Colors.amber.withValues(alpha: 0.4) : AppColors.textPrimary.withValues(alpha: 0.06),
          width: isEarned ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isEarned ? Colors.amber.withValues(alpha: 0.2) : AppColors.textPrimary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIconData(achievement.icon),
              color: isEarned ? Colors.amber : AppColors.textCaption,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        achievement.name,
                        style: TextStyle(
                          color: isEarned ? AppColors.textPrimary : AppColors.textSecondary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isEarned)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check, color: Colors.amber, size: 12),
                            SizedBox(width: 4),
                            Text('EARNED', style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.description,
                  style: const TextStyle(color: AppColors.textCaption, fontSize: 12),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: (achievement.progressPercentage / 100.0).clamp(0.0, 1.0),
                          backgroundColor: AppColors.textPrimary.withValues(alpha: 0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isEarned ? Colors.amber : Colors.blueAccent,
                          ),
                          minHeight: 4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${achievement.progressPercentage.toInt()}%',
                      style: TextStyle(
                        color: isEarned ? Colors.amber : AppColors.textCaption,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'directions_run':
        return Icons.directions_run;
      case 'speed':
        return Icons.speed;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'groups':
        return Icons.groups;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'bolt':
        return Icons.bolt;
      case 'favorite':
        return Icons.favorite;
      default:
        return Icons.emoji_events;
    }
  }
}
