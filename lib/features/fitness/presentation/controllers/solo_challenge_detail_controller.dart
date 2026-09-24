import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../shared/base/base_controller.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../data/models/solo_challenge_model.dart';
import '../../data/repositories/fitness_challenge_repository.dart';
import '../screens/push_up_countdown_screen.dart';
import '../screens/running_tracking_screen.dart';

class SoloChallengeDetailController extends BaseController {
  final FitnessChallengeRepository _repository;
  late final Rx<SoloChallengeModel> challenge;
  final isFetchingDetail = false.obs;
  final isFetchingMore = false.obs;
  final moreChallenges = <SoloChallengeModel>[].obs;

  SoloChallengeDetailController({
    required SoloChallengeModel initialChallenge,
    FitnessChallengeRepository? repository,
  }) : _repository = repository ?? FitnessChallengeRepository() {
    challenge = Rx<SoloChallengeModel>(initialChallenge);
  }

  @override
  void onInit() {
    super.onInit();
    if (challenge.value.id > 0) {
      fetchChallengeDetail();
    }
    fetchMoreChallenges();
  }

  Future<void> fetchMoreChallenges() async {
    isFetchingMore.value = true;
    try {
      final res = await _repository.getSoloChallenges();
      if (res.isSuccess && res.data != null && res.data!.isNotEmpty) {
        final currentId = challenge.value.id;
        final currentName = challenge.value.name.toLowerCase().trim();
        final filtered = res.data!.where((item) {
          if (currentId > 0 && item.id == currentId) return false;
          if (item.name.toLowerCase().trim() == currentName) return false;
          return true;
        }).take(3).toList();

        if (filtered.isNotEmpty) {
          moreChallenges.value = filtered;
        } else {
          moreChallenges.value = res.data!.take(3).toList();
        }
      } else {
        _applyFallbackChallenges();
      }
    } catch (_) {
      _applyFallbackChallenges();
    } finally {
      isFetchingMore.value = false;
    }
  }

  void _applyFallbackChallenges() {
    final currentId = challenge.value.id;
    final currentName = challenge.value.name.toLowerCase().trim();
    final fallbacks = [
      SoloChallengeModel.sprintChallenge,
      SoloChallengeModel.pushUpChallenge,
      SoloChallengeModel(
        id: 103,
        name: 'Squats Challenge',
        type: 'SQUATS',
        workoutLevel: 'BEGINNER',
        targetValue: 45,
        targetUnit: 'Reps',
        calories: 150,
        description: 'Lower hips from standing position then stand back up.',
        sets: 3,
        repsPerSet: 15,
        progress: 0.25,
        category: 'Strength',
        heroImagePath: AppImages.squatsActivity,
        imagePath: AppImages.squatsActivity,
      ),
      SoloChallengeModel(
        id: 104,
        name: 'Pull ups',
        type: 'PULL_UPS',
        workoutLevel: 'INTERMEDIATE',
        targetValue: 20,
        targetUnit: 'Reps',
        calories: 130,
        description: 'Upper-body exercise where you pull yourself up to a bar.',
        sets: 4,
        repsPerSet: 5,
        progress: 0.15,
        category: 'Upper Body',
        heroImagePath: AppImages.pullUpsActivity,
        imagePath: AppImages.pullUpsActivity,
      ),
    ];

    final filtered = fallbacks.where((item) {
      if (currentId > 0 && item.id == currentId) return false;
      if (item.name.toLowerCase().trim() == currentName) return false;
      return true;
    }).take(3).toList();

    moreChallenges.value = filtered;
  }

  Future<void> fetchChallengeDetail() async {
    isFetchingDetail.value = true;
    await executeApi<SoloChallengeModel>(
      showLoading: false,
      showErrorDialog: false,
      apiCall: () => _repository.getSoloChallenge(challenge.value.id),
      onSuccess: (data) {
        challenge.value = data;
        isFetchingDetail.value = false;
      },
      onError: (e) {
        isFetchingDetail.value = false;
      },
    );
  }

  bool get isRunning {
    final c = challenge.value;
    final t = c.type.toUpperCase();
    final n = c.name.toLowerCase();
    final u = c.targetUnit.toUpperCase();
    return t == 'RUNNING' || n.contains('run') || n.contains('sprint') || (t != 'BODYWEIGHT' && (u == 'KM' || u == 'STEPS'));
  }

  bool get isPushUp {
    final c = challenge.value;
    final t = c.type.toUpperCase();
    final n = c.name.toLowerCase();
    return t == 'PUSH_UP' || n.contains('push');
  }

