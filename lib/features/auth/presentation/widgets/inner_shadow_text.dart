import 'package:flutter/material.dart';

/// Text with a Figma-style inner shadow: [fill] is the glyph color and
/// [shadowColor] is painted inside the glyph edges, shifted by [offset].
class InnerShadowText extends StatelessWidget {
  const InnerShadowText(
    this.text, {
    super.key,
    required this.style,
    this.fill = Colors.white,
    this.shadowColor = const Color(0xFF3C66C0),
    this.offset = const Offset(0, 4),
    this.blur = 10,
  });

  final String text;
  final TextStyle style;
  final Color fill;
  final Color shadowColor;
  final Offset offset;
  final double blur;

  @override
  Widget build(BuildContext context) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style.copyWith(color: fill)),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout();

    return Semantics(
      label: text,
      child: CustomPaint(
        size: painter.size,
        painter: _InnerShadowTextPainter(
          text: text,
          style: style,
          fill: fill,
          shadowColor: shadowColor,
          offset: offset,
          blur: blur,
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        ),
      ),
    );
  }
}

class _InnerShadowTextPainter extends CustomPainter {
  _InnerShadowTextPainter({
    required this.text,
    required this.style,
    required this.fill,
    required this.shadowColor,
    required this.offset,
    required this.blur,
    required this.textDirection,
    required this.textScaler,
  });

  final String text;
  final TextStyle style;
  final Color fill;
  final Color shadowColor;
  final Offset offset;
  final double blur;
  final TextDirection textDirection;
  final TextScaler textScaler;

  TextPainter _layout(TextStyle s) => TextPainter(
        text: TextSpan(text: text, style: s),
        textDirection: textDirection,
        textScaler: textScaler,
        maxLines: 1,
      )..layout();

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = (Offset.zero & size).inflate(blur * 2);

    // Isolate from whatever is behind the text, otherwise srcATop would
    // treat the card background as the glyph mask.
    canvas.saveLayer(bounds, Paint());
    _layout(style.copyWith(color: fill)).paint(canvas, Offset.zero);

    canvas.saveLayer(bounds, Paint()..blendMode = BlendMode.srcATop);
    canvas.drawRect(bounds, Paint()..color = shadowColor);

    canvas.saveLayer(bounds, Paint()..blendMode = BlendMode.dstOut);
    _layout(style.copyWith(
      color: null,
      foreground: Paint()
        ..color = Colors.black
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur / 3),
    )).paint(canvas, offset);
    canvas.restore();

    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(_InnerShadowTextPainter old) =>
      old.text != text ||
      old.style != style ||
      old.fill != fill ||
      old.shadowColor != shadowColor ||
      old.offset != offset ||
      old.blur != blur ||
      old.textScaler != textScaler;
}
