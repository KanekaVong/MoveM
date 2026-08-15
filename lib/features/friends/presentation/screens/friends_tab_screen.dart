import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/friend_request_tile.dart';
import '../widgets/friend_suggestion_tile.dart';
import '../controllers/friends_controller.dart';

class FriendsTabScreen extends GetView<FriendsController> {
  final int initialIndex;

  const FriendsTabScreen({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: initialIndex,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F172A),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: const TabBar(
            indicatorColor: Color(0xFF3B82F6),
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xFFA0AAB2),
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: [
              Tab(text: 'Friend Request'),
              Tab(text: 'Suggestions'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() => _buildRequestsTab()),
            Obx(() => _buildSuggestionsTab()),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsTab() {
    if (controller.incomingRequests.isEmpty) {
      return const Center(child: Text('No friend requests.', style: TextStyle(color: Color(0xFFA0AAB2))));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2F),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1E293B), width: 1),
        ),
        child: Column(
          children: controller.incomingRequests.asMap().entries.map((entry) {
            final req = entry.value;
            final isLast = entry.key == controller.incomingRequests.length - 1;
            return Column(
              children: [
                FriendRequestTile(
                  imageUrl: req.senderProfilePic.isNotEmpty ? req.senderProfilePic : 'https://ui-avatars.com/api/?name=${req.senderUsername}',
                  name: req.senderUsername,
                  username: '@${req.senderUsername}',
                  onAccept: () => controller.acceptRequest(req.requestId),
                  onReject: () => controller.rejectRequest(req.requestId),
                ),
                if (!isLast) const Divider(color: Color(0xFF1E293B)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSuggestionsTab() {
    if (controller.searchResults.isEmpty) {
      return const Center(child: Text('No suggestions found.', style: TextStyle(color: Color(0xFFA0AAB2))));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2F),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1E293B), width: 1),
        ),
        child: Column(
          children: controller.searchResults.asMap().entries.map((entry) {
            final user = entry.value;
            final isLast = entry.key == controller.searchResults.length - 1;
            return Column(
              children: [
                FriendSuggestionTile(
                  imageUrl: user.profilePic.isNotEmpty ? user.profilePic : 'https://ui-avatars.com/api/?name=${user.firstname}+${user.lastname}',
                  name: '${user.firstname} ${user.lastname}'.trim().isEmpty ? user.username : '${user.firstname} ${user.lastname}',
                  username: '@${user.username}',
                  onAdd: () => controller.sendRequest(user.userId),
                ),
                if (!isLast) const Divider(color: Color(0xFF1E293B)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

