import 'package:dio/dio.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../../../core/network/fitness_endpoints.dart';
import '../models/workout_model.dart';

class FitnessWorkoutRepository {
  final DioClient _dioClient = DioClient();

  Future<ApiResult<FitnessWorkoutSessionModel>> startWorkout(StartWorkoutRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        'fitness/workouts/start',
        data: request.toJson(),
      );
      if (response.data != null) {
        return ApiSuccess(FitnessWorkoutSessionModel.fromJson(response.data));
      }
      return ApiError(ApiException(message: 'Failed to start workout session'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<FitnessWorkoutSessionModel>> updateProgress(int sessionId, WorkoutProgressRequest progress) async {
    try {
      final response = await _dioClient.dio.patch(
        'fitness/workouts/$sessionId/progress',
        data: progress.toJson(),
      );
      if (response.data != null) {
        return ApiSuccess(FitnessWorkoutSessionModel.fromJson(response.data));
      }
      return ApiError(ApiException(message: 'Failed to update progress'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<bool>> pauseWorkout(int sessionId) async {
    try {
      await _dioClient.dio.patch('fitness/workouts/$sessionId/pause');
      return ApiSuccess(true);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<bool>> resumeWorkout(int sessionId) async {
    try {
      await _dioClient.dio.patch('fitness/workouts/$sessionId/resume');
      return ApiSuccess(true);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<FitnessWorkoutSessionModel>> finishWorkout(
    int sessionId, [
    FinishWorkoutRequest? request,
  ]) async {
    try {
      final response = await _dioClient.dio.post(
        'fitness/workouts/$sessionId/finish',
        data: request?.toJson() ?? {
          'durationSeconds': 0,
          'steps': 0,
          'distance': 0,
        },
      );
      if (response.data != null) {
        return ApiSuccess(FitnessWorkoutSessionModel.fromJson(response.data));
      }
      return ApiError(ApiException(message: 'Failed to finish workout'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<FitnessWorkoutSummaryModel>> getWorkoutSummary(int sessionId) async {
    try {
      final response = await _dioClient.dio.get('fitness/workouts/$sessionId/summary');
      if (response.data != null) {
        return ApiSuccess(FitnessWorkoutSummaryModel.fromJson(response.data));
      }
      return ApiError(ApiException(message: 'Summary not found'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<List<WorkoutHistoryItemModel>>> getWorkoutHistory() async {
    try {
      final response = await _dioClient.dio.get(FitnessEndpoints.workoutHistory);
      if (response.data != null && response.data is List) {
        final list = (response.data as List)
            .whereType<Map>()
            .map((item) => WorkoutHistoryItemModel.fromJson(Map<String, dynamic>.from(item)))
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

  Future<ApiResult<bool>> deleteWorkout(int sessionId) async {
    try {
      await _dioClient.dio.delete('fitness/workouts/$sessionId');
      return ApiSuccess(true);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  // Kudos
  Future<ApiResult<bool>> giveKudos(int sessionId) async {
    try {
      await _dioClient.dio.post('fitness/workouts/$sessionId/kudos');
      return ApiSuccess(true);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<bool>> removeKudos(int sessionId) async {
    try {
      await _dioClient.dio.delete('fitness/workouts/$sessionId/kudos');
      return ApiSuccess(true);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<int>> getKudosCount(int sessionId) async {
    try {
      final response = await _dioClient.dio.get('fitness/workouts/$sessionId/kudos/count');
      if (response.data != null) {
        return ApiSuccess((response.data as num?)?.toInt() ?? 0);
      }
      return ApiSuccess(0);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<bool>> hasGivenKudos(int sessionId) async {
    try {
      final response = await _dioClient.dio.get('fitness/workouts/$sessionId/kudos/me');
      return ApiSuccess(response.data as bool? ?? false);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<FitnessWorkoutAnalysisResponse>> saveAnalysis(
    int sessionId,
    FitnessWorkoutAnalysisRequest request,
  ) async {
    try {
      final response = await _dioClient.dio.post(
        'fitness/workouts/$sessionId/analysis',
        data: request.toJson(),
      );
      if (response.data != null) {
        return ApiSuccess(FitnessWorkoutAnalysisResponse.fromJson(response.data));
      }
      return ApiError(ApiException(message: 'Failed to save workout analysis'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<bool>> addRoutePoints(
    int sessionId,
    WorkoutRoutePointsRequest request,
  ) async {
    try {
      await _dioClient.dio.post(
        'fitness/workouts/$sessionId/route-points',
        data: request.toJson(),
      );
      return ApiSuccess(true);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } on ApiException catch (e) {
      return ApiError(e);
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  Future<ApiResult<List<SharedWorkoutPostResponse>>> getWorkoutSocialFeed() async {
    try {
      final response = await _dioClient.dio.get('fitness/workouts/social-feed');
      if (response.data != null && response.data is List) {
        final list = (response.data as List)
            .map((item) => SharedWorkoutPostResponse.fromJson(item as Map<String, dynamic>))
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

  Future<ApiResult<bool>> updateWorkoutSharing(int sessionId, ShareWorkoutRequest request) async {
    try {
      await _dioClient.dio.patch(
        'fitness/workouts/$sessionId/share',
        data: request.toJson(),
      );
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


