import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/glass_button.dart';
import '../../../../shared/widgets/glass_container.dart';

class LoginScreen extends GetView<AuthController> {
  LoginScreen({super.key});

  final TextEditingController _emailPhoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
                child: Column(
                  children: [
                    _buildGradientText('MOVEM:', 36, true, letterSpacing: 3.0),
                    const SizedBox(height: 10),
                    _buildGradientText('YOUR LIFE, IN MOTION.', 20, false, letterSpacing: 1.5),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  child: Stack(
                      children: [

                        Positioned(
                          bottom: -100,
                          right: -100,
                          child: CustomPaint(
                            size: const Size(300, 300),
                            painter: ConcentricCirclesPainter(),
                          ),
                        ),

                        Positioned(top: 40, right: 30, child: _buildStarIcon()),
                        Positioned(top: 70, left: 40, child: _buildStarIcon(size: 20)),
                        Positioned(bottom: 120, left: 10, child: _buildStarIcon(size: 40)),
                        Positioned(bottom: 20, right: 80, child: _buildStarIcon(size: 30)),
                        Positioned(bottom: 10, left: -20, child: _buildStarIcon(size: 80, opacity: 0.1)),
                        Positioned(top: 150, right: -20, child: _buildStarIcon(size: 100, opacity: 0.1)),

                        SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: _buildGradientText(
                                        'WELCOME BACK!',
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
                                ],
                              ),
                              const SizedBox(height: 30),

                              _buildInputField(
                                label: 'EMAIL/PHONE NUMBER',
                                hint: 'Email/Phone Number',
                                controller: _emailPhoneController,
                              ),
                              const SizedBox(height: 20),

                              _buildInputField(
                                label: 'USERNAME',
                                hint: 'Username',
                                controller: _usernameController,
                              ),
                              const SizedBox(height: 20),

                              _buildInputField(
                                label: 'PASSWORD',
                                hint: 'Enter Password',
                                controller: _passwordController,
                                obscureText: true,
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () => Get.toNamed(AppRoutes.resetPassword),
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: Color(0xFF4C8DB3),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),

                              Center(
                                child: GlassButton(
                                  text: 'Login',
                                  onPressed: () => controller.login(
                                    _usernameController.text,
                                    _passwordController.text,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              Center(
                                child: GestureDetector(
                                  onTap: () => Get.toNamed(AppRoutes.register),
                                  child: RichText(
                                    text: const TextSpan(
                                      text: "Doesn't have an account yet? ",
                                      style: TextStyle(
                                        color: Color(0xFF031645),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'Sign up',
                                          style: TextStyle(
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
          13,
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
            style: const TextStyle(color: Color(0xFF031645), fontSize: 15),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFFA0AAB2),
                fontSize: 15,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStarIcon({double size = 24, double opacity = 0.4}) {
    return CustomPaint(

    );
  }
}

class StarPainter extends CustomPainter {
  final Color color;

  StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final path = Path();
    final halfWidth = size.width / 2;
    final halfHeight = size.height / 2;

    path.moveTo(halfWidth, 0);
    path.lineTo(halfWidth + size.width * 0.15, halfHeight - size.height * 0.15);
    path.lineTo(size.width, halfHeight - size.height * 0.1);
    path.lineTo(halfWidth + size.width * 0.2, halfHeight + size.height * 0.1);
    path.lineTo(halfWidth + size.width * 0.25, size.height);
    path.lineTo(halfWidth, halfHeight + size.height * 0.25);
    path.lineTo(halfWidth - size.width * 0.25, size.height);
    path.lineTo(halfWidth - size.width * 0.2, halfHeight + size.height * 0.1);
    path.lineTo(0, halfHeight - size.height * 0.1);
    path.lineTo(halfWidth - size.width * 0.15, halfHeight - size.height * 0.15);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ConcentricCirclesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4C8DB3).withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width, size.height);
    canvas.drawCircle(center, 120, paint);
    canvas.drawCircle(center, 140, paint);

    final paintThick = Paint()
      ..color = const Color(0xFF4C8DB3).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, 180, paintThick);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
