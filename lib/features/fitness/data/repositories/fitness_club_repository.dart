import 'package:dio/dio.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/fitness_club_model.dart';

class FitnessClubRepository {
  final DioClient _dioClient = DioClient();

  dynamic _payload(dynamic data) {
    if (data is Map && data['data'] != null) return data['data'];
    if (data is Map && data['content'] != null) return data['content'];
    return data;
  }

  Map<String, dynamic>? _asMap(dynamic data) {
    final raw = _payload(data);
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
  }

  List<Map<String, dynamic>> _asMapList(dynamic data) {
    final raw = _payload(data);
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<ApiResult<List<FitnessClubModel>>> getPublicClubs() async {
    try {
      final response = await _dioClient.dio.get('fitness/clubs/public');
      final list = _asMapList(response.data)
          .map(FitnessClubModel.fromJson)
          .toList();
      return ApiSuccess(list);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<List<FitnessClubModel>>> searchClubs(String query) async {
    try {
      final response = await _dioClient.dio.get(
        'fitness/clubs/search',
        queryParameters: {'query': query},
      );
      final list = _asMapList(response.data)
          .map(FitnessClubModel.fromJson)
          .toList();
      return ApiSuccess(list);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<FitnessClubModel>> getClub(int clubId) async {
    try {
      final response = await _dioClient.dio.get('fitness/clubs/$clubId');
      final map = _asMap(response.data);
      if (map != null) {
        return ApiSuccess(FitnessClubModel.fromJson(map));
      }
      return ApiError(ApiException(message: 'Club not found'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<FitnessClubModel>> createClub(CreateFitnessClubRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        'fitness/clubs',
        data: request.toJson(),
      );
      final map = _asMap(response.data);
      if (map != null) {
        return ApiSuccess(FitnessClubModel.fromJson(map));
      }
      return ApiError(ApiException(message: 'Failed to create club'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<FitnessClubModel>> updateClub(int clubId, CreateFitnessClubRequest request) async {
    try {
      final response = await _dioClient.dio.put(
        'fitness/clubs/$clubId',
        data: request.toJson(),
      );
      final map = _asMap(response.data);
      if (map != null) {
        return ApiSuccess(FitnessClubModel.fromJson(map));
      }
      return ApiError(ApiException(message: 'Failed to update club'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<bool>> deleteClub(int clubId) async {
    try {
      await _dioClient.dio.delete('fitness/clubs/$clubId');
      return ApiSuccess(true);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<FitnessClubMemberModel>> joinClub(int clubId) async {
    try {
      final response = await _dioClient.dio.post('fitness/clubs/$clubId/join');
      final map = _asMap(response.data);
      if (map != null) {
        return ApiSuccess(FitnessClubMemberModel.fromJson(map));
      }
      if ((response.statusCode ?? 0) >= 200 && (response.statusCode ?? 0) < 300) {
        return ApiSuccess(FitnessClubMemberModel(
          clubId: clubId,
          userId: 0,
          role: 'MEMBER',
        ));
      }
      return ApiError(ApiException(message: 'Failed to join club'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<ClubJoinRequestModel>> requestToJoin(int clubId) async {
    try {
      final response = await _dioClient.dio.post('fitness/clubs/$clubId/join-request');
      final map = _asMap(response.data);
      if (map != null) {
        return ApiSuccess(ClubJoinRequestModel.fromJson(map));
      }
      return ApiError(ApiException(message: 'Failed to submit join request'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<List<FitnessClubMemberModel>>> getClubMembers(int clubId) async {
    try {
      final response = await _dioClient.dio.get('fitness/clubs/$clubId/members');
      final list = _asMapList(response.data)
          .map(FitnessClubMemberModel.fromJson)
          .toList();
      return ApiSuccess(list);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<FitnessClubMemberModel>> addMember(int clubId, int userId, {String role = 'MEMBER'}) async {
    try {
      final response = await _dioClient.dio.post(
        'fitness/clubs/$clubId/members',
        data: {'userId': userId},
      );
      final map = _asMap(response.data);
      if (map != null) {
        return ApiSuccess(FitnessClubMemberModel.fromJson(map));
      }
      return ApiError(ApiException(message: 'Failed to add member'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<bool>> removeMember(int clubId, int userId) async {
    try {
      await _dioClient.dio.delete('fitness/clubs/$clubId/members/$userId');
      return ApiSuccess(true);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<List<ClubJoinRequestModel>>> getPendingRequests(int clubId) async {
    try {
      final response = await _dioClient.dio.get('fitness/clubs/$clubId/join-requests');
      final list = _asMapList(response.data)
          .map(ClubJoinRequestModel.fromJson)
          .toList();
      return ApiSuccess(list);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<List<ClubJoinRequestModel>>> getJoinRequests(int clubId) => getPendingRequests(clubId);

  Future<ApiResult<ClubJoinRequestModel>> approveRequest(int clubId, int requestId) async {
    try {
      final response = await _dioClient.dio.post('fitness/clubs/$clubId/join-requests/$requestId/approve');
      final map = _asMap(response.data);
      if (map != null) {
        return ApiSuccess(ClubJoinRequestModel.fromJson(map));
      }
      return ApiError(ApiException(message: 'Failed to approve request'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<ClubJoinRequestModel>> rejectRequest(int clubId, int requestId) async {
    try {
      final response = await _dioClient.dio.post('fitness/clubs/$clubId/join-requests/$requestId/reject');
      final map = _asMap(response.data);
      if (map != null) {
        return ApiSuccess(ClubJoinRequestModel.fromJson(map));
      }
      return ApiError(ApiException(message: 'Failed to reject request'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<List<ClubJoinRequestModel>>> getMyRequests() async {
    try {
      final response = await _dioClient.dio.get('fitness/clubs/join-requests/my');
      final list = _asMapList(response.data)
          .map(ClubJoinRequestModel.fromJson)
          .toList();
      return ApiSuccess(list);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<bool>> cancelMyRequest(int requestId) async {
    try {
      await _dioClient.dio.delete('fitness/clubs/join-requests/$requestId');
      return ApiSuccess(true);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }
}
