import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_images.dart';
import '../../data/models/push_up_session_model.dart';
import '../../data/models/solo_challenge_model.dart';
import 'push_up_summary_screen.dart';

class PushUpWorkoutScreen extends StatefulWidget {
  final SoloChallengeModel challenge;

  const PushUpWorkoutScreen({
    super.key,
    required this.challenge,
  });

  @override
  State<PushUpWorkoutScreen> createState() => _PushUpWorkoutScreenState();
}

class _PushUpWorkoutScreenState extends State<PushUpWorkoutScreen>
    with SingleTickerProviderStateMixin {
  int _currentSet = 2; // Default to 2/4 matching screenshot or start at 1
  int _currentReps = 7; // Default to 7 reps matching screenshot or start at 0
  int _totalRepsCompleted = 0;
  int _secondsElapsed = 314; // 5:14 matching screenshot
  bool _isPaused = false;
  Timer? _durationTimer;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _startDurationTimer();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _startDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _incrementRep() {
    if (_isPaused) return;

    setState(() {
      _currentReps++;
      _totalRepsCompleted++;
    });

    if (_currentReps >= widget.challenge.repsPerSet) {
      _handleSetCompletion();
    }
  }

  void _resetReps() {
    setState(() {
      _currentReps = 0;
    });
  }

  void _handleSetCompletion() {
    if (_currentSet < widget.challenge.sets) {
      _showSetCompletedDialog();
    } else {
      _showWorkoutFinishedDialog();
    }
  }

  void _showSetCompletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF38BDF8), width: 1.5),
        ),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF38BDF8), size: 28),
            SizedBox(width: 10),
            Text(
              'Set Complete!',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Great job! You finished Set $_currentSet of ${widget.challenge.sets} (${widget.challenge.repsPerSet} Reps). Take a quick breath and get ready for Set ${_currentSet + 1}.',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _currentSet++;
                _currentReps = 0;
              });
            },
            child: const Text(
              'Start Next Set',
              style: TextStyle(
                color: Color(0xFF38BDF8),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showWorkoutFinishedDialog() {
    _durationTimer?.cancel();
    final session = PushUpSession(
      challengeId: widget.challenge.id,
      challengeName: widget.challenge.name,
      targetReps: widget.challenge.sets * widget.challenge.repsPerSet,
      totalReps: _totalRepsCompleted > 0
          ? _totalRepsCompleted
          : widget.challenge.sets * widget.challenge.repsPerSet,
      sets: widget.challenge.sets,
      isCompleted: true,
      startTime: DateTime.now().subtract(Duration(seconds: _secondsElapsed)),
      endTime: DateTime.now(),
    );

    Get.off(
      () => PushUpSummaryScreen(
        session: session,
        challenge: widget.challenge,
      ),
      transition: Transition.fadeIn,
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString();
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _durationTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _incrementRep,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background push up exercise image
            Image.asset(
              AppImages.pushupExerciseBg,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFF0F172A),
              ),
            ),

            // AI Pose Skeleton Overlay
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return CustomPaint(
                  size: size,
                  painter: _PoseSkeletonPainter(scale: _pulseAnimation.value),
                );
              },
            ),

            // Top Bar
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Circular Back Button
                      GestureDetector(
                        onTap: () {
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

                      // Center Reps Pill [ 7 REPS (↺) ]
                      Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9EA3AE).withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$_currentReps',
                              style: const TextStyle(
                                color: Color(0xFF0A1E3F),
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'REPS',
                              style: TextStyle(
                                color: Color(0xFF0A1E3F),
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: _resetReps,
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF0A1E3F),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.refresh_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Dummy invisible box for balanced spacing
                      const SizedBox(width: 44),
                    ],
                  ),
                ),
              ),
            ),

            // Tap hint indicator
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.touch_app_rounded, color: Colors.white70, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Tap screen to count rep',
                        style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Frosted Stats Card [ SET 2/4 | DURATION 5:14 (||) | GOAL 15 ]
            Positioned(
              left: 20,
              right: 20,
              bottom: 34,
              child: SafeArea(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.38),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // SET Column
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'SET',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$_currentSet/${widget.challenge.sets}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Divider 1
                          Container(
                            width: 1,
                            height: 50,
                            color: Colors.white.withValues(alpha: 0.2),
                          ),

                          // DURATION Column with Pause Button
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'DURATION',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _formatDuration(_secondsElapsed),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                const SizedBox(height: 6),
                                GestureDetector(
                                  onTap: _togglePause,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withValues(alpha: 0.9),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.2),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Icon(
                                        _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                                        color: const Color(0xFF0A1E3F),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Divider 2
                          Container(
                            width: 1,
                            height: 50,
                            color: Colors.white.withValues(alpha: 0.2),
                          ),

                          // GOAL Column
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'GOAL',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${widget.challenge.repsPerSet}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PoseSkeletonPainter extends CustomPainter {
  final double scale;

  _PoseSkeletonPainter({required this.scale});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Joint landmark coordinates calibrated for the Great Wall athlete photo
    final head = Offset(0.79 * w, 0.58 * h);
    final neck = Offset(0.66 * w, 0.58 * h);
    final chest = Offset(0.60 * w, 0.68 * h);
    final lowerChest = Offset(0.40 * w, 0.67 * h);
    final elbow = Offset(0.36 * w, 0.64 * h);
    final rightWrist = Offset(0.43 * w, 0.73 * h);
    final leftWrist = Offset(0.81 * w, 0.72 * h);
    final hip = Offset(0.30 * w, 0.69 * h);
    final knee = Offset(0.20 * w, 0.70 * h);
    final ankle = Offset(0.07 * w, 0.69 * h);

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;

    void drawSegment(Offset p1, Offset p2) {
      canvas.drawLine(p1, p2, glowPaint);
      canvas.drawLine(p1, p2, linePaint);
    }

    // Connect anatomical lines
    drawSegment(head, neck);
    drawSegment(neck, chest);
    drawSegment(neck, leftWrist);
    drawSegment(neck, lowerChest);
    drawSegment(chest, leftWrist);
    drawSegment(chest, lowerChest);
    drawSegment(chest, rightWrist);
    drawSegment(lowerChest, elbow);
    drawSegment(elbow, rightWrist);
    drawSegment(lowerChest, hip);
    drawSegment(hip, knee);
    drawSegment(knee, ankle);
    drawSegment(elbow, hip);

    final jointFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final jointGlow = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final joints = [
      head,
      neck,
      chest,
      lowerChest,
      elbow,
      rightWrist,
      leftWrist,
      hip,
      knee,
      ankle,
    ];

    for (final j in joints) {
      canvas.drawCircle(j, 6.0 * scale, jointGlow);
      canvas.drawCircle(j, 3.5, jointFill);
    }
  }

  @override
  bool shouldRepaint(covariant _PoseSkeletonPainter oldDelegate) {
    return oldDelegate.scale != scale;
  }
}
