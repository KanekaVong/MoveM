import 'package:dio/dio.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/fitness_profile_model.dart';
import '../models/solo_challenge_model.dart';
import '../models/setup_goal_request.dart';

class FitnessProfileRepository {
  final DioClient _dioClient = DioClient();

  Future<ApiResult<FitnessProfileModel>> getProfile() async {
    try {
      final response = await _dioClient.dio.get('fitness/profile');
      if (response.data != null) {
        return ApiSuccess(FitnessProfileModel.fromJson(response.data));
      }
      return ApiError(ApiException(message: 'Profile not found'));
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
        'fitness/profile',
        data: {
          'height': height,
          'weight': weight,
        },
      );
      if (response.data != null) {
        return ApiSuccess(FitnessProfileModel.fromJson(response.data));
      }
      return ApiError(ApiException(message: 'Creation failed'));
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
}
