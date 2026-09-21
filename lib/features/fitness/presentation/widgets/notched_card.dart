import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class NotchedCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onActionTap;
  final IconData actionIcon;
  final Color actionIconColor;
  final Color actionButtonBg;
  final Color actionButtonBorderColor;
  final double actionButtonSize;
  final Color backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double cornerRadius;
  final double notchSize;

  const NotchedCard({
    super.key,
    required this.child,
    this.onTap,
    this.onActionTap,
    this.actionIcon = Icons.play_arrow_rounded,
    this.actionIconColor = Colors.white,
    this.actionButtonBg = AppColors.accentBlue,
    this.actionButtonBorderColor = const Color(0xFF38BDF8),
    this.actionButtonSize = 36.0,
    this.backgroundColor = AppColors.cardSurface,
    this.borderColor,
    this.borderWidth = 1.0,
    this.cornerRadius = 20.0,
    this.notchSize = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: CustomPaint(
            painter: _NotchedCardPainter(
              backgroundColor: backgroundColor,
              borderColor: borderColor,
              borderWidth: borderWidth,
              cornerRadius: cornerRadius,
              notchSize: notchSize,
            ),
            child: ClipPath(
              clipper: _NotchedCardClipper(
                cornerRadius: cornerRadius,
                notchSize: notchSize,
              ),
              child: Container(
                color: Colors.transparent,
                child: child,
              ),
            ),
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onActionTap ?? onTap,
            child: Container(
              width: actionButtonSize,
              height: actionButtonSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: actionButtonBg,
                border: Border.all(
                  color: actionButtonBorderColor,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  actionIcon,
                  color: actionIconColor,
                  size: actionButtonSize * 0.58,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NotchedCardClipper extends CustomClipper<Path> {
  final double cornerRadius;
  final double notchSize;

  _NotchedCardClipper({
    required this.cornerRadius,
    required this.notchSize,
  });

  @override
  Path getClip(Size size) {
    return _buildNotchedPath(size, cornerRadius, notchSize);
  }

  @override
  bool shouldReclip(covariant _NotchedCardClipper oldClipper) {
    return oldClipper.cornerRadius != cornerRadius ||
        oldClipper.notchSize != notchSize;
  }
}

class _NotchedCardPainter extends CustomPainter {
  final Color backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double cornerRadius;
  final double notchSize;

  _NotchedCardPainter({
    required this.backgroundColor,
    this.borderColor,
    required this.borderWidth,
    required this.cornerRadius,
    required this.notchSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildNotchedPath(size, cornerRadius, notchSize);

    final fillPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    if (borderColor != null && borderWidth > 0) {
      final strokePaint = Paint()
        ..color = borderColor!
        ..strokeWidth = borderWidth
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _NotchedCardPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.cornerRadius != cornerRadius ||
        oldDelegate.notchSize != notchSize;
  }
}

Path _buildNotchedPath(Size size, double r, double notchSize) {
  final path = Path();
  final w = size.width;
  final h = size.height;

  path.moveTo(0, r);
  path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));

  final notchStartX = w - notchSize;
  path.lineTo(notchStartX, 0);

  path.cubicTo(
    notchStartX + (notchSize * 0.3),
    0,
    w - (notchSize * 0.45),
    notchSize * 0.35,
    w - (notchSize * 0.3),
    notchSize * 0.55,
  );
  path.cubicTo(
    w - (notchSize * 0.15),
    notchSize * 0.75,
    w,
    notchSize * 0.75,
    w,
    notchSize + 2,
  );

  path.lineTo(w, h - r);
  path.arcToPoint(Offset(w - r, h), radius: Radius.circular(r));

  path.lineTo(r, h);
  path.arcToPoint(Offset(0, h - r), radius: Radius.circular(r));

  path.lineTo(0, r);
  path.close();

  return path;
}
