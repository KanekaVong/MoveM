import '../../../../core/network/api_result.dart';
import '../../data/dto/response/friend_response.dart';
import '../../data/dto/response/friend_request_response.dart';
import '../../data/dto/response/public_user_profile_response.dart';

abstract class FriendsRepository {
  Future<ApiResult<PublicUserProfileResponse>> getUserById(String userId);
  Future<ApiResult<List<FriendResponse>>> getFriends();
  Future<ApiResult<List<FriendResponse>>> searchFriends(String keyword);
  Future<ApiResult<List<FriendResponse>>> getSuggestions();
  Future<ApiResult<String>> deleteFriend(int friendId);
  Future<ApiResult<List<FriendRequestResponse>>> getIncomingRequests();
  Future<ApiResult<List<FriendRequestResponse>>> getOutgoingRequests();

  Future<ApiResult<String>> sendFriendRequest(String username);
  Future<ApiResult<String>> acceptFriendRequest(int requestId);
  Future<ApiResult<String>> rejectFriendRequest(int requestId);
  Future<ApiResult<String>> cancelFriendRequest(int requestId);
}
