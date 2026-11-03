import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class GroupService {
  final Dio dio = DioClient().dio;

  Future<Response> getMembers(String activityId) async {
    return await dio.get('groups/$activityId/members');
  }

  Future<Response> inviteMember(String activityId, String identifier) async {
    return await dio.post('groups/$activityId/invite', data: {'identifier': identifier});
  }

  Future<Response> removeMember(String activityId, int memberId) async {
    return await dio.delete('groups/$activityId/members/$memberId');
  }

  Future<Response> searchUsers(String keyword) async {
    return await dio.get('groups/search-users', queryParameters: {'keyword': keyword});
  }

  Future<Response> getPendingInvites(String activityId) async {
    return await dio.get('groups/$activityId/pending-invites');
  }

  Future<Response> getMyInvitations() async {
    return await dio.get('groups/my-invitations');
  }

  Future<Response> acceptInvite(int inviteId) async {
    return await dio.patch('groups/invites/$inviteId/accept');
  }

  Future<Response> rejectInvite(int inviteId) async {
    return await dio.patch('groups/invites/$inviteId/reject');
  }
}
