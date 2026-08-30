import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import 'friends_tab_screen.dart';
import 'invite_friend_screen.dart';
import 'my_qr_code_screen.dart';
import 'qr_scan_screen.dart';
import '../bindings/friends_binding.dart';
import '../widgets/friend_request_tile.dart';
import '../widgets/friend_suggestion_tile.dart';
import '../controllers/friends_controller.dart';

class AddFriendsScreen extends GetView<FriendsController> {
  const AddFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<FriendsController>()) {
      FriendsBinding().dependencies();
    }
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.slate900,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildSearchBar(context),
              const SizedBox(height: 24),
              _buildActionCards(context),
              const SizedBox(height: 32),
              _buildSectionHeader(l10n?.friendRequests ?? 'Friend Requests', 0),
              const SizedBox(height: 16),
              Obx(() => _buildRequestsList()),
              const SizedBox(height: 32),
              Obx(() => _buildSectionHeader(
                    controller.searchQuery.value.trim().isNotEmpty
                        ? (l10n?.searchResults ?? 'Search Results')
                        : (l10n?.friendSuggestions ?? 'Friend Suggestions'),
                    1,
                  )),
              const SizedBox(height: 16),
              Obx(() => _buildSuggestionsList()),
              const SizedBox(height: 32),
              _buildShareProfile(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            Text(
              l10n?.addFriends ?? 'Add Friends',
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Padding(
          padding: EdgeInsets.only(left: 28.0),
          child: Text(
            'Find And Connect With Friends To Stay Active Together',
            style: TextStyle(color: AppColors.slate200, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.slate850,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate800),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white, fontSize: 12),
        onChanged: (value) => controller.searchFriends(value),
        decoration: InputDecoration(
          hintText: l10n?.search ?? 'Search For People On MoveM',
          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: const Icon(Icons.search, color: AppColors.blueAccent),
        ),
      ),
    );
  }

  Widget _buildActionCards(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Get.to(() => const QrScanScreen()),
            child: _buildActionCard(
              Icons.qr_code_scanner,
              l10n?.scanQrCode ?? 'Scan QR Code',
              l10n?.scanQrCodeSub ?? "Scan Your Friend's QR Code",
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => Get.to(() => const InviteFriendScreen()),
            child: _buildActionCard(
              Icons.person_add_alt_1,
              l10n?.inviteFriendsViaLink ?? 'Invite Friends',
              l10n?.inviteFriendsViaLinkSub ?? 'Invite Friends Via Links',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.slate850,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate800),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryBlueStart.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.blueAccent, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 12), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int tabIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: () {
            Get.to(() => FriendsTabScreen(initialIndex: tabIndex));
          },
          child: Row(
            children: [
              const Text('View All', style: TextStyle(color: AppColors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_ios, color: AppColors.blueAccent, size: 10),
            ],
          ),
        ),
      ],
    );
  }

  String _getAvatarUrl(String? profilePic, String fallbackName) {
    if (profilePic != null && profilePic.trim().isNotEmpty) {
      return profilePic;
    }
    final name = fallbackName.trim().isNotEmpty ? fallbackName.trim() : 'User';
    return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=334155&color=fff';
  }

  Widget _buildRequestsList() {
    if (controller.incomingRequests.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.slate850,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.slate800),
        ),
        child: const Center(child: Text('No friend requests.', style: TextStyle(color: AppColors.textMuted))),
      );
    }

    final displayList = controller.incomingRequests.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.slate850,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate800),
      ),
      child: Column(
        children: displayList.asMap().entries.map((entry) {
          final req = entry.value;
          final isLast = entry.key == displayList.length - 1;
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
              if (!isLast) const Divider(color: AppColors.slate800),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSuggestionsList() {
    final isSearching = controller.searchQuery.value.trim().isNotEmpty;
    final list = isSearching ? controller.searchResults : controller.suggestedFriends;

    if (list.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.slate850,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.slate800),
        ),
        child: Center(
          child: Text(
            isSearching ? 'No users found matching your search.' : 'No suggestions found.',
            style: const TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    final displayList = list.take(4).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.slate850,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate800),
      ),
      child: Column(
        children: displayList.asMap().entries.map((entry) {
          final user = entry.value;
          final isLast = entry.key == displayList.length - 1;
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
              if (!isLast) const Divider(color: AppColors.slate800),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildShareProfile(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n?.shareYourProfile ?? 'Share Your Profile', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Obx(() {
          final profileName = controller.profileName;
          final username = controller.profileUsername;
          final profilePic = controller.profilePic;
          final friendCount = controller.friendCount;
          final initial = username.isNotEmpty ? username[0].toUpperCase() : 'U';

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.slate850,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.slate800),
            ),
            child: Row(
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: (profilePic != null && profilePic.isNotEmpty)
                        ? CachedNetworkImage(
                            imageUrl: profilePic,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => CircleAvatar(
                              backgroundColor: AppColors.slate700,
                              child: Text(initial, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                            errorWidget: (_, __, ___) => CircleAvatar(
                              backgroundColor: AppColors.slate700,
                              child: Text(initial, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: AppColors.slate700,
                            child: Text(initial, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profileName,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '@$username',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '$friendCount ${l10n?.friends ?? 'Friends'}',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                _buildProfileAction(
                  Icons.qr_code,
                  l10n?.myQrCode ?? 'QR Code',
                  onTap: () => Get.to(() => const MyQrCodeScreen()),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildProfileAction(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryBlueStart.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.blueAccent.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: AppColors.blueAccent, size: 20),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 8)),
        ],
      ),
    );
  }
}
