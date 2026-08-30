import 'package:dio/dio.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/repositories/invite_repository.dart';
import '../dto/response/invite_response.dart';
import '../services/invite_service.dart';

class InviteRepositoryImpl implements InviteRepository {
  final InviteService _service;

  InviteRepositoryImpl(this._service);

  @override
  Future<ApiResult<InviteResponse>> getInvite(String token) async {
    try {
      final response = await _service.getInvite(token);
      return ApiSuccess(InviteResponse.fromJson(response.data));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<InviteResponse>> createInvite() async {
    try {
      final response = await _service.createInvite();
      return ApiSuccess(InviteResponse.fromJson(response.data));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }
}
