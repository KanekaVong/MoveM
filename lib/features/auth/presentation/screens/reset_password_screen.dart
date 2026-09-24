import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auth_controller.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/auth_glass_button.dart';
import '../widgets/auth_layout.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final AuthController controller = Get.find<AuthController>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _isTimerActive = false;
  int _secondsLeft = 60;
  bool _timerFinished = false;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isTimerActive = true;
      _secondsLeft = 60;
      _timerFinished = false;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;

      if (_secondsLeft > 1) {
        setState(() => _secondsLeft--);
        return true;
      }
      setState(() {
        _isTimerActive = false;
        _timerFinished = true;
      });
      return false;
    });
  }

  void _submit(AppLocalizations? l10n) {
    if (_emailController.text.isNotEmpty &&
        _otpController.text.isNotEmpty &&
        _newPasswordController.text.isNotEmpty) {
      controller.resetPassword(
        _emailController.text.trim(),
        _otpController.text.trim(),
        _newPasswordController.text.trim(),
      );
    } else {
      Get.snackbar(
        l10n?.errorTitle ?? 'Error',
        l10n?.fillAllFields ?? 'Please fill all fields.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final canSend = !_isTimerActive && _emailController.text.trim().isNotEmpty;

    return AuthLayout(
      title: l10n?.resetPasswordTitle ?? 'RESET PASSWORD',
      onBack: () => Get.back(),
      children: [
        AuthTextField(
          label: l10n?.email ?? 'EMAIL',
          hint: l10n?.emailHint ?? 'Enter your email',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) => setState(() {}),
        ),
        AuthTextField(
          label: l10n?.otpCodeLabel ?? 'OTP CODE',
          hint: l10n?.otpCodeHint ?? 'Enter 6-digit code',
          controller: _otpController,
          keyboardType: TextInputType.number,
          suffix: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: TextButton(
              onPressed: canSend
                  ? () {
                      controller.forgotPassword(_emailController.text.trim());
                      _startTimer();
                    }
                  : null,
              child: Text(
                _isTimerActive
                    ? '${_secondsLeft}s'
                    : (_timerFinished
                        ? (l10n?.resendCode ?? 'Resend Code')
                        : (l10n?.sendOtp ?? 'Send OTP')),
                style: GoogleFonts.robotoCondensed(
                  color: canSend ? AuthColors.brandBlue : AuthColors.hint,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
        AuthTextField(
          label: l10n?.newPassword ?? 'NEW PASSWORD',
          hint: l10n?.newPasswordHint ?? 'Enter new password',
          controller: _newPasswordController,
          obscureText: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(l10n),
        ),
        const SizedBox(height: 12),
        Obx(() => AuthGlassButton(
              label: l10n?.savePasswordAction ?? 'Save Password',
              isLoading: controller.isLoading,
              onPressed: () => _submit(l10n),
            )),
      ],
    );
  }
}
