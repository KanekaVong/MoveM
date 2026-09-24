import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';

class FriendSuggestionTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String username;
  final VoidCallback onAdd;
  final VoidCallback? onCancel;
  final VoidCallback? onUnfriend;
  final String? friendStatus;

  const FriendSuggestionTile({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.username,
    required this.onAdd,
    this.onCancel,
    this.onUnfriend,
    this.friendStatus,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  username,
                  style: TextStyle(color: AppColors.textMuted, fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (friendStatus == 'PENDING_REQUEST' || friendStatus == 'PENDING')
            AppButton.secondary(
              label: l10n?.cancel ?? 'Cancel',
              icon: Icons.close,
              onPressed: onCancel,
              width: null,
              height: 34,
            )
          else if (friendStatus == 'ACCEPTED' || friendStatus == 'FRIEND')
            onUnfriend != null
                ? AppButton.danger(
                    label: l10n?.unfriend ?? 'Unfriend',
                    icon: Icons.person_remove_alt_1,
                    onPressed: onUnfriend,
                    width: null,
                    height: 34,
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.chipSurface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.borderMuted),
                    ),
                    child: Text(l10n?.friends ?? 'Friends', style: TextStyle(color: AppColors.emeraldLight, fontSize: 12, fontWeight: FontWeight.bold)),
                  )
          else
            AppButton(
              label: l10n?.addFriends ?? 'Add Friends',
              icon: Icons.person_add_alt_1,
              onPressed: onAdd,
              width: null,
              height: 34,
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(String initial) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.chipSurface,
      child: Text(
        initial,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
