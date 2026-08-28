import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:movem/features/auth/presentation/controllers/auth_controller.dart';
import 'package:movem/features/auth/presentation/bindings/auth_binding.dart';
import 'package:movem/features/settings/presentation/screens/add_account_register_screen.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final AuthController _authController = Get.find<AuthController>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordObscured = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your username and password.',
      );
      return;
    }

    await _authController.login(
      username,
      password,
      isAddingAccount: true,
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Setting',
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
              const Text(
                'Add another account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Log in to another MoveM account on this device.',
                style: TextStyle(
                  color: Color(0xFFA0AAB2),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              // Username Custom Field
              CustomMuiTextField(
                label: 'Username',
                controller: _usernameController,
              ),

              const SizedBox(height: 20),

              // Password Custom Field
              CustomMuiTextField(
                label: 'Password',
                controller: _passwordController,
                obscureText: _passwordObscured,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _passwordObscured = !_passwordObscured;
                    });
                  },
                  icon: Icon(
                    _passwordObscured
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.white70,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Existing forgot-password flow will be connected later.
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

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Log in',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Center(
                child: GestureDetector(
                  onTap: () {
                    Get.to(
                          () => const AddAccountRegisterScreen(),
                      binding: AuthBinding(),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(
                          text: 'Create account',
                          style: TextStyle(
                            color: Color(0xFF5394FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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

class CustomMuiTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final bool obscureText;
  final VoidCallback? onTap;
  final int? maxLength;
  final bool showRemainingCount;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const CustomMuiTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.readOnly = false,
    this.obscureText = false,
    this.onTap,
    this.maxLength,
    this.showRemainingCount = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white54,
        fontSize: 15,
      ),
      floatingLabelStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.white,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.5,
        ),
      ),
      counterText: showRemainingCount ? '' : null,
      suffixIcon: suffixIcon,
    );

    final textField = TextFormField(
      controller: controller,
      initialValue: initialValue,
      onChanged: onChanged,
      readOnly: readOnly,
      obscureText: obscureText,
      onTap: onTap,
      maxLength: maxLength,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: decoration,
    );

    if (maxLength != null && showRemainingCount && controller != null) {
      return Stack(
        alignment: Alignment.centerRight,
        children: [
          textField,
          Positioned(
            right: 12,
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller!,
              builder: (context, value, child) {
                final remaining = maxLength! - value.text.length;
                return Text(
                  '$remaining',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    return textField;
  }
}