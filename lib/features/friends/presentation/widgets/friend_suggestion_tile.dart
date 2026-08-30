import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';

class FriendSuggestionTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String username;
  final VoidCallback onAdd;
  final VoidCallback? onCancel;
  final String? friendStatus;

  const FriendSuggestionTile({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.username,
    required this.onAdd,
    this.onCancel,
    this.friendStatus,
  });

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : 'U';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          ClipOval(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildPlaceholder(initial),
                errorWidget: (context, url, error) => _buildPlaceholder(initial),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  username,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (friendStatus == 'PENDING_REQUEST' || friendStatus == 'PENDING')
            GestureDetector(
              onTap: onCancel,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.slate800.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.slate800),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.close, color: AppColors.redError, size: 14),
                    SizedBox(width: 4),
                    Text('Cancel', style: TextStyle(color: AppColors.redError, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )
          else if (friendStatus == 'ACCEPTED' || friendStatus == 'FRIEND')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.slate800.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.slate800),
              ),
              child: const Text('Friends', style: TextStyle(color: AppColors.emeraldLight, fontSize: 12, fontWeight: FontWeight.bold)),
            )
          else
            GestureDetector(
              onTap: onAdd,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.slate800.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.slate800),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.person_add_alt_1, color: AppColors.blueAccent, size: 14),
                    SizedBox(width: 4),
                    Text('Add Friends', style: TextStyle(color: AppColors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(String initial) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.slate700,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
