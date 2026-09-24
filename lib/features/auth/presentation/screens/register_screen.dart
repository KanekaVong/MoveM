import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/auth_glass_button.dart';
import '../widgets/auth_layout.dart';

class RegisterScreen extends GetView<AuthController> {
  RegisterScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController = TextEditingController();

  void _submit(AppLocalizations? l10n) {
    final password = _passwordController.text.trim();
    if (password != _retypePasswordController.text.trim()) {
      Get.snackbar(
        l10n?.errorTitle ?? 'Error',
        l10n?.passwordsDoNotMatch ?? 'Passwords do not match.',
      );
      return;
    }

    final username = _usernameController.text.trim();
    // The register API still requires a first and last name, which the new
    // form no longer asks for. Users can set their real name in Edit Profile.
    controller.register(
      _emailController.text.trim(),
      username,
      password,
      username,
      '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AuthLayout(
      title: l10n?.createAccountTitle ?? 'CREATE ACCOUNT',
      onBack: () => Get.back(),
      children: [
        AuthTextField(
          label: l10n?.emailOrPhone ?? 'EMAIL / PHONE NUMBER',
          hint: l10n?.emailPhoneHint ?? 'Email/Phone Number',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        AuthTextField(
          label: l10n?.username ?? 'USERNAME',
          hint: l10n?.setUsernameHint ?? 'Set Username',
          controller: _usernameController,
        ),
        AuthTextField(
          label: l10n?.password ?? 'PASSWORD',
          hint: l10n?.setPasswordHint ?? 'Set Password',
          controller: _passwordController,
          obscureText: true,
        ),
        AuthTextField(
          label: l10n?.retypePasswordLabel ?? 'RE-TYPE PASSWORD',
          hint: l10n?.retypePasswordHint ?? 'Re-Type Password',
          controller: _retypePasswordController,
          obscureText: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(l10n),
        ),
        const SizedBox(height: 12),
        Obx(() => AuthGlassButton(
              label: l10n?.registerAction ?? 'Register',
              isLoading: controller.isLoading,
              onPressed: () => _submit(l10n),
            )),
        const SizedBox(height: 10),
        AuthFooterLink(
          text: l10n?.haveAccountSignIn ?? 'Already have an account? Sign In',
          onTap: () => Get.back(),
        ),
      ],
    );
  }
}
