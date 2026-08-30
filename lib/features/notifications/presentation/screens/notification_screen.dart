import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/notification_controller.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../data/dto/response/notification_response.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.slate900,
      appBar: AppBar(
        backgroundColor: AppColors.slate900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
          onPressed: () => Get.back(),
        ),
        title: Text(
          l10n?.notifications ?? 'Notifications',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: AppColors.slate800,
            height: 1.0,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.blueAccent));
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Text(
              controller.error.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Text(
              l10n?.noNotifications ?? 'No notifications yet',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: controller.notifications.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return _buildNotificationTile(notification, l10n);
          },
        );
      }),
    );
  }

  Widget _buildNotificationTile(NotificationResponse notification, AppLocalizations? l10n) {
    final senderName = (notification.senderName != null && notification.senderName!.trim().isNotEmpty)
        ? notification.senderName!.trim()
        : (l10n?.appTitle ?? 'MoveM');
    final avatarUrl = (notification.senderProfilePicture != null && notification.senderProfilePicture!.isNotEmpty)
        ? notification.senderProfilePicture!
        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(senderName)}&background=334155&color=fff';

    final notifType = notification.notificationType?.toUpperCase() ?? '';
    final refType = notification.referenceType?.toUpperCase() ?? '';

    IconData typeIcon = Icons.notifications_rounded;
    Color badgeColor = AppColors.blueAccent;

    if (notifType == 'COMMENT_CREATED' || refType == 'COMMENT') {
      typeIcon = Icons.chat_bubble_rounded;
      badgeColor = AppColors.skyBlue;
    } else if (notifType.startsWith('TASK_') || refType == 'TASK') {
      typeIcon = Icons.task_alt_rounded;
      badgeColor = AppColors.blueAccent;
    } else if (notifType == 'FRIEND_REQUEST' || notifType == 'FRIEND_ACCEPTED' || refType == 'USER') {
      typeIcon = Icons.person_add_alt_1_rounded;
      badgeColor = AppColors.emerald;
    } else if (notifType.startsWith('FITNESS_') || notifType.startsWith('WORKOUT_') || refType == 'FITNESS') {
      typeIcon = Icons.directions_run_rounded;
      badgeColor = AppColors.amber;
    } else if (notifType.startsWith('TRIP_') || refType == 'TRIP') {
      typeIcon = Icons.flight_takeoff_rounded;
      badgeColor = AppColors.violet;
    } else if (notifType.startsWith('GROUP_') || notifType == 'MEMBER_INVITED' || refType == 'GROUP') {
      typeIcon = Icons.groups_rounded;
      badgeColor = AppColors.pink;
    } else if (notifType == 'ACHIEVEMENT_UNLOCKED' || refType == 'ACHIEVEMENT') {
      typeIcon = Icons.emoji_events_rounded;
      badgeColor = AppColors.gold;
    }

    return GestureDetector(
      onTap: () => controller.onNotificationTap(notification),
      child: Opacity(
        opacity: notification.isRead ? 0.6 : 1.0,
        child: GlassContainer(
          borderRadius: BorderRadius.circular(12.0),
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipOval(
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: CachedNetworkImage(
                        imageUrl: avatarUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => CircleAvatar(
                          backgroundColor: AppColors.slate700,
                          child: Text(
                            senderName.isNotEmpty ? senderName[0].toUpperCase() : 'U',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          backgroundColor: AppColors.slate700,
                          child: Text(
                            senderName.isNotEmpty ? senderName[0].toUpperCase() : 'U',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: notification.isRead ? AppColors.slate500 : badgeColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.slate900, width: 1.5),
                      ),
                      child: Icon(
                        typeIcon,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title ?? (l10n?.notifications ?? 'Notification'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!notification.isRead) ...[
                          const SizedBox(width: 6),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.blueAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                          height: 1.4,
                        ),
                        children: [
                          if (notification.senderName != null && notification.senderName!.isNotEmpty)
                            TextSpan(
                              text: '${notification.senderName} ',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          TextSpan(
                            text: notification.message ?? '',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.timeAgo(),
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.slate500,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
