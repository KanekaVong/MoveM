import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/workout_model.dart';

Future<void> showAchievementUnlockDialog(WorkoutEarnedAchievement achievement) {
  return Get.dialog<void>(
    _AchievementUnlockDialog(achievement: achievement),
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.45),
  );
}

class _AchievementUnlockDialog extends StatelessWidget {
  final WorkoutEarnedAchievement achievement;

  const _AchievementUnlockDialog({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final highlight = _highlight(achievement, l10n);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final cardHeight = screenHeight < 700 ? 400.0 : 450.0;

    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SizedBox(
              height: cardHeight,
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: cardHeight * 0.74,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(0xFFD5D5D5).withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 12,
                    right: 12,
                    child: Image.asset(
                      _badgeAsset(achievement),
                      height: cardHeight * 0.56,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    left: 22,
                    right: 22,
                    bottom: 22,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n?.congratulationOnYour ?? 'CONGRATULATION ON YOUR',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          highlight,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF4EB6FF),
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.4,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: Get.back,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3EC4FF),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: const StadiumBorder(),
                            ),
                            child: Text(
                              l10n?.awesome ?? 'AWESOME!!!',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ],
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
}

String _badgeAsset(WorkoutEarnedAchievement achievement) {
  final key = '${achievement.name} ${achievement.icon} ${achievement.description} ${achievement.conditionType}'
      .toLowerCase();
  final isDistance = key.contains('km') || key.contains('distance') || key.contains('club');
  if (isDistance) return AppImages.badge10KmClub;
  return AppImages.badgeFirstWorkout;
}

String _highlight(WorkoutEarnedAchievement achievement, AppLocalizations? l10n) {
  final key = '${achievement.name} ${achievement.description}'.toLowerCase();
  if (key.contains('10') && key.contains('km')) {
    return l10n?.first10Kilometers ?? 'FIRST 10 KILOMETERS!';
  }
  if (key.contains('first') && key.contains('workout')) {
    return l10n?.firstWorkout ?? 'FIRST WORKOUT!';
  }
  final name = achievement.name.trim().isNotEmpty
      ? achievement.name.trim()
      : achievement.description.trim();
  if (name.isEmpty) return l10n?.newAchievement ?? 'NEW ACHIEVEMENT!';
  final upper = name.toUpperCase();
  return upper.endsWith('!') ? upper : '$upper!';
}
