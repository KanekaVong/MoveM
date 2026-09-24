import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/storage/user_manager.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/base/base_controller.dart';
import '../../data/dto/response/public_user_profile_response.dart';
import '../../domain/repositories/friends_repository.dart';

class PublicUserProfileController extends BaseController {
  final FriendsRepository repository;
  final String userId;

  PublicUserProfileController({
    required this.repository,
    required this.userId,
    PublicUserProfileResponse? initialProfile,
  }) {
    if (initialProfile != null) {
      profile.value = initialProfile;
    }
  }

  final Rxn<PublicUserProfileResponse> profile = Rxn<PublicUserProfileResponse>();
  final incomingRequestId = 0.obs;

  AppLocalizations? get _l10n {
    final ctx = Get.context;
    return ctx == null ? null : AppLocalizations.of(ctx);
  }

  bool get isOwnProfile {
    final currentId = UserManager().getUser()?.id ?? UserManager().userId;
    if (currentId == null || currentId.isEmpty) return false;
    return currentId == userId || currentId == profile.value?.id;
  }

  bool get isIncomingRequest => incomingRequestId.value > 0;

  @override
  void onInit() {
    super.onInit();
    if (profile.value == null) {
      loadProfile();
    } else {
      _resolveFriendship();
    }
  }

  Future<void> loadProfile() async {
    await executeApi(
      apiCall: () => repository.getUserById(userId),
      onSuccess: (data) async {
        profile.value = data;
        await _resolveFriendship();
      },
    );
  }

  Future<void> _resolveFriendship() async {
    if (isOwnProfile) return;
    final current = profile.value;
    if (current == null) return;

    final id = int.tryParse(current.id.isNotEmpty ? current.id : userId);
    final username = current.username.toLowerCase();

    final friendsRes = await repository.getFriends();
    if (friendsRes.isSuccess && friendsRes.data != null) {
      final isFriend = friendsRes.data!.any((f) {
        if (id != null && f.userId == id) return true;
        return username.isNotEmpty && f.username.toLowerCase() == username;
      });
      if (isFriend) {
        incomingRequestId.value = 0;
        profile.value = current.copyWith(friendStatus: 'FRIEND');
        return;
      }
    }

    final outgoingRes = await repository.getOutgoingRequests();
    if (outgoingRes.isSuccess && outgoingRes.data != null) {
      final pending = outgoingRes.data!.any((r) {
        if (id != null && r.receiverId == id) return true;
        return username.isNotEmpty && r.receiverUsername.toLowerCase() == username;
      });
      if (pending) {
        incomingRequestId.value = 0;
        profile.value = current.copyWith(friendStatus: 'PENDING_REQUEST');
        return;
      }
    }

    final incomingRes = await repository.getIncomingRequests();
    if (incomingRes.isSuccess && incomingRes.data != null) {
      for (final r in incomingRes.data!) {
        final match = (id != null && r.senderId == id) ||
            (username.isNotEmpty && r.senderUsername.toLowerCase() == username);
        if (match) {
          incomingRequestId.value = r.requestId;
          profile.value = current.copyWith(friendStatus: 'INCOMING_REQUEST');
          return;
        }
      }
    }

    incomingRequestId.value = 0;
    if ((current.friendStatus ?? '').isEmpty) {
      profile.value = current.copyWith(friendStatus: 'NONE');
    }
  }

  Future<void> sendFriendRequest() async {
    final username = profile.value?.username ?? '';
    if (username.isEmpty ||
        isOwnProfile ||
        profile.value?.isRequestPending == true ||
        isIncomingRequest) {
      return;
    }

    await executeApi(
      apiCall: () => repository.sendFriendRequest(username),
      onSuccess: (_) {
        incomingRequestId.value = 0;
        profile.value = profile.value?.copyWith(friendStatus: 'PENDING_REQUEST');
        Get.snackbar(
          _l10n?.requestSentTitle ?? 'Request sent',
          'Friend request sent.',
          backgroundColor: const Color(0xFF48A45B),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Future<void> acceptIncomingRequest() async {
    final requestId = incomingRequestId.value;
    if (requestId <= 0) return;
    await executeApi(
      apiCall: () => repository.acceptFriendRequest(requestId),
      onSuccess: (_) {
        incomingRequestId.value = 0;
        profile.value = profile.value?.copyWith(friendStatus: 'FRIEND');
        Get.snackbar(
          _l10n?.success ?? 'Done',
          'You are now friends.',
          backgroundColor: const Color(0xFF48A45B),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }
}
