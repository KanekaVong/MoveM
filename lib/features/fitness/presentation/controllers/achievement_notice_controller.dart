import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../../../main_nav/presentation/controllers/main_nav_controller.dart';
import '../../data/models/workout_model.dart';
import '../widgets/achievement_unlock_dialog.dart';

class AchievementNoticeController extends GetxController {
  final pending = <WorkoutEarnedAchievement>[];
  final Set<String> _handledKeys = {};
  bool _showing = false;
  bool _presentScheduled = false;
  Worker? _tabWorker;

  static AchievementNoticeController ensure() {
    if (Get.isRegistered<AchievementNoticeController>()) {
      return Get.find<AchievementNoticeController>();
    }
    return Get.put(AchievementNoticeController(), permanent: true);
  }

  void enqueue(List<WorkoutEarnedAchievement> items) {
    var added = false;
    for (final item in items) {
      if (!item.notified) continue;
      final key = _key(item);
      if (_handledKeys.contains(key)) continue;
      if (pending.any((queued) => _key(queued) == key)) continue;
      _handledKeys.add(key);
      pending.add(item);
      added = true;
    }
    if (added) presentWhenFitnessIsVisible();
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<MainNavController>()) {
      _tabWorker = ever(Get.find<MainNavController>().currentIndex, (_) {
        presentWhenFitnessIsVisible();
      });
    }
  }

  @override
  void onClose() {
    _tabWorker?.dispose();
    super.onClose();
  }

  void presentWhenFitnessIsVisible() {
    if (_showing || _presentScheduled || pending.isEmpty) return;
    _presentScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _presentScheduled = false;
      _tryShow();
    });
  }

  Future<void> _tryShow() async {
    if (_showing || pending.isEmpty) return;
    if (!Get.isRegistered<MainNavController>()) return;
    if (Get.find<MainNavController>().currentIndex.value != 2) return;
    if (Get.key.currentState?.canPop() == true) return;

    _showing = true;
    final achievement = pending.removeAt(0);
    try {
      await showAchievementUnlockDialog(achievement);
    } finally {
      _showing = false;
    }
    if (pending.isNotEmpty) {
      presentWhenFitnessIsVisible();
    }
  }

  String _key(WorkoutEarnedAchievement item) {
    return '${item.achievementId}|${item.name}|${item.earnedAt?.toIso8601String() ?? ''}';
  }
}
