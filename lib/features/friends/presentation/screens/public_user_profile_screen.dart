import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/dto/response/friend_response.dart';
import '../../data/dto/response/public_user_profile_response.dart';
import '../controllers/public_user_profile_controller.dart';

class PublicUserProfileScreen extends GetView<PublicUserProfileController> {
  const PublicUserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppColors.pageBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          final user = controller.profile.value;
          if (user == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.blueAccent),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: Column(
                    children: [
                      _buildProfileCard(user),
                      const SizedBox(height: 14),
                      _buildAchievementsCard(user),
                      const SizedBox(height: 14),
                      _buildMutualFriendsCard(user),
                    ],
                  ),
                ),
              ),
              if (!controller.isOwnProfile) _buildActionButton(user),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildProfileCard(PublicUserProfileResponse user) {
    final initial = user.displayName.isNotEmpty ? user.displayName[0].toUpperCase() : 'U';
    final bio = (user.bio ?? '').trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.blueAccent, width: 3),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: ClipOval(
                child: (user.profilePic != null && user.profilePic!.isNotEmpty)
                    ? CachedNetworkImage(
                        imageUrl: user.profilePic!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => _avatarPlaceholder(initial),
                        errorWidget: (_, __, ___) => _avatarPlaceholder(initial),
                      )
                    : _avatarPlaceholder(initial),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.displayName,
            style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '@${user.username}',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
          ),
          if (bio.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.chipSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                bio,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          const SizedBox(height: 22),
          Row(
            children: [
              _buildStatColumn(
                icon: Icons.check_circle,
                iconColor: const Color(0xFF22D3EE),
                value: '${user.taskCompleted}',
                label: 'Task Completed',
              ),
              _buildStatDivider(),
              _buildStatColumn(
                icon: Icons.directions_run,
                iconColor: const Color(0xFFF97316),
                value: '${user.challengesCompleted}',
                label: 'Challenges Completed',
              ),
              _buildStatDivider(),
              _buildStatColumn(
                icon: Icons.flight,
                iconColor: const Color(0xFFA78BFA),
                value: '${user.tripPlans}',
                label: 'Trip Plans',
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Icon(Icons.people_alt_outlined, color: AppColors.textPrimary, size: 20),
              const SizedBox(width: 8),
              Text(
                '${user.friendsCount}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Friends',
                style: TextStyle(
                  color: AppColors.blueAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, color: AppColors.textCaption, size: 22),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 26),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 56,
      color: AppColors.borderLight,
    );
  }

  Widget _buildAchievementsCard(PublicUserProfileResponse user) {
    return _sectionCard(
      title: const Text.rich(
        TextSpan(
          text: 'Recent ',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700),
          children: [
            TextSpan(
              text: 'Achievements',
              style: TextStyle(color: Color(0xFFEAB308)),
            ),
          ],
        ),
      ),
      child: user.recentAchievements.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Text(
                  'No Achievements Yet',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              ),
            )
          : SizedBox(
              height: 72,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: user.recentAchievements.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = user.recentAchievements[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.emoji_events, color: Color(0xFFEAB308), size: 28),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 72,
                        child: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 11),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }

  Widget _buildMutualFriendsCard(PublicUserProfileResponse user) {
    return _sectionCard(
      title: const Text.rich(
        TextSpan(
          text: 'Mutual ',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700),
          children: [
            TextSpan(
              text: 'Friends',
              style: TextStyle(color: AppColors.blueAccent),
            ),
          ],
        ),
      ),
      child: user.mutualFriends.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Text(
                  'No Mutuals',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              ),
            )
          : SizedBox(
              height: 56,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: user.mutualFriends.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  return _mutualAvatar(user.mutualFriends[index]);
                },
              ),
            ),
    );
  }

  Widget _mutualAvatar(FriendResponse friend) {
    final name = '${friend.firstname} ${friend.lastname}'.trim().isNotEmpty
        ? '${friend.firstname} ${friend.lastname}'.trim()
        : friend.username;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    return ClipOval(
      child: SizedBox(
        width: 44,
        height: 44,
        child: friend.profilePic.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: friend.profilePic,
                fit: BoxFit.cover,
                placeholder: (_, __) => _avatarPlaceholder(initial),
                errorWidget: (_, __, ___) => _avatarPlaceholder(initial),
              )
            : _avatarPlaceholder(initial),
      ),
    );
  }

  Widget _sectionCard({required Widget title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          child,
        ],
      ),
    );
  }

  Widget _buildActionButton(PublicUserProfileResponse user) {
    final isPending = user.isRequestPending;
    final isFriend = user.isFriend;
    final label = isFriend ? 'Friends' : (isPending ? 'Request Sent' : 'Add Friend');
    final enabled = !isPending && !isFriend;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: enabled ? controller.sendFriendRequest : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: enabled ? AppColors.accentBlue : AppColors.chipSurface,
            disabledBackgroundColor: AppColors.chipSurface,
            disabledForegroundColor: AppColors.textSecondary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _avatarPlaceholder(String initial) {
    return Container(
      color: AppColors.chipSurface,
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(color: AppColors.accentBlue, fontSize: 36, fontWeight: FontWeight.bold),
      ),
    );
  }
}
