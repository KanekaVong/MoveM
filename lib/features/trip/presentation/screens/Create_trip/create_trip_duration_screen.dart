import 'package:flutter/material.dart';

import 'package:movem/features/trip/presentation/models/create_trip_draft.dart';
import 'create_trip_stop_screen.dart';
import '../../controllers/trip_controller.dart';

class CreateTripDurationScreen extends StatefulWidget {
  final CreateTripDraft draft;
  final TripController tripController;

  const CreateTripDurationScreen({
    super.key,
    required this.draft,
    required this.tripController,
  });

  @override
  State<CreateTripDurationScreen> createState() =>
      _CreateTripDurationScreenState();
}

class _CreateTripDurationScreenState
    extends State<CreateTripDurationScreen> {
  late final TextEditingController _budgetController;

  bool _showBudget = false;

  @override
  void initState() {
    super.initState();

    _budgetController = TextEditingController(
      text: widget.draft.budget.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _setupDates() async {
    final now = DateTime.now();

    final range = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
      initialDateRange:
      widget.draft.startDate != null &&
          widget.draft.endDate != null
          ? DateTimeRange(
        start: widget.draft.startDate!,
        end: widget.draft.endDate!,
      )
          : null,
    );

    if (range == null) return;

    final days =
        range.end.difference(range.start).inDays + 1;

    setState(() {
      widget.draft.startDate = range.start;
      widget.draft.endDate = range.end;
      widget.draft.durationDays = days;
    });
  }

  void _increaseDuration() {
    setState(() {
      widget.draft.durationDays++;
    });

    _updateEndDate();
  }

  void _decreaseDuration() {
    if (widget.draft.durationDays <= 1) return;

    setState(() {
      widget.draft.durationDays--;
    });

    _updateEndDate();
  }

  void _updateEndDate() {
    if (widget.draft.startDate == null) return;

    setState(() {
      widget.draft.endDate =
          widget.draft.startDate!.add(
            Duration(
              days: widget.draft.durationDays - 1,
            ),
          );
    });
  }

  void _continue() {
    if (!_showBudget) {
      if (widget.draft.startDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select your trip dates.'),
          ),
        );
        return;
      }

      setState(() {
        _showBudget = true;
      });

      return;
    }

    widget.draft.budget =
        double.tryParse(_budgetController.text.trim()) ?? 0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateTripStopScreen(
          draft: widget.draft,
          tripController: widget.tripController,
        )
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Setup dates';

    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month]} ${date.day}, ${date.year}';
  }

  String _formatDateRange() {
    if (widget.draft.startDate == null) {
      return 'Setup dates';
    }

    if (widget.draft.endDate == null) {
      return _formatDate(widget.draft.startDate);
    }

    return '${_formatDate(widget.draft.startDate)} - '
        '${_formatDate(widget.draft.endDate)}';
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
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _showBudget
                    ? _buildBudgetStage()
                    : _buildDurationStage(),
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
            onTap: () {
              if (_showBudget) {
                setState(() {
                  _showBudget = false;
                });
                return;
              }

              Navigator.pop(context);
            },
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
          _buildStep(false),
          const SizedBox(width: 6),
          _buildStep(false),
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

  Widget _buildDurationStage() {
    return SingleChildScrollView(
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
            'Duration & Budget',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'How long and how much?',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 24),

          _buildDurationCard(),

          const SizedBox(height: 28),

          _buildContinueButton(),
        ],
      ),
    );
  }

  Widget _buildDurationCard() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trip Duration',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 22),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              _roundButton(
                icon: Icons.remove,
                onTap: _decreaseDuration,
              ),

              Column(
                children: [
                  Text(
                    '${widget.draft.durationDays}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(
                    'days',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              _roundButton(
                icon: Icons.add,
                onTap: _increaseDuration,
              ),
            ],
          ),

          const SizedBox(height: 22),

          InkWell(
            onTap: _setupDates,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF222B3D),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _formatDateRange(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white54,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetStage() {
    return SingleChildScrollView(
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
            'Duration & Budget',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'How long and how much?',
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
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Trip Budget',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 14),

                TextField(
                  controller: _budgetController,
                  keyboardType:
                  const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                  decoration:
                  const InputDecoration(
                    prefixText: '\$',
                    prefixStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                    border: InputBorder.none,
                    hintText: '0',
                    hintStyle: TextStyle(
                      color: Colors.white30,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    50,
                    100,
                    300,
                    500,
                    1000,
                  ].map(_BudgetChip.new).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          _buildContinueButton(),
        ],
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
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            widget.draft.activityName ??
                'Your Trip',
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
        ],
      ),
    );
  }

  Widget _roundButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
          color: Color(0xFF222B3D),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _continue,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          _showBudget ? 'CONTINUE' : 'CONTINUE',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

class _BudgetChip extends StatelessWidget {
  final int amount;

  const _BudgetChip(this.amount);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final parent = context
            .findAncestorStateOfType<
            _CreateTripDurationScreenState>();

        parent?._budgetController.text =
            amount.toString();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF222B3D),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '\$$amount',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}