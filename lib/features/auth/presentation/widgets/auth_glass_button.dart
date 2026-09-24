import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthGlassButton extends StatefulWidget {
  const AuthGlassButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.height = 57,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;

  @override
  State<AuthGlassButton> createState() => _AuthGlassButtonState();
}

class _AuthGlassButtonState extends State<AuthGlassButton> {
  static const _brandBlue = Color(0xFF3C66C0);

  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(widget.height / 2);

    return Opacity(
      opacity: _enabled ? 1 : 0.6,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          height: widget.height,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: const [
              BoxShadow(
                color: Color(0x40000000),
                offset: Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              fit: StackFit.expand,
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: const SizedBox.expand(),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(color: Color(0xCCF0F0F0)),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(color: Color(0x66E8E8E8)),
                ),
                CustomPaint(
                  painter: InnerShadowPainter(
                    borderRadius: BorderRadius.circular(widget.height / 2),
                    color: _brandBlue.withValues(alpha: 0.6),
                    offset: const Offset(3, 3),
                    blur: 29,
                  ),
                ),
                CustomPaint(
                  painter: _GlassRimPainter(
                    radius: widget.height / 2,
                    lightAngleDegrees: -45,
                    intensity: 0.8,
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: radius,
                    onTap: _enabled ? widget.onPressed : null,
                    onHighlightChanged: (v) => setState(() => _pressed = v),
                    splashColor: _brandBlue.withValues(alpha: 0.12),
                    highlightColor: _brandBlue.withValues(alpha: 0.06),
                    child: Center(
                      child: widget.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: _brandBlue,
                              ),
                            )
                          : Text(
                              widget.label,
                              style: GoogleFonts.robotoCondensed(
                                color: _brandBlue,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Figma-style inner shadow. [blur] is the Figma blur value; Figma renders it
/// as a Gaussian with sigma of roughly blur / 3.
class InnerShadowPainter extends CustomPainter {
  InnerShadowPainter({
    required this.borderRadius,
    required this.color,
    required this.offset,
    required this.blur,
  });

  final BorderRadius borderRadius;
  final Color color;
  final Offset offset;
  final double blur;

  @override
  void paint(Canvas canvas, Size size) {
    final shape = borderRadius.toRRect(Offset.zero & size);
    canvas.save();
    canvas.clipRRect(shape);

    final outer = Path()..addRect((Offset.zero & size).inflate(blur * 2));
    final hole = Path()..addRRect(shape.shift(offset));
    final ring = Path.combine(PathOperation.difference, outer, hole);

    canvas.drawPath(
      ring,
      Paint()
        ..color = color
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur / 3),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(InnerShadowPainter old) =>
      old.color != color ||
      old.offset != offset ||
      old.blur != blur ||
      old.borderRadius != borderRadius;
}

class _GlassRimPainter extends CustomPainter {
  _GlassRimPainter({
    required this.radius,
    required this.lightAngleDegrees,
    required this.intensity,
  });

  final double radius;
  final double lightAngleDegrees;
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final shape = RRect.fromRectAndRadius(rect.deflate(0.6), Radius.circular(radius));
    final angle = lightAngleDegrees * math.pi / 180;
    final light = Alignment(math.cos(angle), math.sin(angle));

    canvas.drawRRect(
      shape,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..shader = LinearGradient(
          begin: Alignment(-light.x, light.y),
          end: Alignment(light.x, -light.y),
          colors: [
            Colors.white.withValues(alpha: intensity),
            Colors.white.withValues(alpha: 0.05),
            Colors.white.withValues(alpha: intensity * 0.5),
          ],
          stops: const [0, 0.5, 1],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_GlassRimPainter old) =>
      old.lightAngleDegrees != lightAngleDegrees || old.intensity != intensity || old.radius != radius;
}
