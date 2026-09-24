import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/base/base_controller.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../friends/data/dto/response/friend_response.dart';
import '../../../friends/data/repositories/friends_repository_impl.dart';
import '../../../friends/data/services/friends_service.dart';
import '../../../friends/domain/repositories/friends_repository.dart';

import '../../../groups/domain/repositories/group_repository.dart';
import '../../../groups/data/repositories/group_repository_impl.dart';
import '../../../groups/data/services/group_service.dart';
import '../../../groups/data/dto/response/group_search_user_response.dart';
import '../../../groups/data/dto/response/pending_invite_response.dart';

class AddCollaboratorController extends BaseController {
  AppLocalizations? get _l10n {
    final ctx = Get.context;
    return ctx == null ? null : AppLocalizations.of(ctx);
  }
  final FriendsRepository friendsRepository = FriendsRepositoryImpl(friendsService: FriendsService());
  final GroupRepository groupRepository = GroupRepositoryImpl(groupService: GroupService());
  final searchController = TextEditingController();

  final RxList<FriendResponse> friends = <FriendResponse>[].obs;
  final RxList<FriendResponse> searchResults = <FriendResponse>[].obs;
  final RxSet<FriendResponse> selectedFriends = <FriendResponse>{}.obs;
  final RxString searchQuery = ''.obs;

  final RxSet<String> pendingInvitedUsernames = <String>{}.obs;
  final RxSet<int> pendingInvitedUserIds = <int>{}.obs;
  final RxSet<String> existingMemberUsernames = <String>{}.obs;
  final RxSet<int> existingMemberUserIds = <int>{}.obs;
  String? activityId;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Map) {
      final map = Get.arguments as Map;
      activityId = map['activityId']?.toString();
      final existing = map['collaborators'];
      if (existing is List) {
        for (var c in existing) {
          if (c is Map) {
            if (c['userId'] != null) {
              final id = int.tryParse(c['userId'].toString());
              if (id != null) existingMemberUserIds.add(id);
            }
            if (c['username'] != null) {
              existingMemberUsernames.add(c['username'].toString().toLowerCase());
            }
          }
        }
      }
    } else if (Get.arguments is String) {
      activityId = Get.arguments as String;
    }

    fetchFriends();
    if (activityId != null && activityId!.isNotEmpty) {
      fetchPendingInvites();
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchPendingInvites() async {
    if (activityId == null || activityId!.isEmpty) return;
    final result = await groupRepository.getPendingInvites(activityId!);
    if (result is ApiSuccess<List<PendingInviteResponse>>) {
      for (var invite in result.data) {
        if (invite.status.toUpperCase() == 'PENDING') {
          pendingInvitedUserIds.add(invite.inviteeId);
          pendingInvitedUsernames.add(invite.inviteeUsername.toLowerCase());
        }
      }
    }
  }

  bool isAlreadyMember(FriendResponse friend) {
    if (existingMemberUserIds.contains(friend.userId)) return true;
    if (existingMemberUsernames.contains(friend.username.toLowerCase())) return true;
    return false;
  }

  bool isAlreadyInvited(FriendResponse friend) {
    if (pendingInvitedUserIds.contains(friend.userId)) return true;
    if (pendingInvitedUsernames.contains(friend.username.toLowerCase())) return true;
    return false;
  }

  Future<void> fetchFriends() async {
    await executeApi<List<FriendResponse>>(
      apiCall: () => friendsRepository.getFriends(),
      showLoading: false,
      showErrorDialog: false,
      onSuccess: (data) {
        friends.assignAll(data);
      },
    );
  }

  Future<void> onSearchChanged(String query) async {
    searchQuery.value = query;
    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    final trimmed = query.trim();
    final groupResult = await groupRepository.searchUsers(trimmed);
    final friendsResult = await friendsRepository.searchFriends(trimmed);

    final Map<String, FriendResponse> combined = {};

    if (friendsResult is ApiSuccess<List<FriendResponse>>) {
      for (var f in friendsResult.data) {
        combined[f.username.toLowerCase()] = f;
      }
    }

    if (groupResult is ApiSuccess<List<GroupSearchUserResponse>>) {
      for (var u in groupResult.data) {
        final key = u.username.toLowerCase();
        if (!combined.containsKey(key)) {
          combined[key] = FriendResponse(
            userId: u.userId,
            username: u.username,
            firstname: u.firstname ?? '',
            lastname: u.lastname ?? '',
            profilePic: '',
          );
        }
      }
    }

    searchResults.assignAll(combined.values.toList());
  }

  List<FriendResponse> get displayedUsers {
    if (searchQuery.value.trim().isNotEmpty && searchResults.isNotEmpty) {
      return searchResults;
    }
    if (searchQuery.value.trim().isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      return friends.where((f) {
        final fullName = '${f.firstname} ${f.lastname}'.toLowerCase();
        final username = f.username.toLowerCase();
        return fullName.contains(query) || username.contains(query);
      }).toList();
    }
    return friends;
  }

  bool isCustomAlreadyMember(String query) {
    final clean = query.replaceAll('@', '').trim().toLowerCase();
    return existingMemberUsernames.contains(clean);
  }

  bool isCustomAlreadyInvited(String query) {
    final clean = query.replaceAll('@', '').trim().toLowerCase();
    return pendingInvitedUsernames.contains(clean);
  }

  void toggleSelection(FriendResponse friend) {
    if (isAlreadyMember(friend) || isAlreadyInvited(friend)) {
      return;
    }
    if (selectedFriends.contains(friend)) {
      selectedFriends.remove(friend);
    } else {
      selectedFriends.add(friend);
    }
  }

  void inviteSelected() {
    if (selectedFriends.isNotEmpty) {
      final selectedList = selectedFriends.map((f) {
        final displayName = '${f.firstname} ${f.lastname}'.trim();
        return {
          'userId': f.userId,
          'name': displayName.isNotEmpty ? displayName : f.username,
          'username': f.username,
          'profilePic': f.profilePic,
        };
      }).toList();
      Get.back(result: selectedList);
    } else if (searchQuery.value.trim().isNotEmpty) {
      inviteCustom(searchQuery.value.trim());
    } else {
      Get.back();
    }
  }

  void inviteCustom(String name) {
    final clean = name.replaceAll('@', '').trim();
    if (clean.isEmpty) return;
    if (isCustomAlreadyMember(clean)) {
      Get.snackbar(_l10n?.alreadyMemberTitle ?? 'Already a Member', _l10n?.alreadyMember ?? '$clean is already a member.', backgroundColor: AppColors.emerald, colorText: Colors.white);
      return;
    }
    if (isCustomAlreadyInvited(clean)) {
      Get.snackbar(_l10n?.alreadyInvitedTitle ?? 'Already Invited', _l10n?.alreadyInvited ?? '$clean already has a pending invitation.', backgroundColor: AppColors.amber, colorText: Colors.white);
      return;
    }
    Get.back(result: [
      {
        'name': clean,
        'username': clean,
      }
    ]);
  }
}
