import 'package:dio/dio.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/achievement_model.dart';

class FitnessAchievementRepository {
  final DioClient _dioClient = DioClient();

  Future<ApiResult<List<AchievementResponseModel>>> getAllAchievements() async {
    try {
      final response = await _dioClient.dio.get('fitness/achievements');
      if (response.data != null && response.data is List) {
        final list = (response.data as List)
            .map((item) => AchievementResponseModel.fromJson(item))
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

  Future<ApiResult<List<UserAchievementModel>>> getMyAchievements() async {
    try {
      final response = await _dioClient.dio.get('fitness/achievements/me');
      if (response.data != null && response.data is List) {
        final list = (response.data as List)
            .map((item) => UserAchievementModel.fromJson(item))
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

  Future<ApiResult<int>> getMyAchievementCount() async {
    try {
      final response = await _dioClient.dio.get('fitness/achievements/me/count');
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
}

typedef AchievementResponseModel = AchievementModel;
