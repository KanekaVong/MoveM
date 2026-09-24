import 'package:get/get.dart';
import '../../data/models/workout_model.dart';
import '../../data/repositories/fitness_workout_repository.dart';

class WorkoutHistoryController extends GetxController {
  final FitnessWorkoutRepository _repository = FitnessWorkoutRepository();

  final items = <WorkoutHistoryItemModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _repository.getWorkoutHistory();
    if (result.isSuccess && result.data != null) {
      final list = List<WorkoutHistoryItemModel>.from(result.data!);
      list.sort((a, b) => b.startedAt.compareTo(a.startedAt));
      items.assignAll(list);
    } else {
      items.clear();
      errorMessage.value = result.exception?.message ?? 'Failed to load workout history';
    }

    isLoading.value = false;
  }
}
