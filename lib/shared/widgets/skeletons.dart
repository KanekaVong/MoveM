import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/app_colors.dart';

/// Shimmer placeholders shown while a screen loads its first page of data.
///
/// Pass [dark] on screens that always use a dark palette (trip, activity
/// detail); otherwise the colors follow the app theme.

bool _isDark(bool? dark) => dark ?? AppColors.isDark;

/// Animated shimmer over [child]. Every opaque pixel in [child] shimmers.
class AppShimmer extends StatelessWidget {
  final Widget child;
  final bool? dark;

  const AppShimmer({super.key, required this.child, this.dark});

  @override
  Widget build(BuildContext context) {
    final isDark = _isDark(dark);
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE3E8EF),
      highlightColor: isDark ? const Color(0xFF2E3D56) : const Color(0xFFF6F8FB),
      child: child,
    );
  }
}

/// A plain block to use inside [AppShimmer].
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;
  final bool circle;

  const SkeletonBox({
    super.key,
    this.width,
    this.height = 12,
    this.radius = 8,
    this.circle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: circle ? height : width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(radius),
      ),
    );
  }
}

/// Card background behind skeleton content, matching the app's list cards.
class SkeletonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bool? dark;

  const SkeletonCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.radius = 18,
    this.dark,
  });

  @override
  Widget build(BuildContext context) {
    final Color background;
    final Color border;
    if (dark == null) {
      background = AppColors.cardSurface;
      border = AppColors.borderLight;
    } else {
      background = dark! ? const Color(0xFF0F1B33) : Colors.white;
      border = dark! ? const Color(0x1AFFFFFF) : const Color(0xFFE5E7EB);
    }
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: border,
          width: 1.2,
        ),
      ),
      child: AppShimmer(dark: dark, child: child),
    );
  }
}

/// Text lines of decreasing width.
class SkeletonLines extends StatelessWidget {
  final int lines;
  final double lineHeight;
  final double spacing;

  const SkeletonLines({super.key, this.lines = 2, this.lineHeight = 12, this.spacing = 8});

  @override
  Widget build(BuildContext context) {
    const widths = [0.75, 0.5, 0.62, 0.4];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < lines; i++) ...[
          if (i > 0) SizedBox(height: spacing),
          FractionallySizedBox(
            widthFactor: widths[i % widths.length],
            child: SkeletonBox(height: i == 0 ? lineHeight + 2 : lineHeight),
          ),
        ],
      ],
    );
  }
}

/// Avatar or icon followed by text lines; the common list row.
class SkeletonTile extends StatelessWidget {
  final double avatarSize;
  final bool circleAvatar;
  final int lines;
  final bool trailing;
  final bool card;
  final bool? dark;

  const SkeletonTile({
    super.key,
    this.avatarSize = 44,
    this.circleAvatar = true,
    this.lines = 2,
    this.trailing = false,
    this.card = true,
    this.dark,
  });

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        SkeletonBox(height: avatarSize, width: avatarSize, circle: circleAvatar, radius: 12),
        const SizedBox(width: 14),
        Expanded(child: SkeletonLines(lines: lines)),
        if (trailing) ...[
          const SizedBox(width: 12),
          const SkeletonBox(width: 28, height: 28, circle: true),
        ],
      ],
    );
    return card ? SkeletonCard(dark: dark, child: row) : AppShimmer(dark: dark, child: row);
  }
}

/// Text on one side and a square image on the other (feed, challenge cards).
class SkeletonMediaCard extends StatelessWidget {
  final double mediaSize;
  final bool mediaFirst;
  final int lines;
  final bool? dark;

  const SkeletonMediaCard({
    super.key,
    this.mediaSize = 110,
    this.mediaFirst = false,
    this.lines = 3,
    this.dark,
  });

  @override
  Widget build(BuildContext context) {
    final media = SkeletonBox(width: mediaSize, height: mediaSize, radius: 14);
    final text = Expanded(child: SkeletonLines(lines: lines, spacing: 12));
    return SkeletonCard(
      dark: dark,
      child: Row(
        children: mediaFirst
            ? [media, const SizedBox(width: 16), text]
            : [text, const SizedBox(width: 16), media],
      ),
    );
  }
}

