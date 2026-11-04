import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import 'auth_image.dart';

/// Round user avatar: the profile picture when there is one, otherwise the
/// first letter of [name] on a colour picked from [seed] so the same user
/// always gets the same colour.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.seed = 0,
    this.radius = 22,
    this.ringColor,
  });

  final String name;
  final String? imageUrl;
  final int seed;
  final double radius;

  /// Draws a ring around the avatar, e.g. to mark the club owner.
  final Color? ringColor;

  static const _palette = [
    AppColors.blueAccent,
    AppColors.emerald,
    AppColors.violet,
    AppColors.pink,
    AppColors.skyBlueDark,
    AppColors.amber,
  ];

  @override
  Widget build(BuildContext context) {
    final color = _palette[seed.abs() % _palette.length];
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';
    final fallback = Container(
      color: color.withValues(alpha: AppColors.isDark ? 0.28 : 0.16),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          color: AppColors.isDark ? Colors.white : color,
          fontSize: radius * 0.8,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    final url = imageUrl?.trim() ?? '';
    final avatar = ClipOval(
      child: SizedBox.square(
        dimension: radius * 2,
        child: url.isEmpty
            ? fallback
            : AuthImage(url: AppConfig.resolveMediaUrl(url), fallback: fallback),
      ),
    );

    if (ringColor == null) return avatar;
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ringColor!, width: 2),
      ),
      child: avatar,
    );
  }
}
