import 'package:get/get.dart';

import '../../../fitness/data/models/achievement_model.dart';
import '../../../fitness/data/models/fitness_statistics_model.dart';
import '../../../fitness/data/repositories/fitness_achievement_repository.dart';
import '../../../fitness/data/repositories/fitness_profile_repository.dart';
import '../../../task/data/dto/response/task_statistics_response.dart';
import '../../../task/data/services/task_service.dart';
import '../../../trip/data/dto/response/trip_summary_response.dart';
import '../../../trip/data/repositories/trip_repository_impl.dart';
import '../../../trip/data/services/trip_service.dart';

class ProfileOverviewController extends GetxController {
  final isLoading = true.obs;
  final taskStats = Rxn<TaskStatisticsResponse>();
  final fitness = Rxn<FitnessStatisticsModel>();
  final achievements = <AchievementModel>[].obs;
  final achievementCount = 0.obs;
  final daysUntilTrip = RxnInt();
  final completedTrips = 0.obs;

  static const int fallbackStepGoal = 5000;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    await Future.wait([
      _loadTasks(),
      _loadFitness(),
      _loadAchievements(),
      _loadTrips(),
    ]);
    isLoading.value = false;
  }

  int get completedTasks => taskStats.value?.completedTasks ?? 0;

  int get taskTotal {
    final stats = taskStats.value;
    if (stats == null) return 0;
    final total = stats.completedTasks + stats.activeTasks;
    return total > 0 ? total : stats.completedTasks;
  }

  double get taskProgress {
    final total = taskTotal;
    if (total <= 0) return 0;
    return (completedTasks / total).clamp(0.0, 1.0);
  }

  int get stepsToday => fitness.value?.stepsToday ?? 0;

  int get stepGoal {
    final goals = fitness.value?.metricGoals ?? const [];
    for (final goal in goals) {
      if (goal.metricType == 'DAILY_STEPS' && goal.target > 0) {
        return goal.target.round();
      }
    }
    return fallbackStepGoal;
  }

  double get stepProgress {
    final goal = stepGoal;
    if (goal <= 0) return 0;
    return (stepsToday / goal).clamp(0.0, 1.0);
  }

  int get totalWorkouts => fitness.value?.totalWorkouts ?? 0;

  Future<void> _loadTasks() async {
    try {
      final response = await TaskService().getTaskStatistics();
      final data = response.data;
      if (data is Map) {
        taskStats.value = TaskStatisticsResponse.fromJson(Map<String, dynamic>.from(data));
      }
    } catch (_) {}
  }

  Future<void> _loadFitness() async {
    final result = await FitnessProfileRepository().getFitnessStatistics();
    if (result.isSuccess && result.data != null) {
      fitness.value = result.data;
    }
  }

  Future<void> _loadAchievements() async {
    final repo = FitnessAchievementRepository();
    final all = await repo.getAllAchievements();
    if (all.isSuccess && all.data != null) {
      final list = all.data!;
      list.sort((a, b) {
        if (a.earned != b.earned) return a.earned ? -1 : 1;
        return b.progressPercentage.compareTo(a.progressPercentage);
      });
      achievements.assignAll(list);
      achievementCount.value = list.where((item) => item.earned).length;
    }
    final count = await repo.getMyAchievementCount();
    if (count.isSuccess && count.data != null) {
      achievementCount.value = count.data!;
    }
  }

  Future<void> _loadTrips() async {
    final result = await TripRepositoryImpl(tripService: TripService()).getMyTrips();
    if (!result.isSuccess || result.data == null) return;
    final trips = result.data!;
    completedTrips.value =
        trips.where((trip) => trip.status?.toUpperCase() == 'COMPLETE').length;
    daysUntilTrip.value = _daysUntilNextTrip(trips);
  }

  int? _daysUntilNextTrip(List<TripSummaryResponse> trips) {
    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    DateTime? soonest;
    for (final trip in trips) {
      final status = trip.status?.toUpperCase();
      if (status == 'CANCELLED' || status == 'DELETED' || status == 'COMPLETE') continue;
      final start = trip.startActivity;
      if (start == null) continue;
      final day = DateTime(start.year, start.month, start.day);
      if (day.isBefore(startOfToday)) continue;
      if (soonest == null || day.isBefore(soonest)) soonest = day;
    }
    if (soonest == null) return null;
    return soonest.difference(startOfToday).inDays;
  }
}
