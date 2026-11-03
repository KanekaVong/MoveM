import 'package:get/get.dart';
import '../../../../core/network/api_result.dart';
import '../../../groups/data/dto/response/group_invite_response.dart';
import '../../../groups/data/repositories/group_repository_impl.dart';
import '../../../groups/data/services/group_service.dart';
import '../../../groups/domain/repositories/group_repository.dart';
import 'task_controller.dart';
import 'package:movem/core/utils/app_snack.dart';
import 'package:movem/core/utils/l10n.dart';

class TaskInvitationController extends GetxController {
  final GroupRepository repository;

  TaskInvitationController({GroupRepository? repository})
      : repository = repository ?? GroupRepositoryImpl(groupService: GroupService());

  final invitations = <GroupInviteResponse>[].obs;
  final isLoading = false.obs;
  final actingInviteId = RxnInt();
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInvitations();
  }

  Future<void> fetchInvitations() async {
    isLoading.value = true;
    errorMessage.value = '';
    final result = await repository.getMyInvitations();
    if (result is ApiSuccess<List<GroupInviteResponse>>) {
      invitations.assignAll(
        result.data.where((invite) => (invite.status ?? '').toUpperCase() == 'PENDING').toList(),
      );
    } else {
      errorMessage.value = result.exception?.message ?? tr.failedToLoadInvitations;
    }
    isLoading.value = false;
  }

  Future<void> accept(GroupInviteResponse invite) async {
    final id = invite.inviteId;
    if (id == null || actingInviteId.value != null) return;
    actingInviteId.value = id;
    final result = await repository.acceptInvite(id);
    actingInviteId.value = null;
    if (result is ApiSuccess<GroupInviteResponse>) {
      invitations.removeWhere((item) => item.inviteId == id);
      _refreshTasks();
      AppSnack.show(
        tr.invitationAccepted,
        invite.activityName?.isNotEmpty == true
            ? tr.youJoinedName(invite.activityName ?? '')
            : tr.youJoinedTask,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      AppSnack.show(
        tr.couldNotAccept,
        result.exception?.message ?? tr.pleaseTryAgain,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> reject(GroupInviteResponse invite) async {
    final id = invite.inviteId;
    if (id == null || actingInviteId.value != null) return;
    actingInviteId.value = id;
    final result = await repository.rejectInvite(id);
    actingInviteId.value = null;
    if (result is ApiSuccess<GroupInviteResponse>) {
      invitations.removeWhere((item) => item.inviteId == id);
    } else {
      AppSnack.show(
        tr.couldNotDecline,
        result.exception?.message ?? tr.pleaseTryAgain,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _refreshTasks() {
    if (Get.isRegistered<TaskController>()) {
      Get.find<TaskController>().fetchTasks();
    }
  }
}
