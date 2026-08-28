import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:movem/features/auth/presentation/controllers/auth_controller.dart';

class AddAccountVerifyOtpScreen extends StatefulWidget {
  const AddAccountVerifyOtpScreen({super.key});

  @override
  State<AddAccountVerifyOtpScreen> createState() =>
      _AddAccountVerifyOtpScreenState();
}

class _AddAccountVerifyOtpScreenState
    extends State<AddAccountVerifyOtpScreen> {
  final AuthController _authController = Get.find<AuthController>();

  final TextEditingController _otpController =
  TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        Get.arguments as Map<String, dynamic>? ?? {};

    final String mode = args['mode'] ?? 'otp';
    final String identifier = args['identifier'] ?? '';

    final bool isEmailVerification = mode == 'email';

    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B132B),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 18,
          ),
        ),
        title: const Text(
          'Verify account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            24,
            20,
            24,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              const Text(
                'Verify your account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                isEmailVerification
                    ? 'Enter the verification code sent to your email.'
                    : 'Enter the OTP sent to your email to continue.',
                style: const TextStyle(
                  color: Color(0xFFA0AAB2),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 8),

              if (identifier.isNotEmpty)
                Text(
                  identifier,
                  style: const TextStyle(
                    color: Color(0xFF5394FF),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

              const SizedBox(height: 32),

              const Text(
                'OTP Code',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 4,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Enter 6-digit code',
                  hintStyle: const TextStyle(
                    color: Color(0xFF8793A8),
                    fontSize: 14,
                    letterSpacing: 0,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF162341),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 17,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFF263657),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFF263657),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFF3B82F6),
                      width: 1.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    if (identifier.isEmpty) {
                      return;
                    }

                    if (isEmailVerification) {
                      _authController.resendVerificationCode(
                        identifier,
                      );
                    } else {
                      _authController.resendLoginOtp(
                        identifier,
                      );
                    }
                  },
                  child: const Text(
                    'Resend code',
                    style: TextStyle(
                      color: Color(0xFF5394FF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final otp =
                    _otpController.text.trim();

                    if (otp.isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Please enter the OTP code.',
                      );
                      return;
                    }

                    if (isEmailVerification) {
                      _authController.verifyEmail(
                        identifier,
                        otp,
                        isAddingAccount: true,
                      );
                    } else {
                      _authController.verifyOtp(
                        identifier,
                        otp,
                        isAddingAccount: true,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Verify',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}