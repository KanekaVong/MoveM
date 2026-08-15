import 'package:get/get.dart';
import '../../../../shared/base/base_controller.dart';
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

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  void loadInitialData() {
    getFriends();
    getIncomingRequests();
    getOutgoingRequests();
    // Initially populate search results with all friends for the "Suggestions" tab
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
        getFriends(); // Refresh friends list
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
        
        // Update the search results to show pending status
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

  Future<void> deleteFriend(int friendId) async {
    await executeApi(
      apiCall: () => repository.deleteFriend(friendId),
      onSuccess: (data) {
        friends.removeWhere((f) => f.userId == friendId);
      },
    );
  }
}
