import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class CommentService {
  final Dio dio = DioClient().dio;

  Future<Response> getComments(String activityId, {int page = 0, int size = 30}) async {
    return await dio.get(
      'comments/$activityId',
      queryParameters: {
        'page': page,
        'size': size,
      },
      options: Options(responseType: ResponseType.json),
    );
  }

  Future<Response> createComment(String activityId, String content) async {
    return await dio.post(
      'comments/$activityId',
      data: {
        'content': content,
      },
      options: Options(responseType: ResponseType.json),
    );
  }

  Future<Response> updateComment(int commentId, String content) async {
    return await dio.put(
      'comments/$commentId',
      data: {
        'content': content,
      },
      options: Options(responseType: ResponseType.json),
    );
  }

  Future<Response> deleteComment(int commentId) async {
    return await dio.delete(
      'comments/$commentId',
      options: Options(responseType: ResponseType.json),
    );
  }
}
