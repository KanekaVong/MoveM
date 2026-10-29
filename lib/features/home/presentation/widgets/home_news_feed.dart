import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/home_feed_item.dart';
import '../controllers/home_controller.dart';
import '../controllers/activity_detail_controller.dart';
import '../screens/activity_detail_screen.dart';
import 'gps_route_painter.dart';
import '../../../../shared/widgets/no_data_component.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/utils/Formatters.dart';

/// Feed section of the home scroll view, as slivers: the "News Feed" label
/// stays pinned at the top while the cards scroll under it.
class HomeNewsFeed extends GetView<HomeController> {
  const HomeNewsFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SliverMainAxisGroup(
      slivers: [
        PinnedHeaderSliver(
          child: Container(
            color: AppColors.pageBackground,
            padding: const EdgeInsets.only(top: 4, bottom: 14),
            child: Text(
              l10n?.newsFeed ?? 'News Feed',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ),
        Obx(() {
          final items = controller.feedItems;
          if (items.isEmpty) {
            if (controller.isFeedLoading.value) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 48),
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            }
            return SliverToBoxAdapter(
              child: NoDataComponent(
                compact: true,
                title: l10n?.noActivityYet ?? 'No activity yet',
                subtitle: l10n?.feedEmptySub ??
                    'Workouts and updates from your circle will show up here.',
              ),
            );
          }

          return SliverPadding(
            padding: const EdgeInsets.only(bottom: 120),
            sliver: SliverList.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) => _buildFeedCard(items[index]),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFeedCard(HomeFeedItem item) {
    return GestureDetector(
      onTap: () => _openActivityDetail(item),
      child: Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: AppColors.isDark ? 0.25 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildUserAvatar(item),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.displayName,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      item.title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (item.caption != null && item.caption!.isNotEmpty) ...[
                      SizedBox(height: 3),
                      Text(
                        item.caption!,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    SizedBox(height: 12),
                    _buildPrimaryStats(item),
                    if (item.steps != null) ...[
                      SizedBox(height: 8),
                      _buildStatRow(
                        icon: SizedBox(
                          width: 17,
                          height: 17,
                          child: CustomPaint(
                            painter: SneakerIconPainter(color: AppColors.textPrimary),
                          ),
                        ),
                        text: item.steps!,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildRightMedia(item),
            ],
          ),
        ],
      ),
    ),
    );
  }

  void _openActivityDetail(HomeFeedItem item) {
    if (Get.isRegistered<ActivityDetailController>()) {
      Get.delete<ActivityDetailController>(force: true);
    }
    Get.to(
      () => const ActivityDetailScreen(),
      binding: BindingsBuilder(() {
        Get.put(ActivityDetailController(initialItem: item));
      }),
    );
  }

  Widget _buildPrimaryStats(HomeFeedItem item) {
    final stats = <Widget>[];
    if (item.duration != null) {
      stats.add(
        _buildStatRow(
          icon: Icon(Icons.timer_outlined, color: AppColors.textPrimary, size: 16),
          text: item.duration!,
        ),
      );
    }
    if (item.calories != null) {
      stats.add(
        _buildStatRow(
          icon: const Icon(Icons.local_fire_department_rounded, color: Color(0xFFFF6A3D), size: 16),
          text: item.calories!,
        ),
      );
    }
    if (stats.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: stats,
    );
  }

  Widget _buildRightMedia(HomeFeedItem item) {
    final hasImage = item.imageUrl != null && item.imageUrl!.isNotEmpty;
    if (item.hasGpsRoute && !hasImage) {
      final distance = item.distanceKm;
      final distanceLabel = distance != null && distance > 0
          ? Formatters.distanceKm(distance)
          : 'RUN';

      return Container(
        width: 128,
        height: 128,
        decoration: BoxDecoration(
          color: AppColors.isDark ? AppColors.chipSurface : const Color(0xFFE6EBF3),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
        child: Column(
          children: [
            Expanded(
              child: CustomPaint(
                size: Size.infinite,
                painter: GpsRoutePainter(routePoints: item.routePoints),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              distanceLabel,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: 128,
      height: 128,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: hasImage
            ? CachedNetworkImage(
                imageUrl: AppConfig.resolveMediaUrl(item.imageUrl!),
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Image.asset(item.fallbackImage, fit: BoxFit.cover),
              )
            : Image.asset(item.fallbackImage, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildStatRow({required Widget icon, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildUserAvatar(HomeFeedItem item) {
    final initial = item.userName.isNotEmpty ? item.userName[0].toUpperCase() : 'M';
    final avatar = item.userAvatar;
    final pic = avatar != null && avatar.isNotEmpty ? AppConfig.resolveMediaUrl(avatar) : null;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.chipSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: pic != null
          ? CachedNetworkImage(
              imageUrl: pic,
              fit: BoxFit.cover,
              placeholder: (_, __) => _buildAvatarInitial(initial),
              errorWidget: (_, __, ___) => _buildAvatarInitial(initial),
            )
          : _buildAvatarInitial(initial),
    );
  }

  Widget _buildAvatarInitial(String initial) {
    return Container(
      color: AppColors.isDark ? AppColors.accentBlue.withValues(alpha: 0.18) : const Color(0xFF1E293B),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: AppColors.isDark ? AppColors.accentBlue : Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class SneakerIconPainter extends CustomPainter {
  final Color color;
  const SneakerIconPainter({this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final path = Path()
      ..moveTo(w * 0.10, h * 0.58)
      ..lineTo(w * 0.08, h * 0.82)
      ..lineTo(w * 0.90, h * 0.82)
      ..cubicTo(w * 0.98, h * 0.82, w * 0.98, h * 0.64, w * 0.82, h * 0.60)
      ..lineTo(w * 0.55, h * 0.52)
      ..lineTo(w * 0.38, h * 0.36)
      ..lineTo(w * 0.22, h * 0.38)
      ..lineTo(w * 0.12, h * 0.50)
      ..close();

    canvas.drawPath(path, paint);

    canvas.drawLine(Offset(w * 0.08, h * 0.74), Offset(w * 0.92, h * 0.74), paint);
    canvas.drawLine(Offset(w * 0.44, h * 0.46), Offset(w * 0.54, h * 0.52), paint);
    canvas.drawLine(Offset(w * 0.36, h * 0.52), Offset(w * 0.46, h * 0.58), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
