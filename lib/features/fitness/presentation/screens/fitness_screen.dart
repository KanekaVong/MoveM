import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_images.dart';
import '../controllers/fitness_profile_controller.dart';
import 'fitness_dashboard_screen.dart';
import 'fitness_onboarding_screen.dart';

class FitnessScreen extends StatelessWidget {
  const FitnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<FitnessProfileController>()
        ? Get.find<FitnessProfileController>()
        : Get.put(FitnessProfileController());

    return Obx(() {
      if (controller.hasProfile.value) {
        return FitnessDashboardScreen(controller: controller);
      }
      return FitnessWelcomeScreen(controller: controller);
    });
  }
}

class FitnessWelcomeScreen extends StatefulWidget {
  final FitnessProfileController controller;
  const FitnessWelcomeScreen({super.key, required this.controller});

  @override
  State<FitnessWelcomeScreen> createState() => _FitnessWelcomeScreenState();
}

class _FitnessWelcomeScreenState extends State<FitnessWelcomeScreen> {
  double _dragPosition = 0.0;
  final double _buttonHeight = 56.0;
  bool _started = false;

  void _startSetup() {
    if (_started) return;
    _started = true;
    Get.to(
      () => FitnessOnboardingScreen(controller: widget.controller),
      fullscreenDialog: true,
    )?.then((_) {
      if (mounted) {
        setState(() {
          _dragPosition = 0;
          _started = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppImages.pic4,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.black.withValues(alpha: 0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.star_rate_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'MOVEM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'ONE STEP\nTODAY. A\nSTRONGER YOU\nTOMORROW.',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        height: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final sliderWidth = constraints.maxWidth * 0.6;
                      final maxDrag = sliderWidth - _buttonHeight;

                      return Center(
                        child: Container(
                          height: _buttonHeight,
                          width: sliderWidth,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(_buttonHeight / 2),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Text(
                                  'Swipe to start',
                                  style: TextStyle(
                                    color: Colors.black.withValues(alpha: 0.35),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: _dragPosition,
                                child: GestureDetector(
                                  onHorizontalDragUpdate: (details) {
                                    setState(() {
                                      _dragPosition += details.delta.dx;
                                      if (_dragPosition < 0) {
                                        _dragPosition = 0;
                                      } else if (_dragPosition > maxDrag) {
                                        _dragPosition = maxDrag;
                                      }
                                    });
                                  },
                                  onHorizontalDragEnd: (details) {
                                    if (_dragPosition > maxDrag * 0.8) {
                                      setState(() {
                                        _dragPosition = maxDrag;
                                      });
                                      _startSetup();
                                    } else {
                                      setState(() {
                                        _dragPosition = 0;
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: _buttonHeight,
                                    height: _buttonHeight,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 6,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'GO',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
