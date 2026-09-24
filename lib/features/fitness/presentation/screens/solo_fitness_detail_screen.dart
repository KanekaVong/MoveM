import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/solo_challenge_model.dart';
import '../../data/repositories/fitness_challenge_repository.dart';
import '../controllers/solo_challenge_detail_controller.dart';
import '../../../../core/theme/app_colors.dart';

class SoloFitnessDetailScreen extends StatelessWidget {
  final SoloChallengeModel challenge;
  final FitnessChallengeRepository? repository;

  const SoloFitnessDetailScreen({
    super.key,
    required this.challenge,
    this.repository,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      SoloChallengeDetailController(
        initialChallenge: challenge,
        repository: repository,
      ),
      tag: '${challenge.id}_${challenge.name}',
    );

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Stack(
        children: [
          // Background split: top matches hero image background, bottom is dark navy
          Obx(() {
            final isRunning = controller.isRunning;
            return Column(
              children: [
                Container(
                  height: 330,
                  color: isRunning ? AppColors.pageBackground : Colors.white,
                ),
                Expanded(
                  child: Container(
                    color: AppColors.pageBackground,
                  ),
                ),
              ],
            );
          }),

          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Obx(() {
                      final c = controller.challenge.value;
                      final isRunning = controller.isRunning;
                      final heroImage = c.effectiveHeroImagePath;
                      final formattedTitle = controller.formattedTitle;
                      final formattedDesc = controller.formattedDescription;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 330,
                            color: isRunning ? AppColors.pageBackground : Colors.white,
                            padding: isRunning
                                ? EdgeInsets.zero
                                : const EdgeInsets.only(top: 64, bottom: 24, left: 24, right: 24),
                            child: Center(
                              child: Image.asset(
                                heroImage,
                                width: isRunning ? double.infinity : null,
                                height: isRunning ? 330 : null,
                                fit: isRunning ? BoxFit.cover : BoxFit.contain,
                                errorBuilder: (_, __, ___) => Center(
                                  child: Icon(Icons.fitness_center, color: Colors.grey, size: 80),
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.pageBackground,
                              ),
                              padding: EdgeInsets.fromLTRB(
                                24,
                                28,
                                24,
                                28 + MediaQuery.of(context).padding.bottom,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              formattedTitle,
                                              style: TextStyle(
                                                color: AppColors.textPrimary,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 0.4,
                                                height: 1.25,
                                              ),
                                            ),
                                            SizedBox(height: 12),
                                            Text(
                                              formattedDesc,
                                              style: TextStyle(
                                                color: AppColors.textSecondary,
                                                fontSize: 12.5,
                                                height: 1.45,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.transparent,
                                          border: Border.all(
                                            color: const Color(0xFF38BDF8),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.add,
                                            color: AppColors.textPrimary,
                                            size: 26,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 28),

                                  if (controller.isFetchingMore.value || controller.moreChallenges.isNotEmpty) ...[
                                    Row(
                                      children: [
                                        Text(
                                          'More Activity',
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                        if (controller.isFetchingMore.value) ...[
                                          const SizedBox(width: 10),
                                          const SizedBox(
                                            width: 14,
                                            height: 14,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                              color: Color(0xFF38BDF8),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    ..._buildMoreActivities(controller),
                                    SizedBox(height: 8),
                                  ],

                                  SizedBox(height: 22),

                                  GestureDetector(
                                    onTap: () => controller.startWorkout(() => _showComingSoonModal(c, controller)),
                                    child: Container(
                                      width: double.infinity,
                                      height: 52,
                                      decoration: BoxDecoration(
                                        color: AppColors.accentBlue,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.accentBlue,
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.25),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.play_arrow_outlined,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Start',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              );
            },
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF8E8E93).withValues(alpha: 0.85),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textPrimary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoonModal(SoloChallengeModel c, [SoloChallengeDetailController? controller]) {
    final workoutTitle = c.name.isNotEmpty ? c.name : (c.type.isNotEmpty ? c.type : 'Workout');

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                border: Border.all(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.schedule_rounded,
                color: Color(0xFF38BDF8),
                size: 32,
              ),
            ),
            SizedBox(height: 18),
            Text(
              '$workoutTitle Tracking Coming Soon',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Tracking for $workoutTitle is currently in active development and will be available in an upcoming update.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.chipSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: AppColors.textPrimary.withValues(alpha: 0.15),
                    ),
                  ),
                ),
                onPressed: () => Get.back(),
                child: Text(
                  'Got it',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  List<Widget> _buildMoreActivities(SoloChallengeDetailController controller) {
    if (controller.isFetchingMore.value && controller.moreChallenges.isEmpty) {
      return List.generate(3, (index) => const _ActivityCardSkeleton());
    }

    final items = controller.moreChallenges.take(3).toList();
    if (items.isEmpty) {
      return const [];
    }

    return items.map((item) {
      final isRunning = item.isRunning;
      final subtitle = item.sets > 0 && item.repsPerSet > 0
          ? '${item.sets} Sets of ${item.repsPerSet} ${item.isPushUp ? 'Push Up' : (item.isSquats ? 'Squats' : (item.targetUnit.isNotEmpty ? item.targetUnit : 'Reps'))}'
          : (item.targetValue > 0 && item.targetUnit.isNotEmpty
              ? '${item.targetValue} ${item.targetUnit}'
              : (item.description.isNotEmpty ? item.description : item.workoutLevel));

      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: _buildActivityCard(
          imagePath: item.effectiveImagePath,
          title: item.name,
          subtitle: subtitle,
          isImageWhiteBg: !isRunning,
          onTap: () {
            Get.to(
              () => SoloFitnessDetailScreen(challenge: item),
              preventDuplicates: false,
            );
          },
        ),
      );
    }).toList();
  }

  Widget _buildActivityCard({
    required String imagePath,
    required String title,
    required String? subtitle,
    required bool isImageWhiteBg,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.borderLight,
              width: 1.2,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 72,
                decoration: BoxDecoration(
                  color: isImageWhiteBg ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    imagePath,
                    width: 80,
                    height: 72,
                    fit: isImageWhiteBg ? BoxFit.contain : BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80,
                      height: 72,
                      color: AppColors.borderLight,
                      child: Icon(Icons.fitness_center, color: AppColors.textCaption),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle != null && subtitle.isNotEmpty) ...[
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityCardSkeleton extends StatefulWidget {
  const _ActivityCardSkeleton();

  @override
  State<_ActivityCardSkeleton> createState() => _ActivityCardSkeletonState();
}

class _ActivityCardSkeletonState extends State<_ActivityCardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final t = _animation.value;
        final baseColor = Color.lerp(
          AppColors.chipSurface,
          AppColors.borderMuted,
          t,
        )!;
        final highlightColor = Color.lerp(
          AppColors.chipSurface,
          AppColors.borderMuted,
          t,
        )!;

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.borderLight.withValues(alpha: 0.7),
              width: 1.2,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 72,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 16,
                      decoration: BoxDecoration(
                        color: highlightColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 90,
                      height: 12,
                      decoration: BoxDecoration(
                        color: baseColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
