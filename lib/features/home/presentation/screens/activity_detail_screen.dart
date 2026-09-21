import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/utils/app_images.dart';
import '../../../task/data/dto/response/comment_response.dart';
import '../../domain/models/home_feed_item.dart';
import '../controllers/activity_detail_controller.dart';
import '../widgets/gps_route_painter.dart';

class ActivityDetailScreen extends GetView<ActivityDetailController> {
  const ActivityDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070F20),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
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
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
          ),
          const Expanded(
            child: Text(
              'MOVEM',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 3.2,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
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
            item.userName,
            style: const TextStyle(
              color: Colors.white,
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
        ? (distance >= 1 ? '${distance.round()}KM' : '${distance.toStringAsFixed(1)}KM')
        : _workoutLabel(item);

    return SizedBox(
      height: 250,
      child: item.hasGpsRoute
          ? CustomPaint(
              painter: const GpsRoutePainter(colorfulDots: true, strokeWidth: 3.2),
              child: Center(
                child: Text(
                  distanceLabel,
                  style: const TextStyle(
                    color: Colors.white,
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
                  ? (item.imageUrl!.startsWith('http')
                      ? CachedNetworkImage(imageUrl: item.imageUrl!, fit: BoxFit.cover)
                      : Image.file(File(item.imageUrl!), fit: BoxFit.cover))
                  : Image.asset(AppImages.taskScreenBackground, fit: BoxFit.cover),
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
              valueColor: const Color(0xFFF97316),
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
    Color valueColor = Colors.white,
    Widget? trailing,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
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
                  color: valueColor,
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
        const Text(
          'CHALLENGE',
          style: TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.4,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'COMPLETED 🔥',
          style: TextStyle(
            color: Color(0xFFFBBF24),
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
                color: const Color(0xFF38BDF8),
              ),
              const SizedBox(width: 6),
              Text(
                '${_formatCount(item.kudosCount)} Likes',
                style: const TextStyle(
                  color: Color(0xFF38BDF8),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 18),
        const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Color(0xFF38BDF8)),
        const SizedBox(width: 6),
        Text(
          '${_formatCount(item.commentCount)} Comments',
          style: const TextStyle(
            color: Color(0xFF38BDF8),
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
                color: const Color(0xFF2A3447),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    comment.content,
                    style: const TextStyle(
                      color: Color(0xFFCBD5E1),
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
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(24),
              ),
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: controller.textController,
                focusNode: controller.inputFocusNode,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => controller.sendComment(),
                decoration: const InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'Write a Comment',
                  hintStyle: TextStyle(color: Color(0xFF64748B), fontSize: 14),
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
              decoration: const BoxDecoration(
                color: Color(0xFF38BDF8),
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
    var resolved = pic;
    if (resolved != null && resolved.isNotEmpty && !resolved.startsWith('http') && !resolved.startsWith('/')) {
      resolved = resolved;
    } else if (resolved != null && resolved.isNotEmpty && !resolved.startsWith('http')) {
      final base = AppConfig.baseUrl.endsWith('/')
          ? AppConfig.baseUrl.substring(0, AppConfig.baseUrl.length - 1)
          : AppConfig.baseUrl;
      resolved = resolved.startsWith('/') ? '$base$resolved' : '$base/$resolved';
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(radius),
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
      color: const Color(0xFF334155),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
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
