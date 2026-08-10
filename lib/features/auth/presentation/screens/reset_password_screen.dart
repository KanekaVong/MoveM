import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../../shared/widgets/glass_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final AuthController controller = Get.find<AuthController>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  int _secondsLeft = 0;
  bool _isTimerActive = false;
  bool _timerFinished = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_isTimerActive) return;
    
    setState(() {
      _isTimerActive = true;
      _timerFinished = false;
      _secondsLeft = 60;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    });
  }

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
              // Top Section (Logo)
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
              
              // Bottom Section (Form)
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
                            painter: VerifyConcentricCirclesPainter(),
                          ),
                        ),
                        // Stars around the view
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
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back, color: Color(0xFF4C8DB3)),
                                    onPressed: () => Get.back(),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: _buildGradientText(
                                        'RESET PASSWORD', 
                                        24, 
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
                                  const SizedBox(width: 48), // Balance the row
                                ],
                              ),
                              const SizedBox(height: 30),
                              
                              _buildInputField(
                                label: 'EMAIL ADDRESS',
                                hint: 'Enter your email',
                                controller: _emailController,
                              ),
                              const SizedBox(height: 20),
                              
                              _buildInputField(
                                label: 'OTP CODE',
                                hint: 'Enter 6-digit OTP',
                                controller: _otpController,
                                keyboardType: TextInputType.number,
                                suffixIcon: TextButton(
                                  onPressed: _isTimerActive ? null : () {
                                    if (_emailController.text.isNotEmpty) {
                                      controller.forgotPassword(_emailController.text);
                                      _startTimer();
                                    } else {
                                      Get.snackbar('Error', 'Please enter your email first', 
                                        backgroundColor: Colors.redAccent, colorText: Colors.white);
                                    }
                                  },
                                  child: Text(
                                    _isTimerActive 
                                      ? '$_secondsLeft s'
                                      : (_timerFinished ? 'Resend' : 'Send OTP'),
                                    style: TextStyle(
                                      color: _isTimerActive ? const Color(0xFFA0AAB2) : const Color(0xFF4C8DB3),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              
                              _buildInputField(
                                label: 'NEW PASSWORD',
                                hint: 'Enter new password',
                                controller: _newPasswordController,
                                obscureText: true,
                              ),
                              const SizedBox(height: 40),
                              
                              Center(
                                child: GlassButton(
                                  text: 'Reset Password',
                                  onPressed: () {
                                    if (_emailController.text.isNotEmpty && 
                                        _otpController.text.isNotEmpty && 
                                        _newPasswordController.text.isNotEmpty) {
                                      controller.resetPassword(
                                        _emailController.text,
                                        _otpController.text,
                                        _newPasswordController.text,
                                      );
                                    } else {
                                      Get.snackbar('Error', 'Please fill all fields', 
                                        backgroundColor: Colors.redAccent, colorText: Colors.white);
                                    }
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
    TextInputType keyboardType = TextInputType.text,
    Widget? trailing,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildGradientText(
              label,
              13,
              true,
              colors: [const Color(0xFF91C5E2), const Color(0xFF4C8DB3)],
              letterSpacing: 1.0,
            ),
            if (trailing != null) trailing,
          ],
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
            keyboardType: keyboardType,
            style: const TextStyle(color: Color(0xFF031645), fontSize: 15),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFFA0AAB2),
                fontSize: 15,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStarIcon({double size = 24, double opacity = 0.4}) {
    return const SizedBox.shrink(); // Using placeholder for custom painter
  }
}

class VerifyConcentricCirclesPainter extends CustomPainter {
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
