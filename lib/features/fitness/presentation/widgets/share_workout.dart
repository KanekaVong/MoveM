import 'package:get/get.dart';
import 'package:movem/core/utils/app_snack.dart';
import '../../../home/presentation/controllers/home_controller.dart';
import '../../data/models/workout_model.dart';
import '../../data/repositories/fitness_workout_repository.dart';

bool _isSharing = false;

/// Shares the finished workout to the social feed via
/// PATCH fitness/workouts/{sessionId}/share.
Future<void> shareWorkout(int? sessionId) async {
  if (_isSharing) return;
  if (sessionId == null || sessionId <= 0) {
    AppSnack.show(
      'Share Workout',
      'This workout was not saved to the server, so it cannot be shared.',
      snackPosition: SnackPosition.BOTTOM,
    );
    return;
  }

  _isSharing = true;
  try {
    final result = await FitnessWorkoutRepository().updateWorkoutSharing(
      sessionId,
      ShareWorkoutRequest(shared: true),
    );

    Get.closeAllSnackbars();
    if (result.isSuccess) {
      AppSnack.show(
        'Shared',
        'Your workout is now on the social feed.',
        snackPosition: SnackPosition.BOTTOM,
      );
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchSocialFeed();
      }
    } else {
      AppSnack.show(
        'Share failed',
        result.exception?.message ?? 'Could not share this workout. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  } finally {
    _isSharing = false;
  }
}
