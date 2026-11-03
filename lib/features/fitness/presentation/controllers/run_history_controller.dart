import 'package:get/get.dart';
import '../../data/local/run_session_repository.dart';
import '../../data/models/run_session.dart';
import '../../data/models/workout_model.dart';
import '../../data/repositories/fitness_workout_repository.dart';

class RunHistoryController extends GetxController {
  final RunSessionRepository _sessionRepository;
  final FitnessWorkoutRepository _workoutRepository;

  RunHistoryController({
    RunSessionRepository? sessionRepository,
    FitnessWorkoutRepository? workoutRepository,
  })  : _sessionRepository = sessionRepository ?? RunSessionRepository(),
        _workoutRepository = workoutRepository ?? FitnessWorkoutRepository();

  final sessions = <RunSession>[].obs;
  final remoteWorkouts = <WorkoutHistoryItemModel>[].obs;
  final isLoading = false.obs;

  bool get hasRemote => remoteWorkouts.isNotEmpty;
  int get totalCount => hasRemote ? remoteWorkouts.length : sessions.length;

  @override
  void onInit() {
    super.onInit();
    loadAllHistory();
  }

  Future<void> loadAllHistory() async {
    isLoading.value = true;

    await _sessionRepository.init();
    final localSessions = await _sessionRepository.getAllSessions();
    localSessions.sort((a, b) => b.startedAt.compareTo(a.startedAt));

    final remoteRes = await _workoutRepository.getWorkoutHistory();
    List<WorkoutHistoryItemModel> remotes = [];
    if (remoteRes.isSuccess && remoteRes.data != null) {
      remotes = remoteRes.data!;
      remotes.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    }

    sessions.assignAll(localSessions);
    remoteWorkouts.assignAll(remotes);
    isLoading.value = false;
  }
}
