import 'package:get/get.dart';
import '../../../../core/network/api_result.dart';
import '../../../groups/data/dto/response/group_invite_response.dart';
import '../../../groups/data/repositories/group_repository_impl.dart';
import '../../../groups/data/services/group_service.dart';
import '../../../groups/domain/repositories/group_repository.dart';
import 'task_controller.dart';

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
      errorMessage.value = result.exception?.message ?? 'Failed to load invitations';
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
      Get.snackbar(
        'Invitation accepted',
        invite.activityName?.isNotEmpty == true
            ? 'You joined ${invite.activityName}'
            : 'You joined the task',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Could not accept',
        result.exception?.message ?? 'Please try again',
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
      Get.snackbar(
        'Could not decline',
        result.exception?.message ?? 'Please try again',
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
