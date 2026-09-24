import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../domain/repositories/friends_repository.dart';
import '../services/friends_service.dart';
import '../dto/response/friend_response.dart';
import '../dto/response/friend_request_response.dart';
import '../dto/response/public_user_profile_response.dart';

class FriendsRepositoryImpl implements FriendsRepository {
  final FriendsService friendsService;

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

  Map<String, dynamic>? _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {}
    }
    return null;
  }

  List<Map<String, dynamic>> _asList(dynamic data) {
    dynamic raw = data;
    if (raw is Map && raw['data'] is List) raw = raw['data'];
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  @override
  Future<ApiResult<PublicUserProfileResponse>> getUserById(String userId) async {
    try {
      final response = await friendsService.getUserById(userId);
      final map = _asMap(response.data);
      if (map == null) {
        return ApiError(ApiException(message: 'Invalid user profile response from server.'));
      }
      return ApiSuccess(PublicUserProfileResponse.fromJson(map));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<List<FriendResponse>>> getFriends() async {
    try {
      final response = await friendsService.getFriends();
      final friends = _asList(response.data).map(FriendResponse.fromJson).toList();
      return ApiSuccess(friends);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<List<FriendResponse>>> searchFriends(String keyword) async {
    try {
      final response = await friendsService.searchFriends(keyword);

      final List<dynamic> data = response.data;
      final friends = data.map((e) => FriendResponse.fromJson(e)).toList();
      return ApiSuccess(friends);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<List<FriendResponse>>> getSuggestions() async {
    try {
      final response = await friendsService.getSuggestions();

      final List<dynamic> data = response.data;
      final suggestions = data.map((e) => FriendResponse.fromJson(e)).toList();
      return ApiSuccess(suggestions);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<String>> deleteFriend(int friendId) async {
    try {
      final response = await friendsService.deleteFriend(friendId);
      return ApiSuccess(_parseSuccessMessage(response.data));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<List<FriendRequestResponse>>> getIncomingRequests() async {
    try {
      final response = await friendsService.getIncomingRequests();
      final requests = _asList(response.data).map(FriendRequestResponse.fromJson).toList();
      return ApiSuccess(requests);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<List<FriendRequestResponse>>> getOutgoingRequests() async {
    try {
      final response = await friendsService.getOutgoingRequests();
      final requests = _asList(response.data).map(FriendRequestResponse.fromJson).toList();
      return ApiSuccess(requests);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<String>> sendFriendRequest(String username) async {
    try {
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
      final response = await friendsService.cancelFriendRequest(requestId);
      return ApiSuccess(_parseSuccessMessage(response.data));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }
}
