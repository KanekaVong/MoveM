import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:movem/core/utils/app_snack.dart';
import '../../../home/presentation/controllers/home_controller.dart';
import '../../data/models/workout_model.dart';
import '../../data/repositories/fitness_workout_repository.dart';
import 'package:movem/core/utils/l10n.dart';

bool _isSharing = false;
final Set<int> _uploadedImageSessions = {};

/// Shares the finished workout to the social feed via
/// PATCH fitness/workouts/{sessionId}/share.
///
/// [captureImage] (e.g. a route map snapshot) is uploaded once as a workout
/// attachment first, so the feed card can show it. A failed upload doesn't
/// block sharing.
Future<void> shareWorkout(int? sessionId, {Future<Uint8List?> Function()? captureImage}) async {
  if (_isSharing) return;
  if (sessionId == null || sessionId <= 0) {
    AppSnack.show(
      tr.shareWorkout,
      tr.shareNotSaved,
      snackPosition: SnackPosition.BOTTOM,
    );
    return;
  }

  _isSharing = true;
  AppSnack.show(
    tr.sharing,
    tr.postingWorkout,
    snackPosition: SnackPosition.BOTTOM,
  );
  try {
    final repository = FitnessWorkoutRepository();
    if (captureImage != null && !_uploadedImageSessions.contains(sessionId)) {
      final bytes = await captureImage();
      if (bytes != null && bytes.isNotEmpty) {
        final upload = await repository.uploadWorkoutAttachment(sessionId, bytes, 'route_$sessionId.png');
        if (upload.isSuccess) _uploadedImageSessions.add(sessionId);
      }
    }

    final result = await repository.updateWorkoutSharing(
      sessionId,
      ShareWorkoutRequest(shared: true),
    );

    Get.closeAllSnackbars();
    if (result.isSuccess) {
      AppSnack.show(
        tr.shared,
        tr.workoutShared,
        snackPosition: SnackPosition.BOTTOM,
      );
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchSocialFeed();
      }
    } else {
      AppSnack.show(
        tr.shareFailed,
        result.exception?.message ?? tr.couldNotShareWorkout,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  } finally {
    _isSharing = false;
  }
}
