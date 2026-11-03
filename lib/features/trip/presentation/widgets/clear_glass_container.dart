import 'dart:ui';
import 'package:flutter/material.dart';

class ClearGlassContainer extends StatelessWidget {
  final Widget child;

  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double blur;
  final Color backgroundColor;
  final double backgroundOpacity;
  final Color borderColor;
  final double borderOpacity;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;

  const ClearGlassContainer({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.borderRadius = 24,
    this.blur = 24,
    this.backgroundColor = const Color(0xFF0F172A),
    this.backgroundOpacity = 0.38,
    this.borderColor = Colors.white,
    this.borderOpacity = 0.25,
    this.borderWidth = 1.2,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blur,
            sigmaY: blur,
          ),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor.withValues(
                alpha: backgroundOpacity,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor.withValues(
                  alpha: borderOpacity,
                ),
                width: borderWidth,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}