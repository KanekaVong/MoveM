import 'package:flutter/material.dart';

import 'create_trip_location_screen.dart';

import 'package:movem/features/trip/presentation/models/create_trip_draft.dart';
import '../../controllers/trip_controller.dart';

class CreateTripNameScreen extends StatefulWidget {
  final CreateTripDraft draft;
  final TripController tripController;

  const CreateTripNameScreen({
    super.key,
    required this.draft,
    required this.tripController,
  });

  @override
  State<CreateTripNameScreen> createState() => _CreateTripNameScreenState();
}

class _CreateTripNameScreenState extends State<CreateTripNameScreen> {
  late final TextEditingController _tripNameController;

  @override
  void initState() {
    super.initState();

    _tripNameController = TextEditingController(
      text: widget.draft.activityName ?? '',
    );
  }

  @override
  void dispose() {
    _tripNameController.dispose();
    super.dispose();
  }

  void _continue() {
    final name = _tripNameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your trip name.'),
        ),
      );
      return;
    }

    widget.draft.activityName = name;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateTripLocationScreen(
          draft: widget.draft,
          tripController: widget.tripController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Image ends here.
    final imageHeight = screenHeight * 0.50;

    // Form panel begins slightly BEFORE image ends,
    // creating the overlap effect.
    final formTop = screenHeight * 0.43;

    return Scaffold(
      backgroundColor: const Color(0xFF0B101D),
      body: Stack(
        children: [
          // ==================================================
          // BACKGROUND IMAGE
          // ==================================================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: imageHeight,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/create_new_trip_bg.png',
                    fit: BoxFit.cover,
                  ),

                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.45),
                          Colors.transparent,
                          Colors.black.withOpacity(0.15),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ==================================================
          // HEADER + STEP INDICATOR
          // ==================================================
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                14,
                20,
                0,
              ),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.chevron_left_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Create New Trip',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Step indicator
                  Row(
                    children: [
                      _buildStep(active: true),
                      const SizedBox(width: 6),
                      _buildStep(active: false),
                      const SizedBox(width: 6),
                      _buildStep(active: false),
                      const SizedBox(width: 6),
                      _buildStep(active: false),
                      const SizedBox(width: 6),
                      _buildStep(active: false),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Current step name
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'NAME',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ==================================================
          // FORM PANEL
          // ==================================================
          Positioned(
            top: formTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: screenWidth,
              decoration: const BoxDecoration(
                color: Color(0xFF0B101D),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 18,
                    offset: Offset(0, -6),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  30,
                  24,
                  32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question
                    const Text(
                      "What's the Trip Called?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Hint
                    const Text(
                      'Give your adventure a name',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Input
                    TextField(
                      controller: _tripNameController,
                      textInputAction: TextInputAction.done,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter trip name',
                        hintStyle: const TextStyle(
                          color: Colors.white30,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF171E2D),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 17,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Continue
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _continue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(28),
                          ),
                        ),
                        child: const Text(
                          'CONTINUE',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required bool active,
  }) {
    return Expanded(
      child: Container(
        height: 3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: active
              ? Colors.white
              : Colors.white24,
        ),
      ),
    );
  }
}