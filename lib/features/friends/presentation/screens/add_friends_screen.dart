import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'friends_tab_screen.dart';
import '../widgets/friend_request_tile.dart';
import '../widgets/friend_suggestion_tile.dart';
import '../controllers/friends_controller.dart';

class AddFriendsScreen extends GetView<FriendsController> {
  const AddFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildSearchBar(),
              const SizedBox(height: 24),
              _buildActionCards(),
              const SizedBox(height: 32),
              _buildSectionHeader('Friend Requests', 0),
              const SizedBox(height: 16),
              Obx(() => _buildRequestsList()),
              const SizedBox(height: 32),
              _buildSectionHeader('Friend Suggestions', 1),
              const SizedBox(height: 16),
              Obx(() => _buildSuggestionsList()),
              const SizedBox(height: 32),
              _buildShareProfile(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 8),
            const Text(
              'Add Friends',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Padding(
          padding: EdgeInsets.only(left: 32.0),
          child: Text(
            'Find And Connect With Friends To Stay Active Together',
            style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131B2F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        onChanged: (value) => controller.searchFriends(value),
        decoration: const InputDecoration(
          hintText: 'Search For People On MoveM',
          hintStyle: TextStyle(color: Color(0xFFA0AAB2), fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: Icon(Icons.search, color: Color(0xFF3B82F6)),
        ),
      ),
    );
  }

  Widget _buildActionCards() {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            Icons.qr_code_scanner,
            'Scan QR Code',
            "Scan Your Friend's QR Code",
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionCard(
            Icons.person_add_alt_1,
            'Invite Friends',
            'Invite Friends Via Links',
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF3B82F6), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Color(0xFFA0AAB2), fontSize: 8), overflow: TextOverflow.ellipsis),
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
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: () {
            Get.to(() => FriendsTabScreen(initialIndex: tabIndex));
          },
          child: Row(
            children: [
              const Text('View All', style: TextStyle(color: Color(0xFF3B82F6), fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_ios, color: Color(0xFF3B82F6), size: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequestsList() {
    if (controller.incomingRequests.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF131B2F),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: const Center(child: Text('No friend requests.', style: TextStyle(color: Color(0xFFA0AAB2)))),
      );
    }

    final displayList = controller.incomingRequests.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        children: displayList.asMap().entries.map((entry) {
          final req = entry.value;
          final isLast = entry.key == displayList.length - 1;
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
    );
  }

  Widget _buildSuggestionsList() {
    if (controller.searchResults.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF131B2F),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: const Center(child: Text('No suggestions found.', style: TextStyle(color: Color(0xFFA0AAB2)))),
      );
    }

    final displayList = controller.searchResults.take(4).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        children: displayList.asMap().entries.map((entry) {
          final user = entry.value;
          final isLast = entry.key == displayList.length - 1;
          return Column(
            children: [
              FriendSuggestionTile(
                imageUrl: user.profilePic.isNotEmpty ? user.profilePic : 'https://ui-avatars.com/api/?name=${user.firstname}+${user.lastname}',
                name: '${user.firstname} ${user.lastname}'.trim().isEmpty ? user.username : '${user.firstname} ${user.lastname}',
                username: '@${user.username}',
                friendStatus: user.friendStatus,
                onAdd: () => controller.sendRequest(user.username),
              ),
              if (!isLast) const Divider(color: Color(0xFF1E293B)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildShareProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Share Your Profile', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF131B2F),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: CachedNetworkImageProvider('https://images.unsplash.com/photo-1543852786-1cf6624b9987?q=80&w=200&auto=format&fit=crop'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Your Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    const Text('@ForRiel', style: TextStyle(color: Color(0xFFA0AAB2), fontSize: 12)),
                    const Text('0 Friends', style: TextStyle(color: Color(0xFFA0AAB2), fontSize: 10)),
                  ],
                ),
              ),
              _buildProfileAction(Icons.qr_code, 'QR Code'),
              const SizedBox(width: 16),
              _buildProfileAction(Icons.copy, 'Copy Link'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileAction(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.3)),
          ),
          child: Icon(icon, color: const Color(0xFF3B82F6), size: 20),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 8)),
      ],
    );
  }
}
