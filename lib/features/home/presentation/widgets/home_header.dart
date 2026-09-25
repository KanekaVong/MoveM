import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/home_controller.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/auth_image.dart';

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
                style: TextStyle(
                  color: AppColors.textCaption,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 2),
              Obx(() => Text(
                    controller.greetingName,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )),
              SizedBox(height: 3),
              Text(
                l10n?.stayActiveToday ?? 'Stay Active Today!',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        SizedBox(width: 8),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.notifications_none_outlined, color: AppColors.textPrimary, size: 24),
              onPressed: controller.onNotificationTap,
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
            ),
            SizedBox(width: 2),
            IconButton(
              icon: Icon(Icons.person_add_outlined, color: AppColors.textPrimary, size: 24),
              onPressed: controller.onAddFriendsTap,
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: controller.onProfileTap,
              child: Obx(() {
                final stored = controller.profilePicUrl;
                final pic = stored != null &&
                        stored.isNotEmpty &&
                        !stored.startsWith('http') &&
                        !stored.startsWith('/')
                    ? AppConfig.resolveMediaUrl(stored)
                    : stored;
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
                          ? AuthImage(
                              url: pic,
                              fallback: _buildInitialAvatar(initial),
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
