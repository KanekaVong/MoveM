import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/home_controller.dart';

class HomeHeader extends GetView<HomeController> {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n?.greetings ?? 'Greetings',
                style: const TextStyle(
                  color: Color(0xFF8A94A6),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 2),
              Obx(() => Text(
                    controller.greetingName,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )),
              const SizedBox(height: 3),
              Text(
                controller.recentActivityMessage,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined, color: Color(0xFF111827), size: 24),
              onPressed: controller.onNotificationTap,
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
            ),
            const SizedBox(width: 2),
            IconButton(
              icon: const Icon(Icons.person_add_outlined, color: Color(0xFF111827), size: 24),
              onPressed: controller.onAddFriendsTap,
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: controller.onProfileTap,
              child: Obx(() {
                final pic = controller.profilePicUrl;
                final initial = controller.userInitial;

                return Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: const Color(0xFFE5E7EB),
                    border: Border.all(color: const Color(0xFFD1D5DB), width: 1.5),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: pic != null && pic.isNotEmpty
                      ? (pic.startsWith('http')
                          ? CachedNetworkImage(
                              imageUrl: pic,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => _buildInitialAvatar(initial),
                            )
                          : Image.file(
                              File(pic),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _buildInitialAvatar(initial),
                            ))
                      : _buildInitialAvatar(initial),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInitialAvatar(String initial) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
