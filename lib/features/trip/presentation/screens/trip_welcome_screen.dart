import 'package:flutter/material.dart';

class TripWelcomeScreen extends StatefulWidget {
  final VoidCallback onCompleted;

  const TripWelcomeScreen({
    super.key,
    required this.onCompleted,
  });

  @override
  State<TripWelcomeScreen> createState() => _TripWelcomeScreenState();
}

class _TripWelcomeScreenState extends State<TripWelcomeScreen> {
  double _dragPosition = 0.0;
  final double _buttonHeight = 56.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/bayon_bg.png',
            fit: BoxFit.cover,
          ),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.7),
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
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rate_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 6),
                      const Text(
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

                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          'EXPLORE\nTHE WORLD\nWITH US',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            height: 1.1,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Move with purpose, Always',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Set width
                      final sliderWidth = constraints.maxWidth * 0.6;
                      final maxDrag = sliderWidth - _buttonHeight;

                      return Center(
                        child: Container(
                          height: _buttonHeight,
                          width: sliderWidth, //  Width Applied
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(_buttonHeight / 2),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Text(
                                  "Slide to explore",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.35),
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

                                      _onSwipeCompleted();
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

  void _onSwipeCompleted() {
    widget.onCompleted();
  }
}