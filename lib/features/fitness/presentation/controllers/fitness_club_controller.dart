import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../shared/base/base_controller.dart';
import '../../data/models/fitness_club_model.dart';
import '../../data/models/group_challenge_model.dart';
import '../../data/repositories/fitness_club_repository.dart';
import '../../data/repositories/fitness_challenge_repository.dart';

class FitnessClubController extends BaseController {
  final FitnessClubRepository _clubRepo = FitnessClubRepository();
  final FitnessChallengeRepository _challengeRepo = FitnessChallengeRepository();

  final myClubs = <FitnessClubModel>[].obs;
  final publicClubs = <FitnessClubModel>[].obs;
  final searchResults = <FitnessClubModel>[].obs;

  final isLoadingMyClubs = false.obs;
  final isLoadingPublicClubs = false.obs;
  final isSearching = false.obs;

  final selectedClub = Rxn<FitnessClubModel>();
  final clubMembers = <FitnessClubMemberModel>[].obs;
  final clubChallenges = <GroupFitnessChallengeModel>[].obs;
  final joinRequests = <ClubJoinRequestModel>[].obs;
  final isLoadingClubDetails = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadClubs();
  }

  Future<void> loadClubs() async {
    await Future.wait([
      fetchMyClubs(),
      fetchPublicClubs(),
    ]);
  }

  Future<void> fetchMyClubs() async {
    isLoadingMyClubs.value = true;
    final result = await _clubRepo.getMyClubs();
    if (result.isSuccess && result.data != null) {
      myClubs.value = result.data!;
    }
    isLoadingMyClubs.value = false;
  }

  Future<void> fetchPublicClubs() async {
    isLoadingPublicClubs.value = true;
    final result = await _clubRepo.getPublicClubs();
    if (result.isSuccess && result.data != null) {
      publicClubs.value = result.data!;
    }
    isLoadingPublicClubs.value = false;
  }

  Future<void> searchClubs(String query) async {
    if (query.trim().isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }
    isSearching.value = true;
    final result = await _clubRepo.searchClubs(query.trim());
    if (result.isSuccess && result.data != null) {
      searchResults.value = result.data!;
    } else {
      searchResults.clear();
    }
    isSearching.value = false;
  }

  Future<FitnessClubModel?> createClub({
    required String name,
    required String description,
    required String privacy,
  }) async {
    if (name.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a club name');
      return null;
    }

    FitnessClubModel? createdClub;
    final req = CreateFitnessClubRequest(
      name: name.trim(),
      description: description.trim(),
      privacy: privacy.toUpperCase(),
    );

    await executeApi<FitnessClubModel>(
      apiCall: () => _clubRepo.createClub(req),
      onSuccess: (club) {
        createdClub = club;
        myClubs.insert(0, club);
        Get.back();
        Get.snackbar(
          'Success',
          'Club "${club.name}" created successfully!',
          backgroundColor: const Color(0xFF48A45B),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      onError: (e) {
        Get.snackbar(
          'Error',
          'Failed to create club. Please try again.',
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
    return createdClub;
  }

  Future<bool> addMember(int clubId, int userId) async {
    final result = await _clubRepo.addMember(clubId, userId);
    return result.isSuccess;
  }

  Future<void> joinClub(FitnessClubModel club) async {
    await executeApi<FitnessClubMemberModel>(
      apiCall: () => _clubRepo.joinClub(club.id),
      onSuccess: (member) {
        final updated = FitnessClubModel(
          id: club.id,
          name: club.name,
          description: club.description,
          createdBy: club.createdBy,
          privacy: club.privacy,
          joinToken: club.joinToken,
          createdAt: club.createdAt,
          updatedAt: club.updatedAt,
          memberCount: club.memberCount + 1,
          isMember: true,
          userRole: 'MEMBER',
        );
        myClubs.removeWhere((c) => c.id == club.id);
        myClubs.insert(0, updated);

        final idx = publicClubs.indexWhere((c) => c.id == club.id);
        if (idx >= 0) {
          publicClubs[idx] = updated;
        }

        Get.snackbar(
          'Joined!',
          'You are now a member of ${club.name}',
          backgroundColor: const Color(0xFF48A45B),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      onError: (e) {
        Get.snackbar(
          'Error',
          'Failed to join club. Please try again.',
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Future<void> requestToJoin(FitnessClubModel club) async {
    await executeApi<ClubJoinRequestModel>(
      apiCall: () => _clubRepo.requestToJoin(club.id),
      onSuccess: (_) {
        Get.snackbar(
          'Request Sent',
          'Your join request for ${club.name} is pending review.',
          backgroundColor: const Color(0xFF2563EB),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      onError: (e) {
        Get.snackbar(
          'Error',
          'Failed to submit join request. Please try again.',
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Future<void> loadClubDetails(int clubId) async {
    isLoadingClubDetails.value = true;
    clubMembers.clear();
    clubChallenges.clear();
    joinRequests.clear();

    final clubRes = await _clubRepo.getClub(clubId);
    if (clubRes.isSuccess && clubRes.data != null) {
      selectedClub.value = clubRes.data;
    }

    final membersRes = await _clubRepo.getClubMembers(clubId);
    if (membersRes.isSuccess && membersRes.data != null) {
      clubMembers.value = membersRes.data!;
    }

    final challengesRes = await _challengeRepo.getClubChallenges(clubId);
    if (challengesRes.isSuccess && challengesRes.data != null) {
      clubChallenges.value = challengesRes.data!;
    }

    if (selectedClub.value?.isOwner == true) {
      final requestsRes = await _clubRepo.getJoinRequests(clubId);
      if (requestsRes.isSuccess && requestsRes.data != null) {
        joinRequests.value = requestsRes.data!;
      }
    }

    isLoadingClubDetails.value = false;
  }

  Future<bool> createClubChallenge({
    required int clubId,
    required String name,
    required String type,
    required int targetValue,
    required String targetUnit,
    required String description,
  }) async {
    final data = {
      'name': name,
      'type': type,
      'targetValue': targetValue,
      'targetUnit': targetUnit,
      'description': description,
    };
    final res = await _challengeRepo.createClubChallenge(clubId, data);
    if (res.isSuccess && res.data != null) {
      clubChallenges.insert(0, res.data!);
      Get.snackbar(
        'Success',
        'Club challenge "${res.data!.name}" created!',
        backgroundColor: const Color(0xFF48A45B),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    }
    return false;
  }
}
