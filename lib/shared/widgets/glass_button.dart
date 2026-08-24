import 'package:flutter/material.dart';
import 'custom_glass_button.dart';

class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double? width;
  final bool isLoading;

  const GlassButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 55.0,
    this.width = double.infinity,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomGlassButton(
      label: text,
      onPressed: onPressed,
      width: width,
      height: height,
      isLoading: isLoading,
    );
  }
}
