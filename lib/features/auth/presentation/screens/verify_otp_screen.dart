import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auth_controller.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/auth_glass_button.dart';
import '../widgets/auth_layout.dart';

class VerifyOtpScreen extends GetView<AuthController> {
  VerifyOtpScreen({super.key});

  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String identifier = Get.arguments?['identifier'] ?? '';
    final String mode = Get.arguments?['mode'] ?? 'login';
    final l10n = AppLocalizations.of(context);

    void submit() {
      final otp = _otpController.text.trim();
      if (otp.isEmpty) return;
      if (mode == 'email') {
        controller.verifyEmail(identifier.trim(), otp);
      } else {
        controller.verifyOtp(identifier.trim(), otp);
      }
    }

    return AuthLayout(
      title: l10n?.verifyOtpTitle ?? 'VERIFY OTP',
      onBack: () => Get.back(),
      children: [
        Text(
          l10n?.otpSentTo(identifier) ?? 'Enter the code we sent to\n$identifier',
          textAlign: TextAlign.center,
          style: GoogleFonts.robotoCondensed(
            color: AuthColors.hint,
            fontSize: 16,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 28),
        AuthTextField(
          label: l10n?.otpCodeLabel ?? 'OTP CODE',
          hint: l10n?.otpCodeHint ?? 'Enter 6-digit code',
          controller: _otpController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => submit(),
        ),
        const SizedBox(height: 12),
        Obx(() => AuthGlassButton(
              label: l10n?.verifyAction ?? 'Verify',
              isLoading: controller.isLoading,
              onPressed: submit,
            )),
        const SizedBox(height: 10),
        AuthFooterLink(
          text: l10n?.resendCode ?? 'Resend Code',
          onTap: () {
            if (mode == 'email') {
              controller.resendVerificationCode(identifier);
            } else {
              controller.resendLoginOtp(identifier);
            }
          },
        ),
      ],
    );
  }
}
