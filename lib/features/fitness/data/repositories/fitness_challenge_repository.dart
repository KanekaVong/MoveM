import 'package:dio/dio.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/solo_challenge_model.dart';
import '../models/group_challenge_model.dart';

class FitnessChallengeRepository {
  final DioClient _dioClient = DioClient();

  Future<ApiResult<List<SoloChallengeModel>>> getSoloChallenges() async {
    try {
      final response = await _dioClient.dio.get('fitness/solo-challenges');
      if (response.data != null && response.data is List) {
        final list = (response.data as List)
            .map((item) => SoloChallengeModel.fromJson(item))
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

  Future<ApiResult<List<SoloChallengeModel>>> getSoloChallengesByType(String workoutType) async {
    try {
      final response = await _dioClient.dio.get('fitness/solo-challenges/type/$workoutType');
      if (response.data != null && response.data is List) {
        final list = (response.data as List)
            .map((item) => SoloChallengeModel.fromJson(item))
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

  Future<ApiResult<SoloChallengeModel>> getSoloChallenge(int challengeId) async {
    try {
      final response = await _dioClient.dio.get('fitness/solo-challenges/$challengeId');
      if (response.data != null) {
        final raw = response.data is Map && (response.data as Map).containsKey('data')
            ? (response.data as Map)['data']
            : response.data;
        if (raw is Map<String, dynamic>) {
          return ApiSuccess(SoloChallengeModel.fromJson(raw));
        } else if (raw is Map) {
          return ApiSuccess(SoloChallengeModel.fromJson(Map<String, dynamic>.from(raw)));
        }
      }
      return ApiError(ApiException(message: 'Challenge not found'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<List<GroupChallengeCatalogModel>>> getCatalogChallenges() async {
    try {
      final response = await _dioClient.dio.get('fitness/group-challenge/catalog');
      if (response.data != null && response.data is List) {
        final list = (response.data as List)
            .map((item) => GroupChallengeCatalogModel.fromJson(item))
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

  Future<ApiResult<List<GroupFitnessChallengeModel>>> getClubChallenges(int clubId) async {
    try {
      final response = await _dioClient.dio.get('fitness/clubs/$clubId/challenges');
      if (response.data != null && response.data is List) {
        final list = (response.data as List)
            .map((item) => GroupFitnessChallengeModel.fromJson(item))
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

  Future<ApiResult<GroupFitnessChallengeModel>> createClubChallenge(int clubId, Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.dio.post(
        'fitness/clubs/$clubId/challenges',
        data: data,
      );
      if (response.data != null) {
        return ApiSuccess(GroupFitnessChallengeModel.fromJson(response.data));
      }
      return ApiError(ApiException(message: 'Failed to create challenge'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<GroupFitnessChallengeModel>> createClubChallengeFromCatalog(int clubId, int catalogId) async {
    try {
      final response = await _dioClient.dio.post(
        'fitness/clubs/$clubId/challenges/from-catalog/$catalogId',
      );
      if (response.data != null) {
        return ApiSuccess(GroupFitnessChallengeModel.fromJson(response.data));
      }
      return ApiError(ApiException(message: 'Failed to create challenge from catalog'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<List<GroupFitnessChallengeModel>>> getMyChallenges() async {
    try {
      final response = await _dioClient.dio.get('fitness/challenges/my');
      if (response.data != null && response.data is List) {
        final list = (response.data as List)
            .map((item) => GroupFitnessChallengeModel.fromJson(item))
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

  Future<ApiResult<ChallengeParticipantModel>> joinChallenge(int challengeId) async {
    try {
      final response = await _dioClient.dio.post('fitness/group-challenges/$challengeId/join');
      if (response.data != null) {
        return ApiSuccess(ChallengeParticipantModel.fromJson(response.data));
      }
      return ApiError(ApiException(message: 'Failed to join challenge'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<bool>> leaveChallenge(int challengeId) async {
    try {
      await _dioClient.dio.delete('fitness/group-challenges/$challengeId/leave');
      return ApiSuccess(true);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<List<ChallengeParticipantModel>>> getChallengeParticipants(int challengeId) async {
    try {
      final response = await _dioClient.dio.get('fitness/group-challenges/$challengeId/participants');
      if (response.data != null && response.data is List) {
        final list = (response.data as List)
            .map((item) => ChallengeParticipantModel.fromJson(item))
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

  Future<ApiResult<ChallengeParticipantModel?>> getMyParticipation(int challengeId) async {
    try {
      final response = await _dioClient.dio.get('fitness/group-challenges/$challengeId/participants/me');
      if (response.data != null) {
        return ApiSuccess(ChallengeParticipantModel.fromJson(response.data));
      }
      return ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }
}
