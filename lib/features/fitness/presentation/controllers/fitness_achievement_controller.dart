import 'package:get/get.dart';
import '../../../../shared/base/base_controller.dart';
import '../../data/models/achievement_model.dart';
import '../../data/repositories/fitness_achievement_repository.dart';

class FitnessAchievementController extends BaseController {
  final FitnessAchievementRepository _repository = FitnessAchievementRepository();

  final achievements = <AchievementModel>[].obs;
  final earnedAchievements = <UserAchievementModel>[].obs;
  final isLoadingAchievements = false.obs;
  final selectedCategory = 'ALL'.obs;

  final categories = ['ALL', 'GENERAL', 'WORKOUT', 'RUNNING', 'CHALLENGE'].obs;

  @override
  void onInit() {
    super.onInit();
    loadAchievements();
  }

  Future<void> loadAchievements() async {
    isLoadingAchievements.value = true;
    final res = await _repository.getAllAchievements();
    if (res.isSuccess && res.data != null) {
      achievements.value = res.data!;
    } else {
      achievements.clear();
    }

    final myRes = await _repository.getMyAchievements();
    if (myRes.isSuccess && myRes.data != null) {
      earnedAchievements.value = myRes.data!;
    } else {
      earnedAchievements.clear();
    }

    isLoadingAchievements.value = false;
  }

  List<AchievementModel> get filteredAchievements {
    if (selectedCategory.value == 'ALL') {
      return achievements;
    }
    return achievements
        .where((a) => a.category.toUpperCase() == selectedCategory.value.toUpperCase())
        .toList();
  }

  int get earnedCount => achievements.where((a) => a.earned).length;
}
