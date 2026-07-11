import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movem/l10n/app_localizations.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => controller.login("", ""),
          child: Text(localize.login),
        ),
      ),
    );
  }
}
