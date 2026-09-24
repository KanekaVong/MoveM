import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';

class TopToolBarAction {
  final IconData icon;
  final VoidCallback onTap;
  final double iconSize;

  const TopToolBarAction({
    required this.icon,
    required this.onTap,
    this.iconSize = 20,
  });
}

/// MOVEM Club-style header: circle back, centered title, matching circle actions.
class TopToolBar extends StatelessWidget implements PreferredSizeWidget {
  static const double barHeight = 58;
  static const double buttonSize = 38;

  final String title;
  final VoidCallback? onBack;
  final bool showBack;
  final List<TopToolBarAction> actions;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const TopToolBar({
    super.key,
    required this.title,
    this.onBack,
    this.showBack = true,
    this.actions = const [],
    this.bottom,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(barHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final fg = foregroundColor ?? AppColors.textPrimary;
    final rightCount = actions.isEmpty ? 1 : actions.length;
    final trailing = actions.isEmpty
        ? const SizedBox(width: buttonSize, height: buttonSize)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < actions.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                _circleButton(
                  icon: actions[i].icon,
                  iconSize: actions[i].iconSize,
                  onTap: actions[i].onTap,
                  color: fg,
                ),
              ],
            ],
          );

    final bar = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: buttonSize * rightCount + (rightCount > 1 ? 8.0 * (rightCount - 1) : 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: showBack
                  ? _circleButton(
                      icon: Icons.chevron_left_rounded,
                      iconSize: 26,
                      onTap: onBack ?? () => Get.back(),
                      color: fg,
                    )
                  : const SizedBox(width: buttonSize, height: buttonSize),
            ),
          ),
          Expanded(
            child: Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: fg,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.6,
              ),
            ),
          ),
          SizedBox(
            width: buttonSize * rightCount + (rightCount > 1 ? 8.0 * (rightCount - 1) : 0),
            child: Align(
              alignment: Alignment.centerRight,
              child: trailing,
            ),
          ),
        ],
      ),
    );

    final colored = ColoredBox(
      color: backgroundColor ?? AppColors.pageBackground,
      child: bar,
    );

    if (bottom == null) return colored;

    return ColoredBox(
      color: backgroundColor ?? AppColors.pageBackground,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          bar,
          bottom!,
        ],
      ),
    );
  }

  static Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
    double iconSize = 20,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.12),
          border: Border.all(
            color: color.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Icon(icon, color: color, size: iconSize),
      ),
    );
  }
}
