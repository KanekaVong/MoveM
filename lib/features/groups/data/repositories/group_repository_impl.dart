import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../domain/repositories/group_repository.dart';
import '../services/group_service.dart';
import '../dto/response/group_member_response.dart';
import '../dto/response/group_invite_response.dart';
import '../dto/response/group_search_user_response.dart';
import '../dto/response/pending_invite_response.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupService groupService;
  final _logger = Logger();

  GroupRepositoryImpl({required this.groupService});

  @override
  Future<ApiResult<List<GroupMemberResponse>>> getMembers(String activityId) async {
    try {
      final response = await groupService.getMembers(activityId);
      final List<dynamic> list = response.data is List ? response.data : [];
      final members = list.map((e) => GroupMemberResponse.fromJson(e as Map<String, dynamic>)).toList();
      return ApiSuccess(members);
    } on DioException catch (e) {
      _logger.e('getMembers Error: ${e.response?.data ?? e.message}');
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      _logger.e('getMembers Unknown Error: $e');
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<GroupInviteResponse>> inviteMember(String activityId, String identifier) async {
    try {
      final response = await groupService.inviteMember(activityId, identifier);
      final Map<String, dynamic> data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      final invite = GroupInviteResponse.fromJson(data);
      return ApiSuccess(invite);
    } on DioException catch (e) {
      _logger.e('inviteMember Error: ${e.response?.data ?? e.message}');
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      _logger.e('inviteMember Unknown Error: $e');
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> removeMember(String activityId, int memberId) async {
    try {
      await groupService.removeMember(activityId, memberId);
      return const ApiSuccess(null);
    } on DioException catch (e) {
      _logger.e('removeMember Error: ${e.response?.data ?? e.message}');
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      _logger.e('removeMember Unknown Error: $e');
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<List<GroupSearchUserResponse>>> searchUsers(String keyword) async {
    try {
      final response = await groupService.searchUsers(keyword);
      final List<dynamic> list = response.data is List ? response.data : [];
      final users = list.map((e) => GroupSearchUserResponse.fromJson(e as Map<String, dynamic>)).toList();
      return ApiSuccess(users);
    } on DioException catch (e) {
      _logger.e('searchUsers Error: ${e.response?.data ?? e.message}');
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      _logger.e('searchUsers Unknown Error: $e');
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<List<PendingInviteResponse>>> getPendingInvites(String activityId) async {
    try {
      final response = await groupService.getPendingInvites(activityId);
      final List<dynamic> list = response.data is List ? response.data : [];
      final invites = list.map((e) => PendingInviteResponse.fromJson(e as Map<String, dynamic>)).toList();
      return ApiSuccess(invites);
    } on DioException catch (e) {
      _logger.e('getPendingInvites Error: ${e.response?.data ?? e.message}');
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      _logger.e('getPendingInvites Unknown Error: $e');
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<List<GroupInviteResponse>>> getMyInvitations() async {
    try {
      final response = await groupService.getMyInvitations();
      final List<dynamic> list = response.data is List ? response.data : [];
      final invites = list
          .whereType<Map>()
          .map((e) => GroupInviteResponse.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return ApiSuccess(invites);
    } on DioException catch (e) {
      _logger.e('getMyInvitations Error: ${e.response?.data ?? e.message}');
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      _logger.e('getMyInvitations Unknown Error: $e');
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<GroupInviteResponse>> acceptInvite(int inviteId) async {
    try {
      final response = await groupService.acceptInvite(inviteId);
      final data = response.data is Map
          ? Map<String, dynamic>.from(response.data as Map)
          : <String, dynamic>{};
      return ApiSuccess(GroupInviteResponse.fromJson(data));
    } on DioException catch (e) {
      _logger.e('acceptInvite Error: ${e.response?.data ?? e.message}');
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      _logger.e('acceptInvite Unknown Error: $e');
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<GroupInviteResponse>> rejectInvite(int inviteId) async {
    try {
      final response = await groupService.rejectInvite(inviteId);
      final data = response.data is Map
          ? Map<String, dynamic>.from(response.data as Map)
          : <String, dynamic>{};
      return ApiSuccess(GroupInviteResponse.fromJson(data));
    } on DioException catch (e) {
      _logger.e('rejectInvite Error: ${e.response?.data ?? e.message}');
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      _logger.e('rejectInvite Unknown Error: $e');
      return ApiError(ApiException(message: e.toString()));
    }
  }
}
