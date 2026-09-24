import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';

enum AppButtonVariant { primary, secondary, danger }

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 48,
  });

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 48,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.danger({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 48,
  }) : variant = AppButtonVariant.danger;

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;

  /// `null` sizes the button to its content.
  final double? width;
  final double height;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final compact = widget.height < 44;
    final style = _AppButtonStyle.of(widget.variant, AppColors.isDark, compact: compact);
    final radius = BorderRadius.circular(widget.height / 2);
    final fontSize = compact ? 12.5 : 15.0;
    final iconSize = compact ? 15.0 : 18.0;

    final content = widget.isLoading
        ? SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(strokeWidth: 2, color: style.foreground),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: iconSize, color: style.foreground),
                SizedBox(width: compact ? 5 : 8),
              ],
              Flexible(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.robotoCondensed(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                    letterSpacing: compact ? 0.4 : 0.8,
                    color: style.foreground,
                  ),
                ),
              ),
            ],
          );

    return Semantics(
      button: true,
      enabled: _enabled,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: _enabled || widget.isLoading ? 1 : 0.45,
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: radius,
              boxShadow: style.shadow,
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    gradient: style.fill,
                    border: Border.all(color: style.border, width: 1.2),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        height: widget.height * 0.5,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [style.sheen, style.sheen.withValues(alpha: 0)],
                            ),
                          ),
                        ),
                      ),
                      Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: _enabled ? widget.onPressed : null,
                          onHighlightChanged: _enabled ? _setPressed : null,
                          borderRadius: radius,
                          splashColor: style.foreground.withValues(alpha: 0.14),
                          highlightColor: style.foreground.withValues(alpha: 0.06),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 20),
                            child: Center(child: content),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppButtonStyle {
  const _AppButtonStyle({
    required this.fill,
    required this.border,
    required this.sheen,
    required this.foreground,
    required this.shadow,
  });

  final Gradient fill;
  final Color border;
  final Color sheen;
  final Color foreground;
  final List<BoxShadow> shadow;

  static const _blueTop = Color(0xFF4F7FE6);
  static const _blueBottom = Color(0xFF1E48A8);
  static const _redTop = Color(0xFFF26B6B);
  static const _redBottom = Color(0xFFC62B2B);

  static _AppButtonStyle of(AppButtonVariant variant, bool isDark, {bool compact = false}) {
    final shadowOffset = Offset(0, compact ? 3 : 6);
    final shadowBlur = compact ? 8.0 : 16.0;
    switch (variant) {
      case AppButtonVariant.primary:
        return _AppButtonStyle(
          fill: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_blueTop, _blueBottom],
          ),
          border: Colors.white.withValues(alpha: 0.35),
          sheen: Colors.white.withValues(alpha: 0.22),
          foreground: Colors.white,
          shadow: [
            BoxShadow(
              color: _blueBottom.withValues(alpha: 0.35),
              offset: shadowOffset,
              blurRadius: shadowBlur,
              spreadRadius: -4,
            ),
          ],
        );
      case AppButtonVariant.danger:
        return _AppButtonStyle(
          fill: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_redTop, _redBottom],
          ),
          border: Colors.white.withValues(alpha: 0.35),
          sheen: Colors.white.withValues(alpha: 0.22),
          foreground: Colors.white,
          shadow: [
            BoxShadow(
              color: _redBottom.withValues(alpha: 0.32),
              offset: shadowOffset,
              blurRadius: shadowBlur,
              spreadRadius: -4,
            ),
          ],
        );
      case AppButtonVariant.secondary:
        return _AppButtonStyle(
          fill: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [Colors.white.withValues(alpha: 0.12), Colors.white.withValues(alpha: 0.04)]
                : [Colors.white.withValues(alpha: 0.85), const Color(0xFFE9EFFB).withValues(alpha: 0.85)],
          ),
          border: isDark ? Colors.white.withValues(alpha: 0.28) : _blueTop.withValues(alpha: 0.55),
          sheen: Colors.white.withValues(alpha: isDark ? 0.08 : 0.5),
          foreground: isDark ? Colors.white : _blueBottom,
          shadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
              offset: const Offset(0, 4),
              blurRadius: 12,
              spreadRadius: -4,
            ),
          ],
        );
    }
  }
}
