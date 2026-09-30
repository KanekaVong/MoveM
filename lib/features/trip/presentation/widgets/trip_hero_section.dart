import 'package:flutter/material.dart';
import 'clear_glass_container.dart';

class TripHeroSection extends StatelessWidget {
  final VoidCallback onCreateTrip;

  const TripHeroSection({
    super.key,
    required this.onCreateTrip,
  });

  static const Color backgroundColor = Color(0xFF0B101D);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.58,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(42),
          bottomRight: Radius.circular(42),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(
              'assets/images/everest_bg.png',
              fit: BoxFit.cover,
            ),

            // Dark overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.black.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                  stops: const [
                    0.0,
                    0.45,
                    1.0,
                  ],
                ),
              ),
            ),

            // Fade image into page background
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 180,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(0x660B101D),
                      backgroundColor,
                    ],
                    stops: [
                      0.0,
                      0.55,
                      1.0,
                    ],
                  ),
                ),
              ),
            ),

            // Hero content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  20,
                  24,
                  32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 45),

                    const Text(
                      'WHAT’S\nYOUR\nNEXT\nPLAN?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        height: 1.02,
                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(height: 35),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'ENHANCE YOUR\n'
                                'JOURNEY WITH US.',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              height: 1.2,
                            ),
                          ),

                          const SizedBox(height: 22),

                          Center(
                            child: ClearGlassContainer(
                              borderRadius: 30,
                              blur: 18,
                              backgroundColor: const Color(0xFF1E2638),
                              backgroundOpacity: 0.72,
                              borderColor: const Color(0xFF384358),
                              borderOpacity: 1,
                              borderWidth: 1,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(30),
                                  onTap: onCreateTrip,
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 14,
                                    ),
                                    child: Text(
                                      'PLAN YOUR JOURNEY',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}