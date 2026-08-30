import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network/api_result.dart';
import '../../../../shared/base/base_controller.dart';
import '../../../friends/data/dto/response/friend_response.dart';
import '../../../friends/data/repositories/friends_repository_impl.dart';
import '../../../friends/data/services/friends_service.dart';
import '../../../friends/domain/repositories/friends_repository.dart';

class AddCollaboratorController extends BaseController {
  final FriendsRepository friendsRepository = FriendsRepositoryImpl(friendsService: FriendsService());
  final searchController = TextEditingController();

  final RxList<FriendResponse> friends = <FriendResponse>[].obs;
  final RxList<FriendResponse> searchResults = <FriendResponse>[].obs;
  final RxSet<FriendResponse> selectedFriends = <FriendResponse>{}.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFriends();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchFriends() async {
    await executeApi<List<FriendResponse>>(
      apiCall: () => friendsRepository.getFriends(),
      showLoading: true,
      onSuccess: (data) {
        friends.assignAll(data);
      },
    );
  }

  Future<void> onSearchChanged(String query) async {
    searchQuery.value = query;
    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    final result = await friendsRepository.searchFriends(query.trim());
    if (result is ApiSuccess<List<FriendResponse>>) {
      searchResults.assignAll(result.data);
    }
  }

  List<FriendResponse> get displayedUsers {
    if (searchQuery.value.trim().isNotEmpty && searchResults.isNotEmpty) {
      return searchResults;
    }
    if (searchQuery.value.trim().isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      return friends.where((f) {
        final fullName = '${f.firstname} ${f.lastname}'.toLowerCase();
        final username = f.username.toLowerCase();
        return fullName.contains(query) || username.contains(query);
      }).toList();
    }
    return friends;
  }

  void toggleSelection(FriendResponse friend) {
    if (selectedFriends.contains(friend)) {
      selectedFriends.remove(friend);
    } else {
      selectedFriends.add(friend);
    }
  }

  void inviteSelected() {
    if (selectedFriends.isNotEmpty) {
      final selectedList = selectedFriends.map((f) {
        final displayName = '${f.firstname} ${f.lastname}'.trim();
        return {
          'userId': f.userId,
          'name': displayName.isNotEmpty ? displayName : f.username,
          'username': f.username,
          'profilePic': f.profilePic,
        };
      }).toList();
      Get.back(result: selectedList);
    } else if (searchQuery.value.trim().isNotEmpty) {
      inviteCustom(searchQuery.value.trim());
    } else {
      Get.back();
    }
  }

  void inviteCustom(String name) {
    Get.back(result: [
      {
        'name': name.trim(),
        'username': name.trim(),
      }
    ]);
  }
}
