import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/base/base_controller.dart';
import '../../../friends/data/services/friends_service.dart';
import '../../../friends/presentation/controllers/friends_controller.dart';
import '../../data/models/fitness_club_model.dart';
import '../../data/models/group_challenge_model.dart';
import '../../data/repositories/fitness_club_repository.dart';
import '../../data/repositories/fitness_challenge_repository.dart';

class FitnessClubController extends BaseController {
  AppLocalizations? get _l10n {
    final ctx = Get.context;
    return ctx == null ? null : AppLocalizations.of(ctx);
  }

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
  final catalogChallenges = <GroupChallengeCatalogModel>[].obs;
  final joinRequests = <ClubJoinRequestModel>[].obs;
  final inboxInvitations = <ClubJoinRequestModel>[].obs;
  final inboxJoinRequests = <ClubJoinRequestModel>[].obs;
  final isLoadingInbox = false.obs;
  final actingRequestId = 0.obs;
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
      Get.snackbar(_l10n?.errorTitle ?? 'Error', _l10n?.pleaseEnterClubName ?? 'Please enter a club name');
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
          _l10n?.success ?? 'Done',
          _l10n?.clubCreatedMsg(club.name) ?? 'Club "${club.name}" created successfully!',
          backgroundColor: const Color(0xFF48A45B),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      onError: (e) {
        Get.snackbar(
          _l10n?.errorTitle ?? 'Error',
          _l10n?.failedToCreateClub ?? 'Failed to create club. Please try again.',
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

  Future<bool> removeMember(int clubId, int userId) async {
    final result = await _clubRepo.removeMember(clubId, userId);
    if (result.isSuccess) {
      clubMembers.removeWhere((m) => m.userId == userId);
      return true;
    }
    Get.snackbar(
      _l10n?.errorTitle ?? 'Error',
      result.exception?.message ?? _l10n?.failedToRemoveMember ?? 'Failed to remove member.',
      backgroundColor: const Color(0xFFEF4444),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
    return false;
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
          _l10n?.joinedTitle ?? 'Joined!',
          _l10n?.joinedClubMsg(club.name) ?? 'You are now a member of ${club.name}',
          backgroundColor: const Color(0xFF48A45B),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      onError: (e) {
        Get.snackbar(
          _l10n?.errorTitle ?? 'Error',
          _l10n?.failedToJoinClub ?? 'Failed to join club. Please try again.',
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
          _l10n?.requestSentTitle ?? 'Request Sent',
          _l10n?.joinRequestSentMsg(club.name) ?? 'Your join request for ${club.name} is pending review.',
          backgroundColor: const Color(0xFF2563EB),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      onError: (e) {
        Get.snackbar(
          _l10n?.errorTitle ?? 'Error',
          _l10n?.failedToSubmitJoinRequest ?? 'Failed to submit join request. Please try again.',
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
    catalogChallenges.clear();
    joinRequests.clear();

    final catalogRes = await _challengeRepo.getCatalogChallenges();
    if (catalogRes.isSuccess && catalogRes.data != null) {
      catalogChallenges.value = catalogRes.data!;
    }

    final clubRes = await _clubRepo.getClub(clubId);
    if (clubRes.isSuccess && clubRes.data != null) {
      selectedClub.value = clubRes.data;
    }

    final membersRes = await _clubRepo.getClubMembers(clubId);
    if (membersRes.isSuccess && membersRes.data != null) {
      clubMembers.value = await _enrichMemberNames(membersRes.data!);
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
    required String workoutType,
    required double targetValue,
    required String targetUnit,
    required String description,
    required DateTime startAt,
    required DateTime endAt,
  }) async {
    final data = {
      'name': name,
      'workoutType': workoutType,
      'targetValue': targetValue,
      'targetUnit': targetUnit,
      'description': description,
      'startAt': _toInstant(startAt),
      'endAt': _toInstant(endAt),
    };
    final res = await _challengeRepo.createClubChallenge(clubId, data);
    if (res.isSuccess && res.data != null) {
      clubChallenges.insert(0, res.data!);
      Get.snackbar(
        _l10n?.success ?? 'Done',
        _l10n?.challengeCreatedMsg(res.data!.name) ?? 'Club challenge "${res.data!.name}" created!',
        backgroundColor: const Color(0xFF48A45B),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    }
    Get.snackbar(
      _l10n?.errorTitle ?? 'Error',
      res.exception?.message ?? _l10n?.failedToCreateChallenge ?? 'Failed to create challenge. Please try again.',
      backgroundColor: const Color(0xFFEF4444),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
    return false;
  }

  List<GroupFitnessChallengeModel> get customClubChallenges {
    return clubChallenges.where((c) => !_isFeaturedChallenge(c)).toList();
  }

  List<GroupFitnessChallengeModel> get recommendedClubChallenges {
    return clubChallenges.where(_isFeaturedChallenge).toList();
  }

  bool _isFeaturedChallenge(GroupFitnessChallengeModel challenge) {
    final source = (challenge.challengeSource ?? '').toUpperCase();
    if (source == 'RECOMMENDED') return true;
    if (source == 'CUSTOM') return false;
    return challenge.catalogId != null;
  }

  List<GroupFitnessChallengeModel> get activeClubChallenges {
    return clubChallenges.where((c) {
      final status = c.status.toUpperCase();
      return status != 'COMPLETE' && status != 'CANCELLED';
    }).toList();
  }

  Future<GroupFitnessChallengeModel?> startCatalogChallenge({
    required int clubId,
    required GroupChallengeCatalogModel catalog,
  }) async {
    final existing = clubChallenges.where((c) => c.catalogId == catalog.id);
    if (existing.isNotEmpty) return existing.first;

    final now = DateTime.now();
    final startAt = DateTime(now.year, now.month, now.day + 1, 5, 30);
    final endAt = startAt.add(const Duration(hours: 2));
    final res = await _challengeRepo.createClubChallengeFromCatalog(
      clubId,
      catalog.id,
      startAt: _toInstant(startAt),
      endAt: _toInstant(endAt),
    );
    if (res.isSuccess && res.data != null) {
      clubChallenges.insert(0, res.data!);
      return res.data;
    }
    Get.snackbar(
      _l10n?.errorTitle ?? 'Error',
      res.exception?.message ?? _l10n?.failedToCreateChallenge ?? 'Failed to create challenge. Please try again.',
      backgroundColor: const Color(0xFFEF4444),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
    return null;
  }

  Future<void> loadInbox() async {
    isLoadingInbox.value = true;
    if (myClubs.isEmpty) {
      await fetchMyClubs();
    }

    final mineRes = await _clubRepo.getMyRequests();
    if (mineRes.isSuccess && mineRes.data != null) {
      final pending = mineRes.data!
          .where((r) => r.status.toUpperCase() == 'PENDING')
          .toList();
      inboxInvitations.value = await _enrichJoinRequests(pending);
    } else {
      inboxInvitations.clear();
    }

    final owned = myClubs.toList();
    final incoming = <ClubJoinRequestModel>[];
    for (final club in owned) {
      final res = await _clubRepo.getJoinRequests(club.id);
      if (res.isSuccess && res.data != null) {
        incoming.addAll(
          res.data!
              .where((r) => r.status.toUpperCase() == 'PENDING')
              .map((r) => r.copyWith(clubName: r.clubName ?? club.name)),
        );
      }
    }
    inboxJoinRequests.value = await _enrichJoinRequests(incoming);
    isLoadingInbox.value = false;
  }

  Future<bool> approveJoinRequest(ClubJoinRequestModel request) async {
    actingRequestId.value = request.id;
    final res = await _clubRepo.approveRequest(request.clubId, request.id);
    actingRequestId.value = 0;
    if (res.isSuccess) {
      inboxJoinRequests.removeWhere((r) => r.id == request.id);
      await fetchMyClubs();
      return true;
    }
    Get.snackbar(
      _l10n?.errorTitle ?? 'Error',
      res.exception?.message ?? _l10n?.couldNotApproveRequest ?? 'Could not approve request.',
      backgroundColor: const Color(0xFFEF4444),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
    return false;
  }

  Future<bool> rejectJoinRequest(ClubJoinRequestModel request) async {
    actingRequestId.value = request.id;
    final res = await _clubRepo.rejectRequest(request.clubId, request.id);
    actingRequestId.value = 0;
    if (res.isSuccess) {
      inboxJoinRequests.removeWhere((r) => r.id == request.id);
      return true;
    }
    Get.snackbar(
      _l10n?.errorTitle ?? 'Error',
      res.exception?.message ?? _l10n?.couldNotRejectRequest ?? 'Could not reject request.',
      backgroundColor: const Color(0xFFEF4444),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
    return false;
  }

  Future<bool> cancelMyJoinRequest(ClubJoinRequestModel request) async {
    actingRequestId.value = request.id;
    final res = await _clubRepo.cancelMyRequest(request.id);
    actingRequestId.value = 0;
    if (res.isSuccess) {
      inboxInvitations.removeWhere((r) => r.id == request.id);
      return true;
    }
    Get.snackbar(
      _l10n?.errorTitle ?? 'Error',
      res.exception?.message ?? _l10n?.couldNotCancelRequest ?? 'Could not cancel request.',
      backgroundColor: const Color(0xFFEF4444),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
    return false;
  }

  Future<List<ClubJoinRequestModel>> _enrichJoinRequests(
    List<ClubJoinRequestModel> requests,
  ) async {
    final enriched = <ClubJoinRequestModel>[];
    for (final request in requests) {
      var name = request.requesterName;
      var clubName = request.clubName;

      if (clubName == null || clubName.isEmpty) {
        FitnessClubModel? known;
        for (final club in myClubs) {
          if (club.id == request.clubId) {
            known = club;
            break;
          }
        }
        if (known != null) {
          clubName = known.name;
        } else {
          final clubRes = await _clubRepo.getClub(request.clubId);
          if (clubRes.isSuccess && clubRes.data != null) {
            clubName = clubRes.data!.name;
          }
        }
      }

      if (name == null || name.startsWith('User #')) {
        try {
          final response = await FriendsService().getUserById(request.requesterId.toString());
          final data = response.data is Map
              ? Map<String, dynamic>.from(response.data as Map)
              : <String, dynamic>{};
          final user = data['user'] is Map
              ? Map<String, dynamic>.from(data['user'] as Map)
              : data;
          final first = user['firstname']?.toString() ?? user['firstName']?.toString() ?? '';
          final last = user['lastname']?.toString() ?? user['lastName']?.toString() ?? '';
          final username = user['username']?.toString() ?? '';
          final full = '$first $last'.trim();
          name = full.isNotEmpty ? full : (username.isNotEmpty ? username : name);
        } catch (_) {}
      }

      enriched.add(request.copyWith(requesterName: name, clubName: clubName));
    }
    return enriched;
  }

  List<GroupFitnessChallengeModel> get completedChallenges {
    return clubChallenges.where((c) {
      final status = c.status.toUpperCase();
      if (status == 'COMPLETE' || status == 'CANCELLED') return true;
      return c.endAt != null && c.endAt!.isBefore(DateTime.now());
    }).toList();
  }

  Future<List<FitnessClubMemberModel>> _enrichMemberNames(
    List<FitnessClubMemberModel> members,
  ) async {
    Map<int, _FriendLike> friendsById = {};
    if (Get.isRegistered<FriendsController>()) {
      final friends = Get.find<FriendsController>().friends;
      for (final f in friends) {
        friendsById[f.userId] = _FriendLike(
          name: '${f.firstname} ${f.lastname}'.trim().isNotEmpty
              ? '${f.firstname} ${f.lastname}'.trim()
              : f.username,
          avatar: f.profilePic,
        );
      }
    }

    final enriched = <FitnessClubMemberModel>[];
    for (final member in members) {
      var name = member.userName;
      var avatar = member.avatarUrl;
      final friend = friendsById[member.userId];
      if (friend != null) {
        if (name == null || name.startsWith('Member #')) name = friend.name;
        avatar ??= friend.avatar.isEmpty ? null : friend.avatar;
      }

      if (name == null || name.startsWith('Member #')) {
        try {
          final response = await FriendsService().getUserById(member.userId.toString());
          final data = response.data is Map
              ? Map<String, dynamic>.from(response.data as Map)
              : <String, dynamic>{};
          final user = data['user'] is Map
              ? Map<String, dynamic>.from(data['user'] as Map)
              : data;
          final first = user['firstname']?.toString() ?? user['firstName']?.toString() ?? '';
          final last = user['lastname']?.toString() ?? user['lastName']?.toString() ?? '';
          final username = user['username']?.toString() ?? '';
          final full = '$first $last'.trim();
          name = full.isNotEmpty ? full : (username.isNotEmpty ? username : name);
          avatar ??= user['profilePic']?.toString();
        } catch (_) {}
      }

      enriched.add(member.copyWith(userName: name, avatarUrl: avatar));
    }
    return enriched;
  }

  static String _toInstant(DateTime value) {
    final utc = value.toUtc();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${utc.year}-${two(utc.month)}-${two(utc.day)}T${two(utc.hour)}:${two(utc.minute)}:${two(utc.second)}Z';
  }
}

class _FriendLike {
  final String name;
  final String avatar;
  _FriendLike({required this.name, required this.avatar});
}
