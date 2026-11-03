import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import 'auth_layout.dart';
import 'inner_shadow_text.dart';

/// One-box-per-digit OTP field styled like [AuthTextField].
///
/// Pinput keeps a single hidden text field underneath, so paste and the
/// keyboard's one-time-code suggestion fill every box at once. The boxes are
/// split into two groups of three, and they shake and turn red when
/// [hasError] switches on.
class AuthOtpInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final bool hasError;
  final int length;

  /// Horizontal space around the field on screen (the auth card's padding),
  /// used to size the boxes to the screen width.
  final double horizontalInset;

  const AuthOtpInput({
    super.key,
    required this.label,
    required this.controller,
    this.focusNode,
    this.onCompleted,
    this.onChanged,
    this.hasError = false,
    this.length = 6,
    this.horizontalInset = 56,
  });

  @override
  State<AuthOtpInput> createState() => _AuthOtpInputState();
}

class _AuthOtpInputState extends State<AuthOtpInput> with SingleTickerProviderStateMixin {
  static const double _gap = 8;
  static const double _groupGap = 22;
  static const Color _ink = Color(0xFF111827);
  static const Color _errorRed = Color(0xFFE53935);

  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  int get _half => widget.length ~/ 2;

  @override
  void didUpdateWidget(AuthOtpInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasError && !oldWidget.hasError) {
      _shake.forward(from: 0);
      HapticFeedback.mediumImpact();
    }
  }

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InnerShadowText(
            widget.label.toUpperCase(),
            style: GoogleFonts.robotoCondensed(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Builder(
            // Not LayoutBuilder: AuthLayout wraps its content in
            // IntrinsicHeight, which LayoutBuilder can't report sizes to.
            builder: (context) {
              final available = MediaQuery.sizeOf(context).width - widget.horizontalInset;
              final gaps = _gap * (widget.length - 2) + _groupGap;
              final boxWidth = ((available - gaps) / widget.length).clamp(36.0, 54.0);

              return AnimatedBuilder(
                animation: _shake,
                // A damped sine: three swings that fade out.
                builder: (context, child) => Transform.translate(
                  offset: Offset(
                    math.sin(_shake.value * math.pi * 6) * 10 * (1 - _shake.value),
                    0,
                  ),
                  child: child,
                ),
                child: Pinput(
                  length: widget.length,
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  pinAnimationType: PinAnimationType.scale,
                  animationDuration: const Duration(milliseconds: 160),
                  forceErrorState: widget.hasError,
                  showErrorWhenFocused: true,
                  separatorBuilder: (index) => index == _half - 1
                      ? SizedBox(
                          width: _groupGap,
                          child: Center(
                            child: Container(
                              width: 8,
                              height: 2,
                              decoration: BoxDecoration(
                                color: AuthColors.hint.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(width: _gap),
                  preFilledWidget: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AuthColors.hint.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                    ),
                  ),
                  cursor: Container(
                    width: 2,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AuthColors.brandBlue,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  defaultPinTheme: _theme(
                    boxWidth,
                    border: AuthColors.brandBlue.withValues(alpha: 0.18),
                  ),
                  focusedPinTheme: _theme(
                    boxWidth,
                    border: AuthColors.brandBlue,
                    borderWidth: 2,
                    glow: AuthColors.brandBlue.withValues(alpha: 0.35),
                  ),
                  submittedPinTheme: _theme(
                    boxWidth,
                    fill: const Color(0xFFF1F5FD),
                    border: AuthColors.brandBlue.withValues(alpha: 0.55),
                    textColor: AuthColors.brandBlue,
                  ),
                  errorPinTheme: _theme(
                    boxWidth,
                    fill: const Color(0xFFFFF4F4),
                    border: _errorRed,
                    borderWidth: 1.6,
                    textColor: _errorRed,
                    glow: _errorRed.withValues(alpha: 0.22),
                  ),
                  onChanged: widget.onChanged,
                  onCompleted: widget.onCompleted,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  PinTheme _theme(
    double width, {
    required Color border,
    Color fill = Colors.white,
    double borderWidth = 1.2,
    Color textColor = _ink,
    Color? glow,
  }) {
    return PinTheme(
      width: width,
      height: 58,
      textStyle: GoogleFonts.robotoCondensed(
        color: textColor,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: borderWidth),
        boxShadow: [
          // Same pressed-in edge as AuthTextField.
          BoxShadow(
            color: AuthColors.brandBlue.withValues(alpha: 0.4),
            offset: const Offset(-1, 1.5),
          ),
          BoxShadow(
            color: glow ?? AuthColors.brandBlue.withValues(alpha: 0.14),
            offset: const Offset(0, 6),
            blurRadius: glow == null ? 10 : 16,
          ),
        ],
      ),
    );
  }
}
