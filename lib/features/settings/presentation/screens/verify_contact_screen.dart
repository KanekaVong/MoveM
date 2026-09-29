import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:movem/core/routes/app_routes.dart';
import 'package:movem/core/theme/app_colors.dart';
import 'package:movem/core/utils/app_dialogs.dart';
import 'package:movem/shared/widgets/app_button.dart';
import 'package:movem/shared/widgets/top_tool_bar.dart';
import '../controllers/setting_controller.dart';
import '../models/contact_type.dart';

class VerifyContactScreen extends StatefulWidget {
  final ContactType type;
  final String value;
  final String? verificationId;

  const VerifyContactScreen({
    super.key,
    required this.type,
    required this.value,
    this.verificationId,
  });

  @override
  State<VerifyContactScreen> createState() => _VerifyContactScreenState();
}

class _VerifyContactScreenState extends State<VerifyContactScreen> {
  late final TextEditingController _codeController;
  late final SettingController _settingController;
  Timer? _resendTimer;
  int _resendSeconds = 60;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
    _settingController = Get.find<SettingController>();
    _startResendCountdown();
  }

  void _startResendCountdown() {
    _resendTimer?.cancel();

    setState(() {
      _resendSeconds = 60;
    });

    _resendTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_resendSeconds <= 1) {
          timer.cancel();

          if (mounted) {
            setState(() {
              _resendSeconds = 0;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _resendSeconds--;
            });
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.isDark;
    final pageColor = AppColors.pageBackground;
    final fg = AppColors.textPrimary;
    final textColor = dark ? Colors.white : AppColors.textPrimary;
    final hintColor = dark ? Colors.white54 : AppColors.textSecondary;
    final borderColor = dark ? Colors.white24 : AppColors.borderMuted;
    final focusBorderColor = dark ? Colors.white : AppColors.accentBlue;

    return Scaffold(
      backgroundColor: pageColor,
      appBar: TopToolBar(
        title: 'Your Profile',
        backgroundColor: pageColor,
        foregroundColor: fg,
        onBack: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),

              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: (dark ? const Color(0xFF1B499B) : AppColors.accentBlue)
                        .withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: (dark ? const Color(0xFF1B499B) : AppColors.accentBlue)
                          .withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.mark_email_read_outlined,
                      color: dark ? Colors.white : AppColors.accentBlue,
                      size: 40,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Center(
                child: Text(
                  'Verify email',
                  style: TextStyle(
                    color: fg,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: Text(
                  'We have sent a verification code to your registered email address to confirm your identity. Please check your inbox and enter the code.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: hintColor,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: dark ? const Color(0xFF152238) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: dark ? Colors.white12 : AppColors.borderMuted,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 16,
                        color: dark ? Colors.white70 : AppColors.accentBlue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.value,
                        style: TextStyle(
                          color: fg,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                autofocus: true,
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 12,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  hintText: '000000',
                  hintStyle: TextStyle(
                    color: hintColor.withValues(alpha: 0.35),
                    fontSize: 24,
                    letterSpacing: 12,
                  ),
                  counterText: '',
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  filled: true,
                  fillColor: dark
                      ? const Color(0xFF131D38).withValues(alpha: 0.7)
                      : Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: borderColor,
                      width: 1.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: focusBorderColor,
                      width: 1.8,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: TextButton.icon(
                  onPressed: _resendSeconds > 0
                      ? null
                      : () async {
                          final success =
                              await _settingController.resendEmailChangeCode();

                          if (!mounted || !success) {
                            return;
                          }

                          _startResendCountdown();
                        },
                  icon: Icon(
                    Icons.refresh_rounded,
                    size: 16,
                    color: _resendSeconds > 0
                        ? (dark ? Colors.white38 : AppColors.textCaption)
                        : AppColors.accentBlue,
                  ),
                  label: Text(
                    _resendSeconds > 0
                        ? 'Resend code in ${_resendSeconds}s'
                        : 'Resend code',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _resendSeconds > 0
                          ? (dark ? Colors.white38 : AppColors.textCaption)
                          : AppColors.accentBlue,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              AppButton(
                label: 'Change',
                onPressed: () async {
                  final code = _codeController.text.trim();

                  if (code.isEmpty) {
                    Get.snackbar(
                      'Required',
                      'Please enter the 6-digit verification code',
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  AppDialogs.showLoading();
                  try {
                    final updatedUser =
                        await _settingController.verifyEmailChange(code);
                    AppDialogs.hideLoading();

                    if (updatedUser == null || !mounted) {
                      return;
                    }

                    Get.offNamed(
                      AppRoutes.settingsScreen,
                    );

                    Get.toNamed(
                      AppRoutes.profileScreen,
                    );

                    return;
                  } catch (e) {
                    AppDialogs.hideLoading();
                    debugPrint('[EmailVerification] Error: $e');
                    Get.snackbar(
                      'Verification Failed',
                      e.toString().replaceAll('Exception: ', ''),
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}