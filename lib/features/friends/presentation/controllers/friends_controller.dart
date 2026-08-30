import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/storage/user_manager.dart';
import '../../../../shared/base/base_controller.dart';
import '../../../auth/data/dto/response/user_response.dart';
import '../../domain/repositories/friends_repository.dart';
import '../../data/dto/response/friend_response.dart';
import '../../data/dto/response/friend_request_response.dart';

class FriendsController extends BaseController {
  final FriendsRepository repository;

  FriendsController({required this.repository});

  final RxList<FriendResponse> friends = <FriendResponse>[].obs;
  final RxList<FriendResponse> searchResults = <FriendResponse>[].obs;
  final RxList<FriendRequestResponse> incomingRequests = <FriendRequestResponse>[].obs;
  final RxList<FriendRequestResponse> outgoingRequests = <FriendRequestResponse>[].obs;
  final RxString searchQuery = ''.obs;
  final Rx<UserResponse?> currentUser = Rx<UserResponse?>(null);

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
    loadInitialData();
  }

  void loadUserProfile() {
    currentUser.value = UserManager().getUser();
  }

  String get profileName {
    final u = currentUser.value;
    final fullName = [u?.firstName, u?.lastName]
        .where((v) => v != null && v.trim().isNotEmpty)
        .join(' ');
    if (fullName.isNotEmpty) return fullName;
    return u?.username.isNotEmpty == true ? u!.username : 'Your Profile';
  }

  String get profileUsername => currentUser.value?.username.isNotEmpty == true ? currentUser.value!.username : 'user';
  String? get profilePic => currentUser.value?.profilePic;
  int get friendCount => friends.length;

  void copyProfileLink() {
    final link = 'https://movem.app/user/@$profileUsername';
    Clipboard.setData(ClipboardData(text: link));
    Get.snackbar('Copied', 'Profile link copied to clipboard', backgroundColor: const Color(0xFF48A45B), colorText: Colors.white);
  }

  void loadInitialData() {
    getFriends();
    getIncomingRequests();
    getOutgoingRequests();

    searchFriends('');
  }

  Future<void> getFriends() async {
    await executeApi(
      apiCall: () => repository.getFriends(),
      onSuccess: (data) {
        friends.assignAll(data);
      },
      showLoading: false,
      showErrorDialog: false,
    );
  }

  Future<void> searchFriends(String keyword) async {
    searchQuery.value = keyword;
    await executeApi(
      apiCall: () => repository.searchFriends(keyword),
      onSuccess: (data) {
        searchResults.assignAll(data);
      },
      showLoading: false,
      showErrorDialog: false,
    );
  }

  Future<void> getIncomingRequests() async {
    await executeApi(
      apiCall: () => repository.getIncomingRequests(),
      onSuccess: (data) {
        incomingRequests.assignAll(data);
      },
      showLoading: false,
      showErrorDialog: false,
    );
  }

  Future<void> getOutgoingRequests() async {
    await executeApi(
      apiCall: () => repository.getOutgoingRequests(),
      onSuccess: (data) {
        outgoingRequests.assignAll(data);
      },
      showLoading: false,
      showErrorDialog: false,
    );
  }

  Future<void> acceptRequest(int requestId) async {
    await executeApi(
      apiCall: () => repository.acceptFriendRequest(requestId),
      onSuccess: (data) {
        incomingRequests.removeWhere((req) => req.requestId == requestId);
        getFriends();
      },
    );
  }

  Future<void> rejectRequest(int requestId) async {
    await executeApi(
      apiCall: () => repository.rejectFriendRequest(requestId),
      onSuccess: (data) {
        incomingRequests.removeWhere((req) => req.requestId == requestId);
      },
    );
  }

  Future<void> sendRequest(String username) async {
    await executeApi(
      apiCall: () => repository.sendFriendRequest(username),
      onSuccess: (data) {
        getOutgoingRequests();

        final index = searchResults.indexWhere((user) => user.username == username);
        if (index != -1) {
          final user = searchResults[index];
          searchResults[index] = FriendResponse(
            userId: user.userId,
            username: user.username,
            firstname: user.firstname,
            lastname: user.lastname,
            profilePic: user.profilePic,
            friendStatus: 'PENDING_REQUEST',
          );
        }
      },
    );
  }

  Future<void> cancelRequest(String username) async {
    try {
      final request = outgoingRequests.firstWhere((req) => req.receiverUsername == username);
      await executeApi(
        apiCall: () => repository.cancelFriendRequest(request.requestId),
        onSuccess: (data) {
          outgoingRequests.removeWhere((req) => req.requestId == request.requestId);

          final index = searchResults.indexWhere((user) => user.username == username);
          if (index != -1) {
            final user = searchResults[index];
            searchResults[index] = FriendResponse(
              userId: user.userId,
              username: user.username,
              firstname: user.firstname,
              lastname: user.lastname,
              profilePic: user.profilePic,
              friendStatus: null,
            );
          }
        },
      );
    } catch (e) {

      Get.snackbar('Error', 'Unable to cancel request. Please try again later.');
    }
  }

  Future<void> deleteFriend(int friendId) async {
    await executeApi(
      apiCall: () => repository.deleteFriend(friendId),
      onSuccess: (data) {
        friends.removeWhere((f) => f.userId == friendId);
      },
    );
  }
}
