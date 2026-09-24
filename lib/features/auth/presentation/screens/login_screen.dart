import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/auth_glass_button.dart';
import '../widgets/auth_layout.dart';

class LoginScreen extends GetView<AuthController> {
  LoginScreen({super.key});

  final TextEditingController _emailPhoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submit() {
    controller.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AuthLayout(
      title: l10n?.welcomeBackTitle ?? 'WELCOME BACK',
      onBack: Navigator.of(context).canPop() ? () => Get.back() : null,
      children: [
        AuthTextField(
          label: l10n?.emailOrPhone ?? 'EMAIL / PHONE NUMBER',
          hint: l10n?.emailPhoneHint ?? 'Email/Phone Number',
          controller: _emailPhoneController,
          keyboardType: TextInputType.emailAddress,
        ),
        AuthTextField(
          label: l10n?.username ?? 'USERNAME',
          hint: l10n?.usernameHint ?? 'Username',
          controller: _usernameController,
        ),
        AuthTextField(
          label: l10n?.password ?? 'PASSWORD',
          hint: l10n?.enterPasswordHint ?? 'Enter Password',
          controller: _passwordController,
          obscureText: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Get.toNamed(AppRoutes.resetPassword),
            style: TextButton.styleFrom(foregroundColor: AuthColors.brandBlue),
            child: Text(l10n?.forgotPasswordQuestion ?? 'Forgot Password?'),
          ),
        ),
        const SizedBox(height: 12),
        Obx(() => AuthGlassButton(
              label: l10n?.loginAction ?? 'Login',
              isLoading: controller.isLoading,
              onPressed: _submit,
            )),
        const SizedBox(height: 10),
        AuthFooterLink(
          text: l10n?.noAccountSignUp ?? "Doesn't have an account yet? Sign Up",
          onTap: () => Get.toNamed(AppRoutes.register),
        ),
      ],
    );
  }
}
