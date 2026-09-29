import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth_glass_button.dart';
import 'inner_shadow_text.dart';

class AuthColors {
  AuthColors._();

  static const brandBlue = Color(0xFF3C66C0);
  static const lightBlue = Color(0xFFB9CCF2);
  static const headerNavy = Color(0xFF0E1628);
  static const hint = Color(0xFF9AA3AF);
}

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.title,
    required this.children,
    this.onBack,
  });

  final String title;
  final List<Widget> children;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthColors.headerNavy,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const _AuthHeader(),
                      Expanded(
                        child: _AuthCard(
                          title: title,
                          onBack: onBack,
                          children: children,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AuthHeader extends StatelessWidget {
  const _AuthHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 34),
      child: Column(
        children: [
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color(0xFFDDE6F7), Color(0xFF7F9BD6), Colors.white],
              stops: [0, 0.45, 0.55, 1],
            ).createShader(bounds),
            child: Text(
              'MOVEM',
              style: GoogleFonts.michroma(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, AuthColors.lightBlue],
              ).createShader(bounds),
              child: Text(
                'YOUR LIFE, IN MOTION',
                style: GoogleFonts.robotoCondensed(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard({
    required this.title,
    required this.children,
    this.onBack,
  });

  final String title;
  final List<Widget> children;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.vertical(top: Radius.circular(32));

    return ClipRRect(
      borderRadius: radius,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: radius,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    gradient: RadialGradient(
                      center: Alignment.topCenter,
                      radius: 1.6,
                      colors: [
                        Colors.white.withValues(alpha: 0),
                        Colors.white.withValues(alpha: 0),
                        AuthColors.brandBlue.withValues(alpha: 0.10),
                      ],
                      stops: const [0, 0.72, 1],
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: InnerShadowPainter(
                    borderRadius: radius,
                    color: AuthColors.brandBlue.withValues(alpha: 0.45),
                    offset: Offset.zero,
                    blur: 36,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      if (onBack != null) ...[
                        _BackCircle(onTap: onBack!),
                        const SizedBox(width: 18),
                      ],
                      Expanded(
                        child: Align(
                          alignment: onBack != null ? Alignment.centerLeft : Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: _GradientTitle(title),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  ...children,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackCircle extends StatelessWidget {
  const _BackCircle({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFEEF0F4),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          width: 38,
          height: 38,
          child: Icon(Icons.chevron_left_rounded, color: AuthColors.brandBlue, size: 26),
        ),
      ),
    );
  }
}

class _GradientTitle extends StatelessWidget {
  const _GradientTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return InnerShadowText(
      text.toUpperCase(),
      style: GoogleFonts.robotoCondensed(
        fontSize: 26,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.onChanged,
    this.suffix,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscured = widget.obscureText;

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(16));

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
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: radius,
              boxShadow: [
                BoxShadow(
                  color: AuthColors.brandBlue.withValues(alpha: 0.55),
                  offset: const Offset(-1, 1.5),
                ),
                BoxShadow(
                  color: AuthColors.brandBlue.withValues(alpha: 0.18),
                  offset: const Offset(0, 6),
                  blurRadius: 10,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: TextField(
                controller: widget.controller,
                obscureText: _obscured,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
                onSubmitted: widget.onSubmitted,
                onChanged: widget.onChanged,
                style: GoogleFonts.robotoCondensed(
                  color: const Color(0xFF111827),
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: widget.hint,
                  hintStyle: GoogleFonts.robotoCondensed(
                    color: AuthColors.hint,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 17),
                  suffixIcon: widget.suffix ?? (widget.obscureText
                      ? IconButton(
                          splashRadius: 20,
                          onPressed: () => setState(() => _obscured = !_obscured),
                          icon: Icon(
                            _obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: AuthColors.hint,
                            size: 20,
                          ),
                        )
                      : null),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    super.key,
    required this.text,
    required this.onTap,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: AuthColors.brandBlue,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
        child: Text(
          text,
          style: GoogleFonts.robotoCondensed(
            color: AuthColors.brandBlue,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
