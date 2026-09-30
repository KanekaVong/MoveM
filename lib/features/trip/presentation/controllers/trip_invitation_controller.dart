import 'package:get/get.dart';

import '../../../../shared/base/base_controller.dart';
import 'package:flutter/foundation.dart';
import '../../../groups/data/dto/response/group_invite_response.dart';
import '../../../groups/domain/repositories/group_repository.dart';

class TripInvitationController extends BaseController {
  final GroupRepository groupRepository;

  TripInvitationController({
    required this.groupRepository,
  });

  final RxList<GroupInviteResponse> invitations =
      <GroupInviteResponse>[].obs;

  final RxBool isResponding = false.obs;

  Future<void> loadInvitations() async {
    await executeApi<List<GroupInviteResponse>>(
      apiCall: () => groupRepository.getMyInvitations(),
      showLoading: false,
      onSuccess: (data) {
        invitations.assignAll(
          data.where(
                (invite) =>
            invite.status?.toUpperCase() == 'PENDING',
          ),
        );
      },
    );
  }

  Future<bool> acceptInvitation(int inviteId) async {
    isResponding.value = true;

    try {
      var success = false;

      await executeApi<GroupInviteResponse>(
        apiCall: () => groupRepository.acceptInvite(inviteId),
        showLoading: false,
        onSuccess: (data) {
          debugPrint('ACCEPT INVITE SUCCESS');
          debugPrint('inviteId: ${data.inviteId}');
          debugPrint('activityId: ${data.activityId}');
          debugPrint('activityName: ${data.activityName}');
          debugPrint('status: ${data.status}');

          invitations.removeWhere(
                (invite) => invite.inviteId == inviteId,
          );

          success = true;
        },
      );

      return success;
    } finally {
      isResponding.value = false;
    }
  }

  Future<bool> rejectInvitation(int inviteId) async {
    isResponding.value = true;

    try {
      var success = false;

      await executeApi<GroupInviteResponse>(
        apiCall: () => groupRepository.rejectInvite(inviteId),
        showLoading: false,
        onSuccess: (data) {
          invitations.removeWhere(
                (invite) => invite.inviteId == inviteId,
          );

          success = true;
        },
      );

      return success;
    } finally {
      isResponding.value = false;
    }
  }
}