  bool get isSquats {
    final c = challenge.value;
    final t = c.type.toUpperCase();
    final n = c.name.toLowerCase();
    return t == 'SQUATS' || ((t == 'BODYWEIGHT' || t == 'STRENGTH_TRAINING') && n.contains('squat')) || n.contains('squat');
  }

  bool get isImplemented => isRunning || isPushUp || isSquats;

  String get formattedTitle {
    final c = challenge.value;
    if (c.name.isNotEmpty) {
      return c.name;
    }

    if (isRunning) {
      if (c.targetValue > 0 && c.targetUnit.isNotEmpty) {
        return '${c.targetValue} ${c.targetUnit} Running';
      }
      return 'Running Challenge';
    }

    if (c.sets > 0 && c.repsPerSet > 0) {
      final t = c.type.toUpperCase();
      final n = c.name.toLowerCase();
      final unit = isPushUp
          ? 'Push Up'
          : (isSquats
              ? 'Squats'
              : (t.contains('PULL') || n.contains('pull')
                  ? 'Pull Ups'
                  : (c.targetUnit.isNotEmpty ? c.targetUnit : 'Reps')));
      return '${c.sets} Sets of ${c.repsPerSet} $unit';
    }

    if (c.targetValue > 0 && c.targetUnit.isNotEmpty) {
      return '${c.targetValue} ${c.targetUnit} ${c.type}';
    }

    return 'Workout Challenge';
  }

  String get formattedDescription {
    final c = challenge.value;
    if (c.description.isNotEmpty) {
      return c.description;
    }
    if (isRunning) {
      return 'Run and track your route, pace, distance, and calories burned in real time.';
    }
    if (isSquats) {
      return 'Lower hips from standing position then stand back up to build leg and core strength.';
    }
    if (isPushUp) {
      return "An exercise done to improve upper body strength, performed by resting on one's toes and hands and pushing one's weight off the floor";
    }
    return 'Challenge yourself and stay consistent to achieve your personal fitness targets.';
  }

  Future<bool> checkAndRequestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationServiceDialog();
        return false;
      }
      return true;
    }

    if (status.isPermanentlyDenied) {
      _showOpenSettingsDialog();
      return false;
    }

    status = await Permission.location.request();
    if (status.isGranted) {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationServiceDialog();
        return false;
      }
      return true;
    }

    if (status.isPermanentlyDenied) {
      _showOpenSettingsDialog();
      return false;
    }

    Get.snackbar(
      'Location Required',
      'Location access is needed to track your running distance, pace, and route.',
      backgroundColor: AppColors.textPrimary,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 4),
    );
    return false;
  }

  void _showOpenSettingsDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.cardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFF5252).withValues(alpha: 0.15),
                  border: Border.all(
                    color: const Color(0xFFFF5252).withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.location_off_rounded,
                  color: Color(0xFFFF5252),
                  size: 28,
                ),
              ),
              SizedBox(height: 18),
              Text(
                'Location Access Required',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'MoveM needs location access to track your GPS route, distance, and pace. Please enable location permissions in your device settings.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: AppButton.secondary(
                      label: 'Cancel',
                      onPressed: () => Get.back(),
                      height: 46,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      label: 'Settings',
                      onPressed: () {
                        Get.back();
                        openAppSettings();
                      },
                      height: 46,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLocationServiceDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.cardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFB300).withValues(alpha: 0.15),
                  border: Border.all(
                    color: const Color(0xFFFFB300).withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.gps_off_rounded,
                  color: Color(0xFFFFB300),
                  size: 28,
                ),
              ),
              SizedBox(height: 18),
              Text(
                'Location Service Disabled',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Please turn on GPS / Location service on your device so MoveM can record your run.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: AppButton.secondary(
                      label: 'Cancel',
                      onPressed: () => Get.back(),
                      height: 46,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      label: 'Turn On',
                      onPressed: () {
                        Get.back();
                        Geolocator.openLocationSettings();
                      },
                      height: 46,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> startRunningWorkout([SoloChallengeModel? customChallenge]) async {
    final granted = await checkAndRequestLocationPermission();
    if (granted) {
      Get.to(() => RunningTrackingScreen(challenge: customChallenge ?? SoloChallengeModel.sprintChallenge));
    }
  }

  Future<void> startWorkout(VoidCallback onShowComingSoon) async {
    final c = challenge.value;
    if (isRunning) {
      final granted = await checkAndRequestLocationPermission();
      if (granted) {
        Get.to(() => RunningTrackingScreen(challenge: c));
      }
    } else if (isSquats || isPushUp) {
      Get.to(() => PushUpCountdownScreen(challenge: c));
    } else {
      onShowComingSoon();
    }
  }
}
