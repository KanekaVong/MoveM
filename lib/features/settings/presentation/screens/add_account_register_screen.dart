import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:movem/features/auth/presentation/controllers/auth_controller.dart';

class AddAccountRegisterScreen extends StatefulWidget {
  const AddAccountRegisterScreen({super.key});

  @override
  State<AddAccountRegisterScreen> createState() =>
      _AddAccountRegisterScreenState();
}

class _AddAccountRegisterScreenState
    extends State<AddAccountRegisterScreen> {
  final AuthController _authController = Get.find<AuthController>();

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _usernameController =
  TextEditingController();

  final TextEditingController _firstNameController =
  TextEditingController();

  final TextEditingController _lastNameController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _passwordObscured = true;
  bool _confirmPasswordObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
          decoration: _inputDecoration(
            hint: hint,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final username = _usernameController.text.trim();
    final firstname = _firstNameController.text.trim();
    final lastname = _lastNameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty ||
        username.isEmpty ||
        firstname.isEmpty ||
        lastname.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields.',
      );
      return;
    }

    if (password.length < 8) {
      Get.snackbar(
        'Error',
        'Password must be at least 8 characters.',
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'Error',
        'Passwords do not match.',
      );
      return;
    }

    await _authController.register(
      email,
      username,
      password,
      firstname,
      lastname,
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
          'Create account',
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
                'Create another account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Create a new MoveM account on this device.',
                style: TextStyle(
                  color: Color(0xFFA0AAB2),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              _buildField(
                label: 'Email',
                hint: 'Enter your email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              _buildField(
                label: 'Username',
                hint: 'Choose a username',
                controller: _usernameController,
              ),

              const SizedBox(height: 20),

              _buildField(
                label: 'First Name',
                hint: 'Enter your first name',
                controller: _firstNameController,
              ),

              const SizedBox(height: 20),

              _buildField(
                label: 'Last Name',
                hint: 'Enter your last name',
                controller: _lastNameController,
              ),

              const SizedBox(height: 20),

              _buildField(
                label: 'Password',
                hint: 'Enter password',
                controller: _passwordController,
                obscureText: _passwordObscured,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _passwordObscured =
                      !_passwordObscured;
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

              const SizedBox(height: 20),

              _buildField(
                label: 'Confirm Password',
                hint: 'Confirm password',
                controller: _confirmPasswordController,
                obscureText: _confirmPasswordObscured,
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
                  onPressed: _register,
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
                    'Create account',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}