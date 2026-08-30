import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/glass_button.dart';

class RegisterScreen extends GetView<AuthController> {
  RegisterScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF001743),
              Color(0xFF0F3784),
              Color(0xFF3271E8),
            ],
            stops: [0.0, 0.52, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 25.0),
                  child: Column(
                    children: [
                      _buildGradientText('MOVEM:', 36, true, letterSpacing: 3.0),
                      const SizedBox(height: 10),
                      _buildGradientText('YOUR LIFE, IN MOTION.', 20, false, letterSpacing: 1.5),
                    ],
                  ),
                ),
              ),

              Positioned.fill(
                child: CustomScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 130),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, -3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.arrow_back, color: Color(0xFF4C8DB3)),
                                          onPressed: () => Get.back(),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: _buildGradientText(
                                              l10n?.createAccountTitle ?? 'CREATE ACCOUNT',
                                              26,
                                              true,
                                              colors: [
                                                Colors.white,
                                                const Color(0xFF86C8E6),
                                                const Color(0xFF4081AB)
                                              ],
                                              stops: const [0.0, 0.4, 1.0],
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 48),
                                      ],
                                    ),
                                    const SizedBox(height: 30),

                                    _buildInputField(
                                      label: l10n?.firstName ?? 'FIRST NAME',
                                      hint: l10n?.firstName ?? 'First Name',
                                      controller: _firstnameController,
                                    ),
                                    const SizedBox(height: 20),

                                    _buildInputField(
                                      label: l10n?.lastName ?? 'LAST NAME',
                                      hint: l10n?.lastName ?? 'Last Name',
                                      controller: _lastnameController,
                                    ),
                                    const SizedBox(height: 20),

                                    _buildInputField(
                                      label: l10n?.email ?? 'EMAIL',
                                      hint: l10n?.email ?? 'Email',
                                      controller: _emailController,
                                    ),
                                    const SizedBox(height: 20),

                                    _buildInputField(
                                      label: l10n?.username ?? 'USERNAME',
                                      hint: l10n?.username ?? 'Username',
                                      controller: _usernameController,
                                    ),
                                    const SizedBox(height: 20),

                                    _buildInputField(
                                      label: l10n?.password ?? 'PASSWORD',
                                      hint: l10n?.password ?? 'Password',
                                      controller: _passwordController,
                                      obscureText: true,
                                    ),
                                    const SizedBox(height: 30),

                                    Center(
                                      child: GlassButton(
                                        text: l10n?.registerBtn ?? 'Sign Up',
                                        onPressed: () {
                                          controller.register(
                                            _emailController.text.trim(),
                                            _usernameController.text.trim(),
                                            _passwordController.text.trim(),
                                            _firstnameController.text.trim(),
                                            _lastnameController.text.trim(),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientText(
    String text,
    double fontSize,
    bool isBold, {
    List<Color>? colors,
    List<double>? stops,
    double letterSpacing = 1.0,
    bool isItalic = true,
  }) {
    final textStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: isBold ? FontWeight.w900 : FontWeight.w400,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      letterSpacing: letterSpacing,
    );

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            text,
            style: textStyle.copyWith(
              color: Colors.transparent,
              shadows: [
                Shadow(
                  color: const Color(0xFF4C8DB3).withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => LinearGradient(
            colors: colors ?? [Colors.white, const Color(0xFF90CDEC)],
            stops: stops,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(bounds),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              text,
              style: textStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGradientText(
          label,
          14,
          true,
          colors: [const Color(0xFF91C5E2), const Color(0xFF4C8DB3)],
          letterSpacing: 1.0,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF91C5E2).withValues(alpha: 0.6),
                offset: const Offset(0, 2),
                blurRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(color: Color(0xFF031645), fontSize: 12),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFFA0AAB2),
                fontSize: 12,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}

