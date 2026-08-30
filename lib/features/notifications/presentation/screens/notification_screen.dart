import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
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
            color: const Color(0xFF1E293B),
            height: 1.0,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF3B82F6)));
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
            return _buildNotificationTile(notification);
          },
        );
      }),
    );
  }

  Widget _buildNotificationTile(NotificationResponse notification) {

    final senderName = (notification.senderName != null && notification.senderName!.trim().isNotEmpty)
        ? notification.senderName!.trim()
        : 'User';
    final avatarUrl = (notification.senderProfilePicture != null && notification.senderProfilePicture!.isNotEmpty)
        ? notification.senderProfilePicture!
        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(senderName)}&background=334155&color=fff';

    return GestureDetector(
      onTap: () {
        controller.markAsRead(notification.id);
      },
      child: Opacity(
        opacity: notification.isRead ? 0.5 : 1.0,
        child: GlassContainer(
          borderRadius: BorderRadius.circular(8.0),
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipOval(
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: CachedNetworkImage(
                        imageUrl: avatarUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => CircleAvatar(
                          backgroundColor: const Color(0xFF334155),
                          child: Text(
                            senderName[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          backgroundColor: const Color(0xFF334155),
                          child: Text(
                            senderName[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: notification.isRead ? Colors.grey : const Color(0xFF3B82F6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
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
                    Text(
                      notification.title ?? 'Notification',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Color(0xFFA0AAB2),
                          fontSize: 12,
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(
                            text: notification.senderName ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: ' ${notification.message ?? ''}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.timeAgo(),
                      style: const TextStyle(
                        color: Color(0xFFA0AAB2),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
