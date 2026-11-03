import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/storage/user_manager.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/base/base_controller.dart';
import '../../data/models/group_challenge_model.dart';
import '../../data/repositories/fitness_challenge_repository.dart';
import 'package:movem/core/utils/app_snack.dart';

class ClubChallengeDetailController extends BaseController {
  ClubChallengeDetailController(this.initialChallenge);

  final GroupFitnessChallengeModel initialChallenge;
  final FitnessChallengeRepository _repository = FitnessChallengeRepository();

  late final Rx<GroupFitnessChallengeModel> challenge;
  final participants = <ChallengeParticipantModel>[].obs;
  final isJoined = false.obs;
  final isJoining = false.obs;
  // False until the caller's participation is known, so the join button is
  // not offered to someone who has already joined.
  final isParticipationLoaded = false.obs;

  int? get _currentUserId => int.tryParse(UserManager().userId ?? '');

  /// The user who created the challenge cannot join it.
  bool get isOwner {
    final userId = _currentUserId;
    return userId != null &&
        challenge.value.createdBy != 0 &&
        challenge.value.createdBy == userId;
  }

  bool get canJoin => !isOwner && !isJoined.value && isParticipationLoaded.value;

  static bool _isJoinedStatus(String status) {
    final value = status.toUpperCase();
    return value == 'ACTIVE' || value == 'COMPLETED';
  }

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

    final userId = _currentUserId;
    final inParticipants = userId != null &&
        participants.any((p) => p.userId == userId && _isJoinedStatus(p.status));

    final mine = await _repository.getMyParticipation(challenge.value.id);
    isJoined.value = challenge.value.isJoined ||
        inParticipants ||
        (mine.isSuccess && mine.data != null && _isJoinedStatus(mine.data!.status));
    isParticipationLoaded.value = true;
  }

  Future<void> joinChallenge() async {
    if (isJoining.value || !canJoin) return;
    isJoining.value = true;
    final res = await _repository.joinChallenge(challenge.value.id);
    isJoining.value = false;

    if (res.isSuccess) {
      isJoined.value = true;
      await loadParticipants();
      AppSnack.show(
        _l10n?.joinedTitle ?? 'Joined',
        _l10n?.youJoinedChallenge(challenge.value.name) ??
            'You joined ${challenge.value.name}.',
        backgroundColor: const Color(0xFF48A45B),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    AppSnack.show(
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
