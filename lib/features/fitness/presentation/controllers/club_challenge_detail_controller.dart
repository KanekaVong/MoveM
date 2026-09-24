import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/base/base_controller.dart';
import '../../data/models/group_challenge_model.dart';
import '../../data/repositories/fitness_challenge_repository.dart';

class ClubChallengeDetailController extends BaseController {
  ClubChallengeDetailController(this.initialChallenge);

  final GroupFitnessChallengeModel initialChallenge;
  final FitnessChallengeRepository _repository = FitnessChallengeRepository();

  late final Rx<GroupFitnessChallengeModel> challenge;
  final participants = <ChallengeParticipantModel>[].obs;
  final isJoined = false.obs;
  final isJoining = false.obs;

  AppLocalizations? get _l10n {
    final ctx = Get.context;
    return ctx == null ? null : AppLocalizations.of(ctx);
  }

  @override
  void onInit() {
    super.onInit();
    challenge = Rx<GroupFitnessChallengeModel>(initialChallenge);
    isJoined.value = initialChallenge.isJoined;
    load();
  }

  Future<void> load() async {
    final detail = await _repository.getChallenge(initialChallenge.id);
    if (detail.isSuccess && detail.data != null) {
      challenge.value = detail.data!;
    }
    await loadParticipants();
  }

  Future<void> loadParticipants() async {
    final res = await _repository.getChallengeParticipants(challenge.value.id);
    if (res.isSuccess && res.data != null) {
      participants.value = res.data!;
    }

    final mine = await _repository.getMyParticipation(challenge.value.id);
    isJoined.value = challenge.value.isJoined ||
        (mine.isSuccess && mine.data != null && mine.data!.status == 'ACTIVE');
  }

  Future<void> joinChallenge() async {
    if (isJoining.value) return;
    isJoining.value = true;
    final res = await _repository.joinChallenge(challenge.value.id);
    isJoining.value = false;

    if (res.isSuccess) {
      isJoined.value = true;
      await loadParticipants();
      Get.snackbar(
        _l10n?.joinedTitle ?? 'Joined',
        _l10n?.youJoinedChallenge(challenge.value.name) ??
            'You joined ${challenge.value.name}.',
        backgroundColor: const Color(0xFF48A45B),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.snackbar(
      _l10n?.errorTitle ?? 'Error',
      res.exception?.message ??
          _l10n?.failedToJoinChallenge ??
          'Could not join this challenge.',
      backgroundColor: const Color(0xFFEF4444),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
