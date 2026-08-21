import 'package:dio/dio.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../domain/repositories/home_repository.dart';
import '../dto/response/dashboard_response.dart';
import '../services/home_service.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeService _service;

  HomeRepositoryImpl(this._service);

  @override
  Future<ApiResult<DashboardResponse>> getDashboard() async {
    try {
      final response = await _service.getDashboard();
      return ApiSuccess(DashboardResponse.fromJson(response.data));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }
}
