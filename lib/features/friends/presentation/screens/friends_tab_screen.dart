import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/friend_request_tile.dart';
import '../widgets/friend_suggestion_tile.dart';
import '../controllers/friends_controller.dart';

class FriendsTabScreen extends GetView<FriendsController> {
  final int initialIndex;

  const FriendsTabScreen({super.key, this.initialIndex = 0});

  String _getAvatarUrl(String? profilePic, String fallbackName) {
    if (profilePic != null && profilePic.trim().isNotEmpty) {
      return profilePic;
    }
    final name = fallbackName.trim().isNotEmpty ? fallbackName.trim() : 'User';
    return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=334155&color=fff';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
          centerTitle: true,
          title: Text(
            l10n?.friends ?? 'Friends',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            indicatorColor: const Color(0xFF3B82F6),
            labelColor: Colors.white,
            unselectedLabelColor: const Color(0xFFA0AAB2),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: [
              Tab(text: l10n?.friendRequests ?? 'Friend Request'),
              Tab(text: l10n?.friendSuggestions ?? 'Suggestions'),
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
            final displayName = req.senderUsername.isNotEmpty ? req.senderUsername : 'User';
            return Column(
              children: [
                FriendRequestTile(
                  imageUrl: _getAvatarUrl(req.senderProfilePic, displayName),
                  name: displayName,
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
            final fullName = '${user.firstname} ${user.lastname}'.trim();
            final displayName = fullName.isNotEmpty ? fullName : (user.username.isNotEmpty ? user.username : 'User');
            return Column(
              children: [
                FriendSuggestionTile(
                  imageUrl: _getAvatarUrl(user.profilePic, displayName),
                  name: displayName,
                  username: '@${user.username}',
                  friendStatus: user.friendStatus,
                  onAdd: () => controller.sendRequest(user.username),
                  onCancel: () => controller.cancelRequest(user.username),
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
