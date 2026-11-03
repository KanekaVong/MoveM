import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auth_controller.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/auth_glass_button.dart';
import '../widgets/auth_layout.dart';
import '../widgets/auth_otp_input.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  static const int _otpLength = 6;
  static const int _resendCooldown = 60; // 1 minute

  final AuthController controller = Get.find<AuthController>();
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocus = FocusNode();

  late final String identifier = Get.arguments?['identifier'] ?? '';
  late final String mode = Get.arguments?['mode'] ?? 'login';

  /// Shown in the "sent to" text: the account email when known, since a
  /// login can use a username. API calls still use [identifier].
  late final String sentTo = _sentToTarget();

  Timer? _resendTimer;
  DateTime _resendAvailableAt = clock.now();
  int _secondsLeft = 0;
  bool _submitting = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    // A code was sent just before this screen opened.
    _startResendCooldown();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _otpController.dispose();
    _otpFocus.dispose();
    super.dispose();
  }

  String _sentToTarget() {
    final email = Get.arguments?['email']?.toString().trim() ?? '';
    if (email.isNotEmpty) return email;
    final name = identifier.trim();
    // Login by username: the server doesn't return the email yet, so assume
    // Gmail. Leave real emails and phone numbers as they are.
    final isPhone = RegExp(r'^\+?[\d\s-]+$').hasMatch(name);
    if (name.isEmpty || name.contains('@') || isPhone) return name;
    return '$name@gmail.com';
  }

  /// Counts down to a fixed deadline rather than decrementing, so the
  /// countdown stays right after the app has been in the background.
  /// Safe to call from initState: it doesn't call setState directly.
  void _startResendCooldown() {
    _resendTimer?.cancel();
    _resendAvailableAt = clock.now().add(const Duration(seconds: _resendCooldown));
    _secondsLeft = _resendCooldown;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (!mounted) return _resendTimer?.cancel();
    final left = (_resendAvailableAt.difference(clock.now()).inMilliseconds / 1000).ceil();
    setState(() => _secondsLeft = left.clamp(0, _resendCooldown));
    if (_secondsLeft == 0) _resendTimer?.cancel();
  }

  void _stopResendCooldown() {
    _resendTimer?.cancel();
    setState(() => _secondsLeft = 0);
  }

  Future<void> _submit() async {
    final otp = _otpController.text.trim();
    // Ignore partial codes and a second submit while one is in flight
    // (auto-submit on the last digit can race with the Verify button).
    if (otp.length < _otpLength || _submitting || controller.isLoading) return;

    setState(() => _submitting = true);
    try {
      if (mode == 'email') {
        await controller.verifyEmail(identifier.trim(), otp);
      } else {
        await controller.verifyOtp(identifier.trim(), otp);
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
    if (!mounted) return;

    setState(() {
      // On success the controller navigates away; still here with an error
      // means the code was rejected, so flag the boxes and let them retype.
      _hasError = controller.hasError;
    });
    // The boxes stay focused, so the user can type the new code straight
    // after closing the error dialog.
    if (_hasError) _otpController.clear();
  }

  Future<void> _resend() async {
    _otpController.clear();
    setState(() {
      _hasError = false;
      _startResendCooldown();
    });
    if (mode == 'email') {
      await controller.resendVerificationCode(identifier);
    } else {
      await controller.resendLoginOtp(identifier);
    }
    // No code went out, so don't make them wait to retry.
    if (mounted && controller.hasError) _stopResendCooldown();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sentToText = l10n?.otpSentTo(sentTo) ?? 'Enter the code we sent to\n$sentTo';

    return AuthLayout(
      title: l10n?.verifyOtpTitle ?? 'VERIFY OTP',
      onBack: () => Get.back(),
      children: [
        _SentToText(text: sentToText, identifier: sentTo),
        const SizedBox(height: 28),
        AuthOtpInput(
          label: l10n?.otpCodeLabel ?? 'OTP CODE',
          controller: _otpController,
          focusNode: _otpFocus,
          length: _otpLength,
          hasError: _hasError,
          onChanged: (value) {
            // Clearing the boxes after a wrong code also fires this with an
            // empty value; keep the error until they actually type.
            if (_hasError && value.isNotEmpty) setState(() => _hasError = false);
          },
          onCompleted: (_) => _submit(),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _otpController,
          builder: (context, value, _) => AuthGlassButton(
            label: l10n?.verifyAction ?? 'Verify',
            isLoading: _submitting,
            onPressed: value.text.length == _otpLength ? _submit : null,
          ),
        ),
        const SizedBox(height: 18),
        _ResendRow(
          prompt: l10n?.didntGetCode ?? "Didn't get the code?",
          action: l10n?.resendCode ?? 'Resend Code',
          countdown: _secondsLeft > 0
              ? (l10n?.resendCodeIn(_formatSeconds(_secondsLeft)) ?? 'Resend in ${_formatSeconds(_secondsLeft)}')
              : null,
          onResend: _resend,
        ),
      ],
    );
  }

  static String _formatSeconds(int seconds) =>
      '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
}

/// The "sent to" message with the email or phone number in bold.
class _SentToText extends StatelessWidget {
  const _SentToText({required this.text, required this.identifier});

  final String text;
  final String identifier;

  @override
  Widget build(BuildContext context) {
    final base = GoogleFonts.robotoCondensed(
      color: AuthColors.hint,
      fontSize: 16,
      height: 1.4,
    );
    final at = identifier.isEmpty ? -1 : text.lastIndexOf(identifier);

    return Text.rich(
      at < 0
          ? TextSpan(text: text)
          : TextSpan(children: [
              TextSpan(text: text.substring(0, at)),
              TextSpan(
                text: identifier,
                style: base.copyWith(
                  color: AuthColors.headerNavy,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(text: text.substring(at + identifier.length)),
            ]),
      textAlign: TextAlign.start,
      style: base,
    );
  }
}

/// "Didn't get the code?" with a countdown, then a Resend link once it ends.
class _ResendRow extends StatelessWidget {
  const _ResendRow({
    required this.prompt,
    required this.action,
    required this.countdown,
    required this.onResend,
  });

  final String prompt;
  final String action;
  final String? countdown;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.robotoCondensed(fontSize: 15, color: AuthColors.hint);

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('$prompt ', style: style),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: countdown != null
              ? Padding(
                  key: const ValueKey('countdown'),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    countdown!,
                    style: style.copyWith(
                      color: AuthColors.headerNavy.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w600,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                )
              : InkWell(
                  key: const ValueKey('resend'),
                  borderRadius: BorderRadius.circular(8),
                  onTap: onResend,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: Text(
                      action,
                      style: style.copyWith(
                        color: AuthColors.brandBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
