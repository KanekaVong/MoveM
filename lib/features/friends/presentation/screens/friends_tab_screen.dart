import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../bindings/friends_binding.dart';
import '../widgets/friend_request_tile.dart';
import '../widgets/friend_suggestion_tile.dart';
import '../controllers/friends_controller.dart';
import '../../../../shared/widgets/no_data_component.dart';
import '../../../../shared/widgets/top_tool_bar.dart';

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
    if (!Get.isRegistered<FriendsController>()) {
      FriendsBinding().dependencies();
    }
    final l10n = AppLocalizations.of(context);

    return DefaultTabController(
      length: 4,
      initialIndex: initialIndex.clamp(0, 3),
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        appBar: TopToolBar(
          title: l10n?.friends ?? 'Friends',
          onBack: () => Navigator.pop(context),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: AppColors.accentBlue,
            labelColor: AppColors.textPrimary,
            unselectedLabelColor: AppColors.textCaption,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            tabs: [
              Tab(text: l10n?.myFriends ?? 'My Friends'),
              Tab(text: l10n?.friendRequests ?? 'Friend Requests'),
              Tab(text: l10n?.myRequests ?? 'My Requests'),
              Tab(text: l10n?.suggestionsTab ?? 'Suggestions'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() => _buildMyFriendsTab(l10n)),
            Obx(() => _buildRequestsTab(l10n)),
            Obx(() => _buildMyRequestsTab(l10n)),
            Obx(() => _buildSuggestionsTab(l10n)),
          ],
        ),
      ),
    );
  }

  Widget _buildMyFriendsTab(AppLocalizations? l10n) {
    if (controller.friends.isEmpty) {
      return NoDataComponent(
        title: l10n?.noFriendsYet ?? 'No friends yet',
        subtitle: l10n?.noFriendsYetSub ?? 'People you add will appear here.',
      );
    }

    return _wrapList(
      children: controller.friends.asMap().entries.map((entry) {
        final user = entry.value;
        final isLast = entry.key == controller.friends.length - 1;
        final fullName = '${user.firstname} ${user.lastname}'.trim();
        final displayName = fullName.isNotEmpty
            ? fullName
            : (user.username.isNotEmpty ? user.username : 'User');
        return Column(
          children: [
            FriendSuggestionTile(
              imageUrl: _getAvatarUrl(user.profilePic, displayName),
              name: displayName,
              username: '@${user.username}',
              friendStatus: 'FRIEND',
              onAdd: () {},
              onUnfriend: () => controller.deleteFriend(user.userId),
            ),
            if (!isLast) Divider(color: AppColors.borderLight),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildRequestsTab(AppLocalizations? l10n) {
    if (controller.incomingRequests.isEmpty) {
      return NoDataComponent(
        title: l10n?.noFriendRequests ?? 'No friend requests',
        subtitle: l10n?.noFriendRequestsSub ??
            'When someone sends you a request, it will show up here.',
      );
    }

    return _wrapList(
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
            if (!isLast) Divider(color: AppColors.borderLight),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildMyRequestsTab(AppLocalizations? l10n) {
    if (controller.outgoingRequests.isEmpty) {
      return NoDataComponent(
        title: l10n?.noRequestsSent ?? 'No requests sent',
        subtitle: l10n?.noRequestsSentSub ?? 'Friend requests you send will appear here.',
      );
    }

    return _wrapList(
      children: controller.outgoingRequests.asMap().entries.map((entry) {
        final req = entry.value;
        final isLast = entry.key == controller.outgoingRequests.length - 1;
        final displayName =
            req.receiverUsername.isNotEmpty ? req.receiverUsername : 'User';
        return Column(
          children: [
            FriendSuggestionTile(
              imageUrl: _getAvatarUrl(req.receiverProfilePic, displayName),
              name: displayName,
              username: '@${req.receiverUsername}',
              friendStatus: 'PENDING_REQUEST',
              onAdd: () {},
              onCancel: () => controller.cancelRequest(req.receiverUsername),
            ),
            if (!isLast) Divider(color: AppColors.borderLight),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSuggestionsTab(AppLocalizations? l10n) {
    final isSearching = controller.searchQuery.value.trim().isNotEmpty;
    final list = isSearching ? controller.searchResults : controller.suggestedFriends;

    if (list.isEmpty) {
      return NoDataComponent(
        title: isSearching
            ? (l10n?.noUsersFound ?? 'No users found')
            : (l10n?.noSuggestionsFound ?? 'No suggestions found'),
        subtitle: isSearching
            ? (l10n?.nothingMatchesSearch ?? 'Nothing matches your search.')
            : (l10n?.noSuggestionsFoundSub ?? 'We do not have anyone to suggest right now.'),
      );
    }

    return _wrapList(
      children: list.asMap().entries.map((entry) {
        final user = entry.value;
        final isLast = entry.key == list.length - 1;
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
            if (!isLast) Divider(color: AppColors.borderLight),
          ],
        );
      }).toList(),
    );
  }

  Widget _wrapList({required List<Widget> children}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight, width: 1),
        ),
        child: Column(children: children),
      ),
    );
  }
}
