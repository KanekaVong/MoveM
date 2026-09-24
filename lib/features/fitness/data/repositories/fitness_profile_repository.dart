import 'package:dio/dio.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../../../core/network/fitness_endpoints.dart';
import '../models/fitness_profile_model.dart';
import '../models/fitness_statistics_model.dart';
import '../models/solo_challenge_model.dart';
import '../models/setup_goal_request.dart';

class FitnessProfileRepository {
  final DioClient _dioClient = DioClient();

  Map<String, dynamic>? _asJsonMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  FitnessProfileModel _profileFromResponse(
    dynamic data, {
    required double height,
    required double weight,
  }) {
    final map = _asJsonMap(data);
    if (map != null) {
      final parsed = FitnessProfileModel.fromJson(map);
      return FitnessProfileModel(
        userId: parsed.userId,
        height: parsed.height > 0 ? parsed.height : height,
        weight: parsed.weight > 0 ? parsed.weight : weight,
        bmi: parsed.bmi,
        fitnessGoal: parsed.fitnessGoal,
        updatedAt: parsed.updatedAt,
      );
    }
    return FitnessProfileModel(
      userId: 0,
      height: height,
      weight: weight,
      bmi: 0,
    );
  }

  Future<ApiResult<FitnessProfileModel?>> getProfile() async {
    try {
      final response = await _dioClient.dio.get(
        FitnessEndpoints.profile,
        options: Options(
          validateStatus: (status) =>
              status != null && (status < 400 || status == 404),
        ),
      );
      if (response.statusCode == 404) {
        return const ApiSuccess(null);
      }
      final map = _asJsonMap(response.data);
      if (map != null) {
        return ApiSuccess(FitnessProfileModel.fromJson(map));
      }
      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<FitnessProfileModel>> createProfile(double height, double weight) async {
    try {
      final response = await _dioClient.dio.post(
        FitnessEndpoints.profile,
        data: {
          'height': height,
          'weight': weight,
        },
      );
      return ApiSuccess(
        _profileFromResponse(response.data, height: height, weight: weight),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        return updateProfile(height, weight);
      }
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<FitnessProfileModel>> updateProfile(double height, double weight) async {
    try {
      final response = await _dioClient.dio.put(
        FitnessEndpoints.profile,
        data: {
          'height': height,
          'weight': weight,
        },
      );
      return ApiSuccess(
        _profileFromResponse(response.data, height: height, weight: weight),
      );
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<bool>> deleteProfile() async {
    try {
      await _dioClient.dio.delete('fitness/profile');
      return ApiSuccess(true);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

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

  Future<ApiResult<dynamic>> setupGoal(SetupGoalRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        'fitness/goals',
        data: request.toJson(),
      );
      return ApiSuccess(response.data);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<List<FitnessGoalModel>>> getGoals() async {
    try {
      final response = await _dioClient.dio.get('fitness/goals');
      if (response.data != null && response.data is List) {
        final list = (response.data as List)
            .map((item) => FitnessGoalModel.fromJson(item))
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

  Future<ApiResult<FitnessGoalModel>> getGoal(int goalId) async {
    try {
      final response = await _dioClient.dio.get('fitness/goals/$goalId');
      if (response.data != null) {
        return ApiSuccess(FitnessGoalModel.fromJson(response.data));
      }
      return ApiError(ApiException(message: 'Goal not found'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<FitnessGoalModel>> updateGoal(int goalId, SetupGoalRequest request) async {
    try {
      final response = await _dioClient.dio.put(
        'fitness/goals/$goalId',
        data: request.toJson(),
      );
      if (response.data != null) {
        return ApiSuccess(FitnessGoalModel.fromJson(response.data));
      }
      return ApiError(ApiException(message: 'Update goal failed'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<bool>> deleteGoal(int goalId) async {
    try {
      await _dioClient.dio.delete('fitness/goals/$goalId');
      return ApiSuccess(true);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<FitnessStatisticsModel>> getFitnessStatistics() async {
    try {
      final response = await _dioClient.dio.get('statistics/fitness');
      if (response.data != null) {
        return ApiSuccess(FitnessStatisticsModel.fromJson(response.data));
      }
      return ApiSuccess(FitnessStatisticsModel());
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }
}
