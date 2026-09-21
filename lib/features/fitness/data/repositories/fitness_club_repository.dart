import 'package:dio/dio.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/fitness_club_model.dart';

class FitnessClubRepository {
  final DioClient _dioClient = DioClient();

  Future<ApiResult<List<FitnessClubModel>>> getMyClubs() async {
    try {
      final response = await _dioClient.dio.get('fitness/clubs/my');
      if (response.data != null && response.data is List) {
        final list = (response.data as List)
            .map((item) => FitnessClubModel.fromJson(item))
            .toList();
        return ApiSuccess(list);
      }
      return ApiSuccess([]);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<List<FitnessClubModel>>> getPublicClubs() async {
    try {
      final response = await _dioClient.dio.get('fitness/clubs/public');
      if (response.data != null && response.data is List) {
        final list = (response.data as List)
            .map((item) => FitnessClubModel.fromJson(item))
            .toList();
        return ApiSuccess(list);
      }
      return ApiSuccess([]);
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
      if (response.data != null && response.data is List) {
        final list = (response.data as List)
            .map((item) => FitnessClubModel.fromJson(item))
            .toList();
        return ApiSuccess(list);
      }
      return ApiSuccess([]);
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
      if (response.data != null) {
        return ApiSuccess(FitnessClubModel.fromJson(response.data));
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
      if (response.data != null) {
        return ApiSuccess(FitnessClubModel.fromJson(response.data));
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
      if (response.data != null) {
        return ApiSuccess(FitnessClubModel.fromJson(response.data));
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
      if (response.data != null) {
        return ApiSuccess(FitnessClubMemberModel.fromJson(response.data));
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
      if (response.data != null) {
        return ApiSuccess(ClubJoinRequestModel.fromJson(response.data));
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
      if (response.data != null && response.data is List) {
        final list = (response.data as List)
            .map((item) => FitnessClubMemberModel.fromJson(item))
            .toList();
        return ApiSuccess(list);
      }
      return ApiSuccess([]);
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
        data: {'userId': userId, 'role': role},
      );
      if (response.data != null) {
        return ApiSuccess(FitnessClubMemberModel.fromJson(response.data));
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
      if (response.data != null && response.data is List) {
        final list = (response.data as List)
            .map((item) => ClubJoinRequestModel.fromJson(item))
            .toList();
        return ApiSuccess(list);
      }
      return ApiSuccess([]);
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
      if (response.data != null) {
        return ApiSuccess(ClubJoinRequestModel.fromJson(response.data));
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
      if (response.data != null) {
        return ApiSuccess(ClubJoinRequestModel.fromJson(response.data));
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
      if (response.data != null && response.data is List) {
        final list = (response.data as List)
            .map((item) => ClubJoinRequestModel.fromJson(item))
            .toList();
        return ApiSuccess(list);
      }
      return ApiSuccess([]);
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
