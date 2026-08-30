import 'package:dio/dio.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/repositories/comment_repository.dart';
import '../dto/response/comment_response.dart';
import '../dto/response/page_comment_response.dart';
import '../services/comment_service.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentService _service;

  CommentRepositoryImpl(this._service);

  @override
  Future<ApiResult<PageCommentResponse>> getComments(String activityId, {int page = 0, int size = 30}) async {
    try {
      final response = await _service.getComments(activityId, page: page, size: size);
      final pageResponse = PageCommentResponse.fromJson(response.data);
      return ApiSuccess(pageResponse);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<CommentResponse>> createComment(String activityId, String content) async {
    try {
      final response = await _service.createComment(activityId, content);
      final comment = CommentResponse.fromJson(response.data);
      return ApiSuccess(comment);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<CommentResponse>> updateComment(int commentId, String content) async {
    try {
      final response = await _service.updateComment(commentId, content);
      final comment = CommentResponse.fromJson(response.data);
      return ApiSuccess(comment);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> deleteComment(int commentId) async {
    try {
      await _service.deleteComment(commentId);
      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }
}