/// A scrollable list of skeleton rows. Scrolls so pull-to-refresh still works.
class SkeletonListView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final bool shrinkWrap;

  const SkeletonListView({
    super.key,
    required this.itemBuilder,
    this.itemCount = 6,
    this.padding = const EdgeInsets.all(16),
    this.spacing = 12,
    this.shrinkWrap = false,
  });

  /// Rows of [SkeletonTile].
  factory SkeletonListView.tiles({
    Key? key,
    int itemCount = 6,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    double avatarSize = 44,
    bool circleAvatar = true,
    int lines = 2,
    bool trailing = false,
    bool shrinkWrap = false,
    bool? dark,
  }) {
    return SkeletonListView(
      key: key,
      itemCount: itemCount,
      padding: padding,
      shrinkWrap: shrinkWrap,
      itemBuilder: (_, __) => SkeletonTile(
        avatarSize: avatarSize,
        circleAvatar: circleAvatar,
        lines: lines,
        trailing: trailing,
        dark: dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemCount: itemCount,
      separatorBuilder: (_, __) => SizedBox(height: spacing),
      itemBuilder: itemBuilder,
    );
  }
}

/// Grid of rounded blocks (badges, tiles).
class SkeletonGrid extends StatelessWidget {
  final int crossAxisCount;
  final int itemCount;
  final double childAspectRatio;
  final EdgeInsetsGeometry padding;
  final bool? dark;

  const SkeletonGrid({
    super.key,
    this.crossAxisCount = 3,
    this.itemCount = 9,
    this.childAspectRatio = 0.85,
    this.padding = const EdgeInsets.all(16),
    this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      dark: dark,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        itemCount: itemCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (_, __) => const SkeletonBox(radius: 16, height: double.infinity),
      ),
    );
  }
}

/// Generic detail page: title, info row, text block and content cards.
class SkeletonDetail extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final bool showHero;
  final bool? dark;

  const SkeletonDetail({
    super.key,
    this.padding = const EdgeInsets.all(20),
    this.showHero = false,
    this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: padding,
      children: [
        AppShimmer(
          dark: dark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showHero) ...[
                const SkeletonBox(height: 200, radius: 20),
                const SizedBox(height: 20),
              ],
              const SkeletonBox(width: 200, height: 26),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(child: SkeletonLines(lines: 2)),
                  SizedBox(width: 24),
                  SkeletonBox(width: 64, height: 14),
                ],
              ),
              const SizedBox(height: 24),
              const SkeletonLines(lines: 3),
              const SizedBox(height: 24),
              const SkeletonBox(height: 180, radius: 20),
              const SizedBox(height: 16),
              const SkeletonBox(height: 80, radius: 16),
            ],
          ),
        ),
      ],
    );
  }
}

/// Chat-style bubbles alternating left and right (comments).
class SkeletonChatList extends StatelessWidget {
  final int itemCount;
  final bool? dark;

  const SkeletonChatList({super.key, this.itemCount = 6, this.dark});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      dark: dark,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (_, i) => Align(
          alignment: i.isEven ? Alignment.centerRight : Alignment.centerLeft,
          child: SkeletonBox(width: 150.0 + (i % 3) * 45, height: 46, radius: 16),
        ),
      ),
    );
  }
}

/// Profile header: avatar, name, stats row and a couple of list rows.
class SkeletonProfile extends StatelessWidget {
  final bool? dark;

  const SkeletonProfile({super.key, this.dark});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        AppShimmer(
          dark: dark,
          child: const Column(
            children: [
              SkeletonBox(height: 96, circle: true),
              SizedBox(height: 16),
              SkeletonBox(width: 160, height: 20),
              SizedBox(height: 8),
              SkeletonBox(width: 100, height: 12),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: SkeletonBox(height: 64, radius: 14)),
                  SizedBox(width: 12),
                  Expanded(child: SkeletonBox(height: 64, radius: 14)),
                  SizedBox(width: 12),
                  Expanded(child: SkeletonBox(height: 64, radius: 14)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SkeletonTile(dark: dark),
        const SizedBox(height: 12),
        SkeletonTile(dark: dark),
      ],
    );
  }
}
