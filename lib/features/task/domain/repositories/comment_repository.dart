import '../../../../core/network/api_result.dart';
import '../../data/dto/response/comment_response.dart';
import '../../data/dto/response/page_comment_response.dart';

abstract class CommentRepository {
  Future<ApiResult<PageCommentResponse>> getComments(String activityId, {int page = 0, int size = 30});
  Future<ApiResult<CommentResponse>> createComment(String activityId, String content);
  Future<ApiResult<CommentResponse>> updateComment(int commentId, String content);
  Future<ApiResult<void>> deleteComment(int commentId);
}
