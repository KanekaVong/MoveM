import 'dart:ui';
import 'package:flutter/material.dart';

class CustomGlassButton extends StatefulWidget {
  const CustomGlassButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width,
    this.height = 55,
    this.textStyle,
    this.semanticLabel,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  final TextStyle? textStyle;
  final String? semanticLabel;
  final bool isLoading;

  @override
  State<CustomGlassButton> createState() => _CustomGlassButtonState();
}

class _CustomGlassButtonState extends State<CustomGlassButton> {
  bool _hovered = false;
  bool _pressed = false;

  bool get _isEnabled => widget.onPressed != null && !widget.isLoading;

  double get _backgroundScale {
    if (!_isEnabled) return 1.0;
    if (_pressed) return 1.09;
    if (_hovered) return 1.05;
    return 1.0;
  }

  void _handleHover(bool hovered) {
    if (!_isEnabled || _hovered == hovered) return;
    setState(() => _hovered = hovered);
  }

  void _handleHighlightChanged(bool pressed) {
    if (_pressed == pressed) return;
    setState(() => _pressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    final double height = widget.height;
    final BorderRadius borderRadius = BorderRadius.circular(height / 2);
    final bool enabled = _isEnabled;

    // Diagonal, not horizontal — matches the reference image's angle better
    // than a pure centerLeft -> centerRight sweep.
    const gradientBegin = Alignment(-0.9, -0.6);
    const gradientEnd = Alignment(1.0, 0.8);

    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: widget.semanticLabel ?? widget.label,
        child: AnimatedScale(
          scale: _backgroundScale,
          duration: const Duration(milliseconds: 150),
          child: Container(
            width: widget.width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              boxShadow: [
                // Subtle outer shadow — no white glow
                BoxShadow(
                  color: const Color(0x33091C42),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: borderRadius,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // 1. Real glass blur of whatever sits behind the button.
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                    child: const ColoredBox(color: Color(0x10FFFFFF)),
                  ),

                  // 2. White-to-blue diagonal wash — visible but still glassy.
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: gradientBegin,
                        end: gradientEnd,
                        colors: [
                          const Color(0xFFF2F4F7).withOpacity(0.55),
                          const Color(0xFF1B499B).withOpacity(0.85),
                        ],
                        stops: const [0.35, 0.65],
                      ),
                    ),
                  ),

                  // 3. Gradient glass border — bright top, dark bottom (Apple Glass lighting).
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 1.0,
                      ),
                    ),
                  ),

                  // 4. TOP inner shadow — inset depth.
                  Align(
                    alignment: Alignment.topCenter,
                    child: FractionallySizedBox(
                      heightFactor: 0.3,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.10),
                              Colors.transparent,
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(height / 2),
                            topRight: Radius.circular(height / 2),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 4b. BOTTOM light catch — subtle glass lip.
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: 0.25,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.transparent,
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(height / 2),
                            bottomRight: Radius.circular(height / 2),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 5. Content: gradient-masked label over a soft shadow copy.
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: enabled ? widget.onPressed : null,
                      onHighlightChanged: enabled ? _handleHighlightChanged : null,
                      onHover: enabled ? _handleHover : null,
                      borderRadius: borderRadius,
                      splashColor: Colors.white.withOpacity(0.3),
                      highlightColor: Colors.white.withOpacity(0.2),
                      child: Center(
                        child: widget.isLoading
                            ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 1.0),
                              child: Text(
                                widget.label,
                                style: (widget.textStyle ??
                                    const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ))
                                    .copyWith(
                                    color: Colors.black
                                        .withOpacity(0.1)),
                              ),
                            ),
                            ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (Rect bounds) =>
                                  const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Colors.white,
                                      Color(0xFF7CB8F5),
                                    ],
                                    stops: [0.42, 0.58],
                                  ).createShader(bounds),
                              child: Text(
                                widget.label,
                                style: widget.textStyle ??
                                    const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}