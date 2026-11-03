import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../task/data/dto/response/comment_response.dart';
import '../../domain/models/home_feed_item.dart';
import '../controllers/activity_detail_controller.dart';
import '../widgets/gps_route_painter.dart';
import '../../../../shared/widgets/top_tool_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/utils/Formatters.dart';
import 'package:movem/shared/widgets/skeletons.dart';

class ActivityDetailScreen extends GetView<ActivityDetailController> {
  const ActivityDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Palette.background,
      body: SafeArea(
        child: Column(
          children: [
            TopToolBar(
              title: 'MoveM',
              backgroundColor: _Palette.background,
              foregroundColor: _Palette.text,
            ),
            Expanded(
              child: Obx(() {
                final item = controller.item.value;
                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  children: [
                    _buildUserRow(item),
                    if (item.caption != null && item.caption!.trim().isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Text(
                        '"${item.caption!.trim()}"',
                        style: TextStyle(
                          color: _Palette.muted,
                          fontSize: 14,
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    _buildRouteHero(item),
                    const SizedBox(height: 28),
                    _buildStatsGrid(item),
                    const SizedBox(height: 28),
                    _buildChallengeSection(item),
                    const SizedBox(height: 24),
                    _buildSocialRow(item),
                    const SizedBox(height: 16),
                    if (controller.isLoadingComments.value && controller.comments.isEmpty && item.commentCount > 0)
                      for (var i = 0; i < item.commentCount.clamp(1, 3); i++) ...[
                        const SkeletonTile(avatarSize: 36),
                        const SizedBox(height: 10),
                      ],
                    ...controller.comments.map(_buildCommentBubble),
                  ],
                );
              }),
            ),
            _buildCommentBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserRow(HomeFeedItem item) {
    return Row(
      children: [
        _buildAvatar(item.userAvatar, item.userName, size: 42, radius: 8),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            item.displayName,
            style: TextStyle(
              color: _Palette.text,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRouteHero(HomeFeedItem item) {
    final distance = item.distanceKm;
    final distanceLabel = distance != null && distance > 0
        ? Formatters.distanceKm(distance)
        : _workoutLabel(item);

    return SizedBox(
      height: 250,
      child: item.hasGpsRoute && (item.imageUrl == null || item.imageUrl!.isEmpty)
          ? CustomPaint(
              painter: GpsRoutePainter(
                routePoints: item.routePoints,
                colorfulDots: true,
                strokeWidth: 3.2,
                lineColor: _Palette.gold,
              ),
              child: Center(
                child: Text(
                  distanceLabel,
                  style: TextStyle(
                    color: _Palette.text,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                  ? CachedNetworkImage(imageUrl: AppConfig.resolveMediaUrl(item.imageUrl!), fit: BoxFit.cover)
                  : Image.asset(item.fallbackImage, fit: BoxFit.cover),
            ),
    );
  }

  Widget _buildStatsGrid(HomeFeedItem item) {
    final durationMins = item.durationSeconds > 0
        ? (item.durationSeconds / 60).round()
        : 0;
    return Column(
      children: [
        Row(
          children: [
            _statCell('STEPS', item.stepsCount > 0 ? '${item.stepsCount}' : '--'),
            _statCell(
              'DURATIONS',
              durationMins > 0 ? '$durationMins MINS' : (item.duration ?? '--'),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            _statCell(
              'CALORIES',
              item.caloriesCount > 0 ? '${item.caloriesCount}' : '--',
              valueColor: _Palette.calories,
              trailing: item.caloriesCount > 0
                  ? const Text(' 🔥', style: TextStyle(fontSize: 16))
                  : null,
            ),
            _statCell('AVG PACE', item.averagePace ?? '--'),
          ],
        ),
      ],
    );
  }

  Widget _statCell(
    String label,
    String value, {
    Color? valueColor,
    Widget? trailing,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: _Palette.muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: valueColor ?? _Palette.text,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeSection(HomeFeedItem item) {
    final name = (item.challengeName ?? item.title).toUpperCase();
    return Column(
      children: [
        Text(
          'CHALLENGE',
          style: TextStyle(
            color: _Palette.muted,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.4,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _Palette.text,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'COMPLETED 🔥',
          style: TextStyle(
            color: _Palette.gold,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialRow(HomeFeedItem item) {
    return Row(
      children: [
        GestureDetector(
          onTap: controller.toggleKudos,
          child: Row(
            children: [
              Icon(
                item.myKudos ? Icons.favorite : Icons.favorite_border,
                size: 20,
                color: _Palette.accent,
              ),
              const SizedBox(width: 6),
              Text(
                '${_formatCount(item.kudosCount)} Likes',
                style: TextStyle(
                  color: _Palette.accent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 18),
        Icon(Icons.chat_bubble_outline_rounded, size: 18, color: _Palette.accent),
        const SizedBox(width: 6),
        Text(
          '${_formatCount(item.commentCount)} Comments',
          style: TextStyle(
            color: _Palette.accent,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCommentBubble(CommentResponse comment) {
    final initial = comment.displayName.isNotEmpty ? comment.displayName[0].toUpperCase() : 'U';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(comment.profilePic, comment.displayName, size: 36, radius: 18, initial: initial),
          const SizedBox(width: 10),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: _Palette.bubble,
                borderRadius: BorderRadius.circular(16),
                border: _Palette.isDark ? null : Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.displayName,
                    style: TextStyle(
                      color: _Palette.text,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    comment.content,
                    style: TextStyle(
                      color: _Palette.bubbleText,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: _Palette.input,
                borderRadius: BorderRadius.circular(24),
                border: _Palette.isDark ? null : Border.all(color: AppColors.borderLight),
              ),
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: controller.textController,
                focusNode: controller.inputFocusNode,
                style: TextStyle(color: _Palette.text, fontSize: 14),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => controller.sendComment(),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(Get.context!)?.writeAComment ?? 'Write a Comment',
                  hintStyle: TextStyle(color: _Palette.hint, fontSize: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: controller.sendComment,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: _Palette.accent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(
    String? pic,
    String name, {
    required double size,
    required double radius,
    String? initial,
  }) {
    final letter = initial ?? (name.isNotEmpty ? name[0].toUpperCase() : 'M');
    final resolved = pic != null && pic.isNotEmpty ? AppConfig.resolveMediaUrl(pic) : null;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _Palette.avatar,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: resolved != null && resolved.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: resolved,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => _initialBox(letter),
            )
          : _initialBox(letter),
    );
  }

  Widget _initialBox(String letter) {
    return Container(
      color: const Color(0x2E5B8CFF),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(color: AppColors.accentBlue, fontWeight: FontWeight.w800),
      ),
    );
  }

  String _workoutLabel(HomeFeedItem item) {
    if (item.workoutType.contains('PUSH')) return 'PUSH';
    if (item.workoutType.contains('SQUAT')) return 'SQUAT';
    return 'WORKOUT';
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      final value = count / 1000000;
      return value % 1 == 0 ? '${value.toInt()}M' : '${value.toStringAsFixed(1)}M';
    }
    if (count >= 1000) {
      final value = count / 1000;
      return value % 1 == 0 ? '${value.toInt()}K' : '${value.toStringAsFixed(1)}K';
    }
    return '$count';
  }
}

/// Colors for this screen. Dark keeps the original navy look; light uses the
/// app's light tokens with darker accents so they stay readable on white.
class _Palette {
  _Palette._();

  static bool get isDark => AppColors.isDark;

  static Color get background => isDark ? const Color(0xFF070F20) : AppColors.pageBackground;
  static Color get text => isDark ? Colors.white : AppColors.textPrimary;
  static Color get muted => isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary;
  static Color get hint => isDark ? const Color(0xFF64748B) : AppColors.textCaption;
  static Color get bubble => isDark ? const Color(0xFF2A3447) : AppColors.cardSurface;
  static Color get bubbleText => isDark ? const Color(0xFFCBD5E1) : const Color(0xFF374151);
  static Color get input => isDark ? const Color(0xFF1E293B) : AppColors.cardSurface;
  static Color get avatar => isDark ? const Color(0xFF1E293B) : AppColors.chipSurface;
  static Color get accent => isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7);
  static Color get gold => isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706);
  static Color get calories => isDark ? const Color(0xFFF97316) : const Color(0xFFEA580C);
}
