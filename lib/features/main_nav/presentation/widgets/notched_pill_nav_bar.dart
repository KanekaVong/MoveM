import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class NotchedPillNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<IconData> icons;

  const NotchedPillNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.icons,
  });

  static const double barHeight = 56;
  static const double chipRadius = 26;
  static const double notchExtra = 9;

  static double get totalHeight => chipRadius + barHeight;

  @override
  State<NotchedPillNavBar> createState() => _NotchedPillNavBarState();
}

class _NotchedPillNavBarState extends State<NotchedPillNavBar>
    with SingleTickerProviderStateMixin {
  static const _chipCenterY = NotchedPillNavBar.chipRadius;
  static const _barCenterY =
      NotchedPillNavBar.chipRadius + NotchedPillNavBar.barHeight / 2;

  late final AnimationController _controller;
  late final Animation<double> _t;
  int _fromIndex = 0;
  int _toIndex = 0;

  @override
  void initState() {
    super.initState();
    _fromIndex = widget.currentIndex;
    _toIndex = widget.currentIndex;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _t = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.value = 1;
  }

  @override
  void didUpdateWidget(NotchedPillNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _fromIndex = oldWidget.currentIndex;
      _toIndex = widget.currentIndex;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  double _iconY(int index, double t) {
    if (index == _toIndex) {
      return _lerp(_barCenterY, _chipCenterY, t);
    }
    if (index == _fromIndex && _fromIndex != _toIndex) {
      return _lerp(_chipCenterY, _barCenterY, t);
    }
    return _barCenterY;
  }

  @override
  Widget build(BuildContext context) {
    final barColor = AppColors.isDark ? const Color(0xFF1B2438) : const Color(0xFFE5E8ED);
    final chipColor = AppColors.isDark ? const Color(0xFF2A354C) : const Color(0xFFEEF0F4);
    final iconColor = AppColors.textPrimary;

    return SizedBox(
      height: NotchedPillNavBar.totalHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final itemWidth = width / widget.icons.length;

          return AnimatedBuilder(
            animation: _t,
            builder: (context, _) {
              final t = _t.value;
              final animatedIndex = _lerp(_fromIndex.toDouble(), _toIndex.toDouble(), t);

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: Size(width, NotchedPillNavBar.totalHeight),
                    painter: _NotchedPillPainter(
                      animatedIndex: animatedIndex,
                      itemCount: widget.icons.length,
                      barColor: barColor,
                      chipColor: chipColor,
                      chipRadius: NotchedPillNavBar.chipRadius,
                      notchExtra: NotchedPillNavBar.notchExtra,
                      barHeight: NotchedPillNavBar.barHeight,
                      chipCenterY: _chipCenterY,
                    ),
                  ),
                  for (int index = 0; index < widget.icons.length; index++)
                    _NavIconButton(
                      icon: widget.icons[index],
                      selected: index == _toIndex,
                      center: Offset(
                        itemWidth * index + itemWidth / 2,
                        _iconY(index, t),
                      ),
                      hitSize: index == _toIndex
                          ? NotchedPillNavBar.chipRadius * 2
                          : 48,
                      iconColor: iconColor,
                      onTap: () => widget.onTap(index),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _NavIconButton extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final Offset center;
  final double hitSize;
  final Color iconColor;
  final VoidCallback onTap;

  const _NavIconButton({
    required this.icon,
    required this.selected,
    required this.center,
    required this.hitSize,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: center.dx - hitSize / 2,
      top: center.dy - hitSize / 2,
      width: hitSize,
      height: hitSize,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: Icon(
            icon,
            size: selected ? 24 : 26,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}

class _NotchedPillPainter extends CustomPainter {
  final double animatedIndex;
  final int itemCount;
  final Color barColor;
  final Color chipColor;
  final double chipRadius;
  final double notchExtra;
  final double barHeight;
  final double chipCenterY;

  _NotchedPillPainter({
    required this.animatedIndex,
    required this.itemCount,
    required this.barColor,
    required this.chipColor,
    required this.chipRadius,
    required this.notchExtra,
    required this.barHeight,
    required this.chipCenterY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final itemWidth = size.width / itemCount;
    final chipCenter = Offset(
      itemWidth * animatedIndex + itemWidth / 2,
      chipCenterY,
    );
    final barRect = RRect.fromLTRBR(
      0,
      chipCenterY,
      size.width,
      chipCenterY + barHeight,
      Radius.circular(barHeight / 2),
    );

    final barPath = Path()..addRRect(barRect);
    final notchPath = Path()
      ..addOval(Rect.fromCircle(
        center: chipCenter,
        radius: chipRadius + notchExtra,
      ));
    final notchedBar = Path.combine(PathOperation.difference, barPath, notchPath);

    canvas.drawShadow(notchedBar, Colors.black.withValues(alpha: 0.16), 10, false);
    canvas.drawPath(notchedBar, Paint()..color = barColor);
    canvas.drawCircle(chipCenter, chipRadius, Paint()..color = chipColor);
  }

  @override
  bool shouldRepaint(covariant _NotchedPillPainter oldDelegate) {
    return oldDelegate.animatedIndex != animatedIndex ||
        oldDelegate.itemCount != itemCount ||
        oldDelegate.barColor != barColor ||
        oldDelegate.chipColor != chipColor;
  }
}
