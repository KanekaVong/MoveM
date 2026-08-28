import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:movem/features/settings/data/dto/request/change_password_request.dart';
import 'package:movem/features/settings/presentation/controllers/setting_controller.dart';
import 'package:movem/features/settings/presentation/screens/settings_forgot_password_screen.dart';

import 'package:movem/features/settings/data/services/setting_service.dart';
import 'package:movem/features/settings/data/repositories/setting_repository_impl.dart';
import 'package:movem/core/storage/user_manager.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();

  final _newPasswordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  bool _currentObscured = true;
  bool _newObscured = true;
  bool _confirmObscured = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final SettingController controller;

    if (Get.isRegistered<SettingController>()) {
      controller = Get.find<SettingController>();
    } else {
      controller = SettingController(
        repository: SettingRepositoryImpl(
          settingService: SettingService(),
        ),
      );
    }

    final deviceId =
    await UserManager().getOrCreateDeviceId();

    await controller.changePassword(
      ChangePasswordRequest(
        currentPassword:
        _currentPasswordController.text,
        newPassword:
        _newPasswordController.text,
        deviceId: deviceId,
      ),
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();

    Get.snackbar(
      'Success',
      'Your password has been changed.',
    );
  }

  InputDecoration _passwordDecoration({
    required String hint,
    required bool obscured,
    required VoidCallback onToggle,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF8793A8),
      ),
      filled: true,
      fillColor: const Color(0xFF162341),
      suffixIcon: IconButton(
        onPressed: onToggle,
        icon: Icon(
          obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: Colors.white70,
        ),
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
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Change your password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter your current password and choose a new one.',
                  style: TextStyle(
                    color: Color(0xFFA0AAB2),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Current Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: _currentObscured,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: _passwordDecoration(
                    hint: 'Enter current password',
                    obscured: _currentObscured,
                    onToggle: () {
                      setState(() {
                        _currentObscured = !_currentObscured;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'New Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _newObscured,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: _passwordDecoration(
                    hint: 'Enter new password',
                    obscured: _newObscured,
                    onToggle: () {
                      setState(() {
                        _newObscured = !_newObscured;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password.';
                    }

                    if (value.length < 8) {
                      return 'Password must be at least 8 characters.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Confirm New Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _confirmObscured,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: _passwordDecoration(
                    hint: 'Confirm new password',
                    obscured: _confirmObscured,
                    onToggle: () {
                      setState(() {
                        _confirmObscured = !_confirmObscured;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your new password.';
                    }

                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.to(
                            () => const SettingsForgotPasswordScreen(),
                      );
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Color(0xFF5394FF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Change Password',
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
      ),
    );
  }
}
