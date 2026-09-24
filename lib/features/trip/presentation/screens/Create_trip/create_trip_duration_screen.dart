import 'package:flutter/material.dart';
import 'package:movem/l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../controllers/create_trip_controller.dart';
import 'create_trip_stop_screen.dart';
import 'package:movem/features/trip/presentation/widgets/create_trip_component.dart';

class CreateTripDurationScreen extends StatefulWidget {
  const CreateTripDurationScreen({
    super.key,
  });

  @override
  State<CreateTripDurationScreen> createState() =>
      _CreateTripDurationScreenState();
}

class _CreateTripDurationScreenState
    extends State<CreateTripDurationScreen> {

  final CreateTripController controller = Get.find<CreateTripController>();

  late final TextEditingController _budgetController;

  bool _showBudget = false;

  TimeOfDay _startTime = const TimeOfDay(
    hour: 9,
    minute: 0,
  );

  TimeOfDay _endTime = const TimeOfDay(
    hour: 17,
    minute: 0,
  );

  @override
  void initState() {
    super.initState();

    final draft = controller.currentDraft;

    if (draft.startDate != null) {
      _startTime = TimeOfDay.fromDateTime(
        draft.startDate!,
      );
    }

    if (draft.endDate != null) {
      _endTime = TimeOfDay.fromDateTime(
        draft.endDate!,
      );
    }

    _budgetController = TextEditingController(
      text: controller.currentDraft.budget > 0
          ? controller.currentDraft.budget.toStringAsFixed(0)
          : '',
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
      controller.currentDraft.startDate != null &&
          controller.currentDraft.endDate != null
          ? DateTimeRange(
        start: controller.currentDraft.startDate!,
        end: controller.currentDraft.endDate!,
      )
          : null,
    );

    if (range == null) return;

    final startTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );

    if (startTime == null) return;

    final endTime = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );

    if (endTime == null) return;


    setState(() {
      _startTime = startTime;
      _endTime = endTime;

    });

    final startDateTime = DateTime(
      range.start.year,
      range.start.month,
      range.start.day,
      startTime.hour,
      startTime.minute,
    );

    final endDateTime = DateTime(
      range.end.year,
      range.end.month,
      range.end.day,
      endTime.hour,
      endTime.minute,
    );

    controller.setDates(
      startDate: startDateTime,
      endDate: endDateTime,
    );
  }

  void _increaseDuration() {
    controller.increaseDuration();
  }

  void _decreaseDuration() {
    controller.decreaseDuration();
  }

  void _continue() {
    final l10n = AppLocalizations.of(context)!;

    if (!_showBudget) {
      if (controller.currentDraft.startDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.tripDurationRequired,
            ),
          ),
        );
        return;
      }

      setState(() {
        _showBudget = true;
      });

      return;
    }

    controller.setBudget(
      double.tryParse(
        _budgetController.text.trim(),
      ) ?? 0,
    );

    Get.to(
          () => const CreateTripStopScreen(),
    );
  }

  String _formatDate(BuildContext context, DateTime? date,) {
    if (date == null) {
      return AppLocalizations.of(context)!
          .tripSetupDates;
    }

    return MaterialLocalizations.of(context)
        .formatMediumDate(date);
  }

  String _formatDateRange(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;
    final draft = controller.currentDraft;

    if (draft.startDate == null) {
      return l10n.tripSetupDates;
    }

    final startDate = _formatDate(context, draft.startDate,
    );

    if (draft.endDate == null) {
      return startDate;
    }

    final endDate = _formatDate(context, draft.endDate,);

    final startTime = _startTime.format(context);
    final endTime = _endTime.format(context);

    return '$startDate – $endDate\n'
        '$startTime – $endTime';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final keyboardOpen = keyboardHeight > 0;

    final imageHeight = screenHeight * 0.50;
    final panelTop = keyboardOpen
        ? screenHeight * 0.20
        : screenHeight * 0.43;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: isDark
          ? CreateTripColors.darkBackground
          : CreateTripColors.lightBackground,
      body: Stack(
        children: [
          // background image
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

          // HEADER
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CreateTripHeader(
                    title: l10n.createNewTrip,
                    onBack: () {
                      if (_showBudget) {
                        setState(() {
                          _showBudget = false;
                        });
                        return;
                      }
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 8),
                  const CreateTripStepIndicator(activeIndex: 2),
                  const SizedBox(height: 10),
                  Text(
                    controller.currentDraft.activityName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: CreateTripFonts.condensed,
                      fontFamilyFallback: CreateTripFonts.khmerFallback,
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    controller.currentDraft.locationName ??
                        controller.currentDraft.destination ??
                        '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: CreateTripFonts.condensed,
                      fontFamilyFallback: CreateTripFonts.khmerFallback,
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // form panel
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            top: panelTop,
            left: 0,
            right: 0,
            bottom: keyboardHeight,
            child: CreateTripFormPanel(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _showBudget
                      ? _buildBudgetStage()
                      : _buildDurationStage(),
                ),
              ],
              bottomAction: CreateTripBottomButton(
                text: l10n.continueButton,
                onPressed: _continue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationStage() {
    final l10n = AppLocalizations.of(context)!;

    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark
        ? Colors.white
        : CreateTripColors.lightText;

    final secondaryColor = isDark
        ? Colors.white60
        : const Color(0xFF6B7280);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.tripDurationTitle,
          style: TextStyle(
            fontFamily: CreateTripFonts.condensed,
            fontFamilyFallback:
            CreateTripFonts.khmerFallback,
            color: textColor,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          l10n.tripDurationSubtitle,
          style: TextStyle(
            fontFamily: CreateTripFonts.condensed,
            fontFamilyFallback:
            CreateTripFonts.khmerFallback,
            color: secondaryColor,
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 24),

        _buildDurationCard(),
      ],
    );
  }

  Widget _buildDurationCard() {
    final l10n = AppLocalizations.of(context)!;

    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark
        ? Colors.white
        : CreateTripColors.lightText;

    final cardColor = isDark
        ? const Color(0xFF171E2D)
        : const Color(0xFFF1F3F6);

    final controlColor = isDark
        ? const Color(0xFF222B3D)
        : Colors.white;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white12
              : CreateTripColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tripDurationLabel,
            style: TextStyle(
              fontFamily: CreateTripFonts.condensed,
              fontFamilyFallback:
              CreateTripFonts.khmerFallback,
              color: textColor,
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
                backgroundColor: controlColor,
                iconColor: textColor,
              ),

              Column(
                children: [
                  Obx(
                        () => Text(
                      '${controller.draft.value.durationDays}',
                      style: TextStyle(
                        fontFamily: CreateTripFonts.condensed,
                        fontFamilyFallback: CreateTripFonts.khmerFallback,
                        color: textColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  Text(
                    l10n.tripDaysLabel,
                    style: TextStyle(
                      fontFamily:
                      CreateTripFonts.condensed,
                      fontFamilyFallback:
                      CreateTripFonts.khmerFallback,
                      color: isDark
                          ? Colors.white54
                          : const Color(0xFF6B7280),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              _roundButton(
                icon: Icons.add,
                onTap: _increaseDuration,
                backgroundColor: controlColor,
                iconColor: textColor,
              ),
            ],
          ),

          const SizedBox(height: 22),

          InkWell(
            onTap: _setupDates,
            borderRadius:
            BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: controlColor,
                borderRadius:
                BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    color: textColor,
                    size: 20,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Obx(
                          () => Text(
                        _formatDateRange(context),
                        style: TextStyle(
                          fontFamily: CreateTripFonts.condensed,
                          fontFamilyFallback:
                          CreateTripFonts.khmerFallback,
                          color: textColor,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),

                  Icon(
                    Icons.chevron_right_rounded,
                    color: isDark
                        ? Colors.white54
                        : const Color(0xFF6B7280),
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
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? Colors.white
        : CreateTripColors.lightText;

    final secondaryColor = isDark
        ? Colors.white60
        : const Color(0xFF6B7280);

    final cardColor = isDark
        ? const Color(0xFF171E2D)
        : const Color(0xFFF1F3F6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.tripBudgetTitle,
          style: TextStyle(
            fontFamily: CreateTripFonts.condensed,
            fontFamilyFallback:
            CreateTripFonts.khmerFallback,
            color: textColor,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          l10n.tripBudgetSubtitle,
          style: TextStyle(
            fontFamily: CreateTripFonts.condensed,
            fontFamilyFallback:
            CreateTripFonts.khmerFallback,
            color: secondaryColor,
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 24),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius:
            BorderRadius.circular(22),
            border: Border.all(
              color: isDark
                  ? Colors.white12
                  : CreateTripColors.lightBorder,
            ),
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                l10n.tripBudgetLabel,
                style: TextStyle(
                  fontFamily:
                  CreateTripFonts.condensed,
                  fontFamilyFallback:
                  CreateTripFonts.khmerFallback,
                  color: textColor,
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
                style: TextStyle(
                  fontFamily:
                  CreateTripFonts.condensed,
                  fontFamilyFallback:
                  CreateTripFonts.khmerFallback,
                  color: textColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
                decoration: InputDecoration(
                  prefixText: '\$',
                  prefixStyle: TextStyle(
                    color: textColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                  border: InputBorder.none,
                  hintText: l10n.tripBudgetHint,
                  hintStyle: TextStyle(
                    color: isDark
                        ? Colors.white30
                        : const Color(0xFF9CA3AF),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  50,
                  100,
                  300,
                  500,
                  1000,
                ].map(
                      (amount) => _BudgetChip(
                    amount: amount,
                    onSelected: () {
                      _budgetController.text =
                          amount.toString();
                    },
                  ),
                ).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }



  Widget _roundButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}

class _BudgetChip extends StatelessWidget {
  final int amount;
  final VoidCallback? onSelected;

  const _BudgetChip({
    required this.amount,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final textColor = isDark
        ? Colors.white
        : CreateTripColors.lightText;

    final backgroundColor = isDark
        ? const Color(0xFF222B3D)
        : Colors.white;

    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius:
          BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white12
                : CreateTripColors.lightBorder,
          ),
        ),
        child: Text(
          '\$$amount',
          style: TextStyle(
            fontFamily:
            CreateTripFonts.condensed,
            fontFamilyFallback:
            CreateTripFonts.khmerFallback,
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}