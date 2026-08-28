import 'package:flutter/material.dart';
import '../models/contact_type.dart';
import 'package:get/get.dart';
import '../controllers/setting_controller.dart';
import 'dart:async';
import 'package:movem/core/routes/app_routes.dart';
import '../screens/ProfileScreen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:movem/features/settings/data/services/firebase_phone_service.dart';

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
  final FirebasePhoneService _firebasePhoneService =
  FirebasePhoneService();

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
    final isEmail = widget.type == ContactType.email;

    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B132B),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Your Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(
                  isEmail
                      ? Icons.email_outlined
                      : Icons.phone_outlined,
                  color: Colors.white,
                  size: 48,
                ),
              ),

              const SizedBox(height: 24),

              Center(
                child: Text(
                  isEmail ? 'Verify email' : 'Verify phone',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                isEmail
                    ? 'We will send a verification code to your registered email address to confirm your identity. Please check your inbox and enter the code.'
                    : 'We will send a verification code via SMS to confirm your identity. Please check your SMS and enter the code.',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                widget.value,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 24),

              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 8,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter code',
                  hintStyle: TextStyle(
                    color: Colors.white54,
                    fontSize: 15,
                    letterSpacing: 0,
                  ),
                  counterText: '',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white24,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: TextButton(
                  onPressed: _resendSeconds > 0
                      ? null
                      : () async {
                    if (widget.type != ContactType.email) {
                      return;
                    }

                    final success =
                    await _settingController.resendEmailChangeCode();

                    if (!mounted || !success) {
                      return;
                    }

                    _startResendCountdown();
                  },
                  child: Text(
                    _resendSeconds > 0
                        ? 'Resend code in ${_resendSeconds}s'
                        : 'Resend code',
                    style: TextStyle(
                      color: _resendSeconds > 0
                          ? Colors.white38
                          : Colors.white70,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final code = _codeController.text.trim();

                    if (code.isEmpty) {
                      return;
                    }

                    // EMAIL
                    if (widget.type == ContactType.email) {
                      final updatedUser =
                      await _settingController.verifyEmailChange(code);

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
                    }

                    // PHONE
                    if (widget.type == ContactType.phone) {
                      if (widget.verificationId == null ||
                          widget.verificationId!.isEmpty) {
                        return;
                      }

                      try {
                        final userCredential =
                        await _firebasePhoneService.verifyCode(
                          verificationId: widget.verificationId!,
                          code: code,
                        );

                        final firebaseUser = userCredential.user;

                        if (firebaseUser == null) {
                          throw Exception('Firebase user was not created.');
                        }

                        final firebaseIdToken =
                        await firebaseUser.getIdToken();

                        if (firebaseIdToken == null || firebaseIdToken.isEmpty) {
                          throw Exception('Failed to obtain Firebase ID token.');
                        }

                        final updatedUser =
                        await _settingController.verifyPhone(firebaseIdToken);

                        if (updatedUser == null || !mounted) {
                          return;
                        }

                        Get.offNamed(
                          AppRoutes.settingsScreen,
                        );

                        Get.toNamed(
                          AppRoutes.profileScreen,
                        );
                      } on FirebaseAuthException catch (e) {
                        debugPrint(
                          'Firebase phone verification error: ${e.message}',
                        );
                      } catch (e) {
                        debugPrint('Phone verification error: $e');
                      }
                    }
                  },
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}