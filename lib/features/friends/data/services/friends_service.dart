import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class FriendsService {
  final Dio dio = DioClient().dio;

  Future<Response> getFriends() async {
    return await dio.get('friends');
  }

  Future<Response> searchFriends(String keyword) async {
    return await dio.get('friends/search', queryParameters: {'keyword': keyword});
  }

  Future<Response> deleteFriend(int friendId) async {
    return await dio.delete('friends/$friendId', options: Options(responseType: ResponseType.plain));
  }

  Future<Response> getIncomingRequests() async {
    return await dio.get('friends/requests/incoming');
  }

  Future<Response> getOutgoingRequests() async {
    return await dio.get('friends/requests/outgoing');
  }

  Future<Response> sendFriendRequest(int friendId) async {
    return await dio.post('friends/requests', data: {'receiverId': friendId}, options: Options(responseType: ResponseType.plain));
  }

  Future<Response> acceptFriendRequest(int requestId) async {
    return await dio.put('friends/requests/$requestId/accept', options: Options(responseType: ResponseType.plain));
  }

  Future<Response> rejectFriendRequest(int requestId) async {
    return await dio.put('friends/requests/$requestId/reject', options: Options(responseType: ResponseType.plain));
  }
}
