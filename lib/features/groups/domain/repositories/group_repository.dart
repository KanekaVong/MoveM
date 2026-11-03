import '../../../../core/network/api_result.dart';
import '../../data/dto/response/group_member_response.dart';
import '../../data/dto/response/group_invite_response.dart';
import '../../data/dto/response/group_search_user_response.dart';

import '../../data/dto/response/pending_invite_response.dart';

abstract class GroupRepository {
  Future<ApiResult<List<GroupMemberResponse>>> getMembers(String activityId);
  Future<ApiResult<GroupInviteResponse>> inviteMember(String activityId, String identifier);
  Future<ApiResult<void>> removeMember(String activityId, int memberId);
  Future<ApiResult<List<GroupSearchUserResponse>>> searchUsers(String keyword);
  Future<ApiResult<List<PendingInviteResponse>>> getPendingInvites(String activityId);
  Future<ApiResult<List<GroupInviteResponse>>> getMyInvitations();
  Future<ApiResult<GroupInviteResponse>> acceptInvite(int inviteId);
  Future<ApiResult<GroupInviteResponse>> rejectInvite(int inviteId);
}
