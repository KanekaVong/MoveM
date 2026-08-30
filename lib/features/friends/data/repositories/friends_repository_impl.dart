import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../domain/repositories/friends_repository.dart';
import '../services/friends_service.dart';
import '../dto/response/friend_response.dart';
import '../dto/response/friend_request_response.dart';

class FriendsRepositoryImpl implements FriendsRepository {
  final FriendsService friendsService;
  final _logger = Logger();

  FriendsRepositoryImpl({required this.friendsService});

  String _parseSuccessMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('message')) {
        return data['message'].toString();
      }
      if (data['status'] == 'ACCEPTED') {
        return 'Friend request accepted';
      }
      if (data['status'] == 'REJECTED') {
        return 'Friend request rejected';
      }
    }
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('message')) {
            return decoded['message'].toString();
          }
          if (decoded['status'] == 'ACCEPTED') {
            return 'Friend request accepted';
          }
          if (decoded['status'] == 'REJECTED') {
            return 'Friend request rejected';
          }
        }
      } catch (_) {}
    }
    return data.toString();
  }

  @override
  Future<ApiResult<List<FriendResponse>>> getFriends() async {
    try {
      _logger.i('Calling GET api/friends');
      final response = await friendsService.getFriends();
      _logger.i('getFriends Response [${response.statusCode}]');

      final List<dynamic> data = response.data;
      final friends = data.map((e) => FriendResponse.fromJson(e)).toList();
      return ApiSuccess(friends);
    } on DioException catch (e) {
      _logger.e('getFriends Error: ${e.response?.data ?? e.message}');
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      _logger.e('getFriends Error: $e');
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<List<FriendResponse>>> searchFriends(String keyword) async {
    try {
      _logger.i('Calling GET api/friends/search with keyword: $keyword');
      final response = await friendsService.searchFriends(keyword);
      _logger.i('searchFriends Response [${response.statusCode}]');

      final List<dynamic> data = response.data;
      final friends = data.map((e) => FriendResponse.fromJson(e)).toList();
      return ApiSuccess(friends);
    } on DioException catch (e) {
      _logger.e('searchFriends Error: ${e.response?.data ?? e.message}');
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      _logger.e('searchFriends Error: $e');
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<String>> deleteFriend(int friendId) async {
    try {
      _logger.i('Calling DELETE api/friends/$friendId');
      final response = await friendsService.deleteFriend(friendId);
      _logger.i('deleteFriend Response [${response.statusCode}]');
      return ApiSuccess(_parseSuccessMessage(response.data));
    } on DioException catch (e) {
      _logger.e('deleteFriend Error: ${e.response?.data ?? e.message}');
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      _logger.e('deleteFriend Error: $e');
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<List<FriendRequestResponse>>> getIncomingRequests() async {
    try {
      _logger.i('Calling GET api/friends/requests/incoming');
      final response = await friendsService.getIncomingRequests();
      _logger.i('getIncomingRequests Response [${response.statusCode}]');

      final List<dynamic> data = response.data;
      final requests = data.map((e) => FriendRequestResponse.fromJson(e)).toList();
      return ApiSuccess(requests);
    } on DioException catch (e) {
      _logger.e('getIncomingRequests Error: ${e.response?.data ?? e.message}');
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      _logger.e('getIncomingRequests Error: $e');
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<List<FriendRequestResponse>>> getOutgoingRequests() async {
    try {
      _logger.i('Calling GET api/friends/requests/outgoing');
      final response = await friendsService.getOutgoingRequests();
      _logger.i('getOutgoingRequests Response [${response.statusCode}]');

      final List<dynamic> data = response.data;
      final requests = data.map((e) => FriendRequestResponse.fromJson(e)).toList();
      return ApiSuccess(requests);
    } on DioException catch (e) {
      _logger.e('getOutgoingRequests Error: ${e.response?.data ?? e.message}');
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      _logger.e('getOutgoingRequests Error: $e');
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<String>> sendFriendRequest(String username) async {
    try {
      _logger.i('Calling POST api/friends/request with username: $username');
      final response = await friendsService.sendFriendRequest(username);
      return ApiSuccess(_parseSuccessMessage(response.data));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<String>> acceptFriendRequest(int requestId) async {
    try {
      _logger.i('Calling PUT api/friends/requests/$requestId/accept');
      final response = await friendsService.acceptFriendRequest(requestId);
      return ApiSuccess(_parseSuccessMessage(response.data));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<String>> rejectFriendRequest(int requestId) async {
    try {
      _logger.i('Calling PUT api/friends/requests/$requestId/reject');
      final response = await friendsService.rejectFriendRequest(requestId);
      return ApiSuccess(_parseSuccessMessage(response.data));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<String>> cancelFriendRequest(int requestId) async {
    try {
      _logger.i('Calling DELETE api/friends/friend-requests/$requestId');
      final response = await friendsService.cancelFriendRequest(requestId);
      return ApiSuccess(_parseSuccessMessage(response.data));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }
}
