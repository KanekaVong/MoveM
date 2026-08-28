import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:movem/features/auth/presentation/controllers/auth_controller.dart';

class SettingsForgotPasswordScreen extends StatefulWidget {
  const SettingsForgotPasswordScreen({super.key});

  @override
  State<SettingsForgotPasswordScreen> createState() =>
      _SettingsForgotPasswordScreenState();
}

class _SettingsForgotPasswordScreenState
    extends State<SettingsForgotPasswordScreen> {
  final AuthController controller = Get.find<AuthController>();

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _otpController =
  TextEditingController();

  final TextEditingController _newPasswordController =
  TextEditingController();

  final TextEditingController _confirmPasswordController =
  TextEditingController();

  Timer? _timer;

  int _secondsLeft = 0;
  bool _isTimerActive = false;
  bool _timerFinished = false;

  bool _newPasswordObscured = true;
  bool _confirmPasswordObscured = true;

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_isTimerActive) {
      return;
    }

    setState(() {
      _isTimerActive = true;
      _timerFinished = false;
      _secondsLeft = 60;
    });

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (_secondsLeft > 0) {
          setState(() {
            _secondsLeft--;
          });
        } else {
          setState(() {
            _isTimerActive = false;
            _timerFinished = true;
          });

          _timer?.cancel();
        }
      },
    );
  }

  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email.',
      );
      return;
    }

    await controller.forgotPassword(email);
    _startTimer();
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();
    final newPassword = _newPasswordController.text;
    final confirmPassword =
        _confirmPasswordController.text;

    if (email.isEmpty ||
        otp.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields.',
      );
      return;
    }

    if (newPassword.length < 8) {
      Get.snackbar(
        'Error',
        'Password must be at least 8 characters.',
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        'Error',
        'Passwords do not match.',
      );
      return;
    }

    await controller.resetPassword(
      email,
      otp,
      newPassword,
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF8793A8),
        fontSize: 14,
      ),
      filled: true,
      fillColor: const Color(0xFF162341),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
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
    );
  }

  Widget _buildLabel(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
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
          'Forgot Password',
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
            12,
            24,
            24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Reset your password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Enter your email and use the OTP sent to you to create a new password.',
                style: TextStyle(
                  color: Color(0xFFA0AAB2),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              _buildLabel('Email'),

              const SizedBox(height: 8),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                decoration: _inputDecoration(
                  hint: 'Enter your email',
                ),
              ),

              const SizedBox(height: 20),

              _buildLabel('OTP Code'),

              const SizedBox(height: 8),

              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                decoration: _inputDecoration(
                  hint: 'Enter 6-digit OTP',
                  suffixIcon: TextButton(
                    onPressed:
                    _isTimerActive ? null : _sendOtp,
                    child: Text(
                      _isTimerActive
                          ? '$_secondsLeft s'
                          : (_timerFinished
                          ? 'Resend'
                          : 'Send OTP'),
                      style: TextStyle(
                        color: _isTimerActive
                            ? const Color(0xFF68758C)
                            : const Color(0xFF5394FF),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'The OTP expires according to your account security settings.',
                style: TextStyle(
                  color: Color(0xFF68758C),
                  fontSize: 11,
                ),
              ),

              const SizedBox(height: 20),

              _buildLabel('New Password'),

              const SizedBox(height: 8),

              TextField(
                controller: _newPasswordController,
                obscureText: _newPasswordObscured,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                decoration: _inputDecoration(
                  hint: 'Enter new password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _newPasswordObscured =
                        !_newPasswordObscured;
                      });
                    },
                    icon: Icon(
                      _newPasswordObscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _buildLabel('Confirm New Password'),

              const SizedBox(height: 8),

              TextField(
                controller: _confirmPasswordController,
                obscureText: _confirmPasswordObscured,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                decoration: _inputDecoration(
                  hint: 'Confirm new password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _confirmPasswordObscured =
                        !_confirmPasswordObscured;
                      });
                    },
                    icon: Icon(
                      _confirmPasswordObscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Password must be at least 8 characters.',
                style: TextStyle(
                  color: Color(0xFF68758C),
                  fontSize: 11,
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _resetPassword,
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
                    'Reset Password',
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