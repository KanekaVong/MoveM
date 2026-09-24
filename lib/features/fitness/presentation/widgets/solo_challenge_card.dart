import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/solo_challenge_model.dart';
import '../screens/solo_fitness_detail_screen.dart';
import '../../../../core/theme/app_colors.dart';

class SoloChallengeCard extends StatelessWidget {
  final SoloChallengeModel challenge;
  final bool isHighlighted;
  final VoidCallback? onTap;
  final bool showProgress;

  const SoloChallengeCard({
    super.key,
    required this.challenge,
    this.isHighlighted = false,
    this.onTap,
    this.showProgress = false,
  });

  String _getDescription() {
    if (challenge.description.trim().isNotEmpty) {
      return challenge.description.trim();
    }
    if (challenge.targetValue > 0 && challenge.targetUnit.isNotEmpty) {
      return '${challenge.targetValue} ${challenge.targetUnit}';
    }
    if (challenge.category.trim().isNotEmpty && challenge.category != 'Step Count') {
      return challenge.category.trim();
    }
    return challenge.type.isNotEmpty ? challenge.type : 'Fitness Challenge';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () => Get.to(() => SoloFitnessDetailScreen(challenge: challenge)),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.chipSurface.withValues(alpha: 0.8),
              width: 1.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      challenge.effectiveImagePath,
                      width: 84,
                      height: 84,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          color: AppColors.chipSurface,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          Icons.fitness_center,
                          color: AppColors.textCaption,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          challenge.name,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6),
                        Text(
                          _getDescription(),
                          style: TextStyle(
                            color: AppColors.textPrimary.withValues(alpha: 0.75),
                            fontSize: 13.5,
                            height: 1.3,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (showProgress && challenge.progress > 0) ...[
                SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.chipSurface,
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: challenge.progress.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.accentBlue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
