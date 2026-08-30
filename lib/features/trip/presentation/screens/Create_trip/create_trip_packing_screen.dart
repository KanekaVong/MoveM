import 'package:flutter/material.dart';

import 'package:movem/features/trip/presentation/models/create_trip_draft.dart';
import '../trip_detail_screen.dart';

import '../../controllers/trip_controller.dart';

class CreateTripPackingScreen extends StatefulWidget {
  final CreateTripDraft draft;
  final TripController tripController;


  const CreateTripPackingScreen({
    super.key,
    required this.draft,
    required this.tripController,
  });

  @override
  State<CreateTripPackingScreen> createState() =>
      _CreateTripPackingScreenState();
}

class _CreateTripPackingScreenState
    extends State<CreateTripPackingScreen> {
  void _addPackingItem() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF171E2D),
          title: const Text(
            'Add Packing Item',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'e.g. Passport',
              hintStyle: const TextStyle(
                color: Colors.white30,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Colors.white12,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Colors.white54,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                final item = controller.text.trim();

                if (item.isNotEmpty) {
                  setState(() {
                    widget.draft.packingItems.add(item);
                  });
                }

                Navigator.pop(context);
              },
              child: const Text('ADD'),
            ),
          ],
        );
      },
    ).then((_) {
      controller.dispose();
    });
  }

  void _removeItem(int index) {
    setState(() {
      widget.draft.packingItems.removeAt(index);
    });
  }

  void _continue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TripDetailScreen(
          draft: widget.draft,
          tripController: widget.tripController,
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B101D),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildStepIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTripHeader(),

                    const SizedBox(height: 28),

                    const Text(
                      'Need help with what to pack?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Check what you and your friend needs to pack!',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF171E2D),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: Colors.white12,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.backpack_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Trip Essentials+',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _addPackingItem,
                                child: const Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          if (widget.draft.packingItems.isEmpty)
                            GestureDetector(
                              onTap: _addPackingItem,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF222B3D),
                                  borderRadius:
                                  BorderRadius.circular(14),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white54,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'List packing items...',
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            Column(
                              children: [
                                for (int i = 0;
                                i <
                                    widget
                                        .draft
                                        .packingItems
                                        .length;
                                i++)
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(
                                      bottom: 10,
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      padding:
                                      const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF222B3D,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(
                                          14,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons
                                                .check_circle_outline,
                                            color: Colors.white70,
                                            size: 19,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              widget
                                                  .draft
                                                  .packingItems[i],
                                              style:
                                              const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () =>
                                                _removeItem(i),
                                            icon: const Icon(
                                              Icons.close,
                                              color:
                                              Colors.white38,
                                              size: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                          const SizedBox(height: 10),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: _addPackingItem,
                              icon: const Icon(Icons.add),
                              label: const Text(
                                'Add item',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

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
                          'READY',
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
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        14,
        20,
        8,
      ),
      child: Row(
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
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      child: Row(
        children: [
          _buildStep(true),
          const SizedBox(width: 6),
          _buildStep(true),
          const SizedBox(width: 6),
          _buildStep(true),
          const SizedBox(width: 6),
          _buildStep(true),
          const SizedBox(width: 6),
          _buildStep(true),
        ],
      ),
    );
  }

  Widget _buildStep(bool active) {
    return Expanded(
      child: Container(
        height: 3,
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.white24,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildTripHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF151C2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.draft.activityName ?? 'Your Trip',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.draft.locationName ??
                widget.draft.destination ??
                'Location',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.draft.durationDays} '
                '${widget.draft.durationDays == 1 ? 'day' : 'days'}',
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}