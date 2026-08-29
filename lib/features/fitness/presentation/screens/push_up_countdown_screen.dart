import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_images.dart';
import '../../data/models/solo_challenge_model.dart';
import 'push_up_detection_screen.dart';

class PushUpCountdownScreen extends StatefulWidget {
  final SoloChallengeModel challenge;

  const PushUpCountdownScreen({
    super.key,
    required this.challenge,
  });

  @override
  State<PushUpCountdownScreen> createState() => _PushUpCountdownScreenState();
}

class _PushUpCountdownScreenState extends State<PushUpCountdownScreen>
    with SingleTickerProviderStateMixin {
  int _countdown = 5;
  Timer? _timer;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    _animController.forward();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
        _animController.reset();
        _animController.forward();
      } else {
        _timer?.cancel();
        _proceedToWorkout();
      }
    });
  }

  void _proceedToWorkout() {
    _timer?.cancel();
    Get.off(
      () => PushUpDetectionScreen(challenge: widget.challenge),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            AppImages.pushupExerciseBg,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFF0F172A),
            ),
          ),

          // Subtle gradient overlay for readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.4),
                ],
              ),
            ),
          ),

          // Top Bar with Back Button
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    _timer?.cancel();
                    Get.back();
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.35),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Center Countdown Widget
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.75),
                  border: Border.all(
                    color: const Color(0xFF0A1E3F),
                    width: 9,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '$_countdown',
                    style: const TextStyle(
                      color: Color(0xFF0A1E3F),
                      fontSize: 54,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom "Skip" Button
          Positioned(
            left: 24,
            right: 24,
            bottom: 40,
            child: SafeArea(
              child: GestureDetector(
                onTap: _proceedToWorkout,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8E95A5).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.35),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
