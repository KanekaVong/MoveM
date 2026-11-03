import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:movem/l10n/app_localizations.dart';

import '../../controllers/create_trip_controller.dart';
import 'package:movem/features/trip/presentation/widgets/create_trip_component.dart';
import 'package:movem/features/trip/presentation/screens/Create_trip/create_trip_summary_screen.dart';


class TripChecklistScreen extends StatefulWidget {
  const TripChecklistScreen({
    super.key,
  });

  @override
  State<TripChecklistScreen> createState() =>
      _TripChecklistScreenState();
}

class _TripChecklistScreenState
    extends State<TripChecklistScreen> {

  final TextEditingController _checklistController = TextEditingController();

  final CreateTripController controller = Get.find<CreateTripController>();

  @override
  void dispose() {
    _checklistController.dispose();
    super.dispose();
  }


  // Checklist
  void _addChecklistItem() {
    final item = _checklistController.text.trim();

    if (item.isEmpty) {
      return;
    }

    controller.addChecklistItem(item);
    _checklistController.clear();
  }

  void _removeChecklistItem(int index) {
    controller.removeChecklistItem(index);
  }

  void _continue() {
    Get.to(
          () => const CreateTripSummaryScreen(),
    );
  }

  String _buildTripDateSummary() {
    final l10n = AppLocalizations.of(context)!;

    if (controller.currentDraft.startDate == null ||
        controller.currentDraft.endDate == null) {
      return '—';
    }

    final start = MaterialLocalizations.of(context)
        .formatMediumDate(controller.currentDraft.startDate!);

    final end = MaterialLocalizations.of(context)
        .formatMediumDate(controller.currentDraft.endDate!);

    return '$start – $end '
        '(${controller.currentDraft.durationDays} '
        '${controller.currentDraft.durationDays == 1 ? l10n.tripDay : l10n.tripDays})';
  }

  String _buildTripBudgetSummary() {
    if (controller.currentDraft.budget <= 0) {
      return '—';
    }

    return '\$${controller.currentDraft.budget.toStringAsFixed(0)}';
  }

  String _buildTripStopsSummary() {
    final l10n = AppLocalizations.of(context)!;
    final count = controller.currentDraft.stops.length;

    return '$count '
        '${count == 1 ? l10n.tripStop : l10n.tripStops}';
  }

  // Build
  @override
  Widget build(BuildContext context) {
    final draft = controller.currentDraft;
    final l10n = AppLocalizations.of(context)!;

    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final keyboardOpen = keyboardHeight > 0;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final imageHeight = screenHeight * 0.50;

    // Move the form higher when keyboard opens
    final formTop = keyboardOpen
        ? screenHeight * 0.15
        : screenHeight * 0.43;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: isDark
          ? CreateTripColors.darkBackground
          : CreateTripColors.lightBackground,
      body: Stack(
        children: [
          // Background image
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

          // Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                14,
                20,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CreateTripHeader(
                    title: l10n.createNewTrip,
                    onBack: () => Get.back(),
                  ),

                  const SizedBox(height: 8),

                  CreateTripStepIndicator(
                    activeIndex: 6,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    draft.activityName ?? l10n.tripYourTrip,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: CreateTripFonts.condensed,
                      fontFamilyFallback:
                      CreateTripFonts.khmerFallback,
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    draft.locationName ??
                        draft.destination ??
                        l10n.tripLocationFallback,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: CreateTripFonts.condensed,
                      fontFamilyFallback:
                      CreateTripFonts.khmerFallback,
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      if (draft.budget > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _buildTripBudgetSummary(),
                            style: TextStyle(
                              fontFamily: CreateTripFonts.mono,
                              fontFamilyFallback:
                              CreateTripFonts.khmerFallback,
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                      if (draft.budget > 0)
                        const SizedBox(width: 8),

                      if (draft.startDate != null &&
                          draft.endDate != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _buildTripDateSummary(),
                            style: TextStyle(
                              fontFamily: CreateTripFonts.mono,
                              fontFamilyFallback:
                              CreateTripFonts.khmerFallback,
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _buildTripStopsSummary(),
                      style: TextStyle(
                        fontFamily: CreateTripFonts.mono,
                        fontFamilyFallback:
                        CreateTripFonts.khmerFallback,
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Checklist form panel
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            top: formTop,
            left: 0,
            right: 0,
            bottom: keyboardHeight,
            child: Obx(
                  () => _buildChecklistContent(l10n),
            ),
          ),
        ],
      ),
    );
  }

  // Checklist Content
  Widget _buildChecklistContent(AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark
        ? Colors.white
        : CreateTripColors.lightText;

    final secondaryColor = isDark
        ? Colors.white54
        : const Color(0xFF9CA3AF);

    final items = controller.currentDraft.checklistItems;

    return CreateTripFormPanel(
      bottomAction: CreateTripBottomButton(
        text: l10n.continueButton,
        onPressed: _continue,
      ),
      children: [
        // Title
        Text(
          l10n.tripChecklistTitle,
          style: TextStyle(
            fontFamily: CreateTripFonts.condensed,
            fontFamilyFallback: CreateTripFonts.khmerFallback,
            fontSize: 27,
            fontWeight: FontWeight.w700,
            height: 1.1,
            color: textColor,
          ),
        ),

        const SizedBox(height: 8),

        // Description
        Text(
          l10n.tripChecklistDescription,
          style: TextStyle(
            fontFamily: CreateTripFonts.condensed,
            fontFamilyFallback: CreateTripFonts.khmerFallback,
            fontSize: 13,
            color: secondaryColor,
          ),
        ),

        const SizedBox(height: 22),

        // Checklist items
        if (items.isNotEmpty)
          ...List.generate(
            items.length,
                (index) {
              final item = items[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildChecklistItem(
                  item,
                  index,
                  isDark,
                  textColor,
                  secondaryColor,
                ),
              );
            },
          ),

        const SizedBox(height: 4),

        // Add checklist item
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF171E2D)
                : const Color(0xFFF1F3F6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: _checklistController,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _addChecklistItem(),
            style: TextStyle(
              fontFamily: CreateTripFonts.condensed,
              fontFamilyFallback: CreateTripFonts.khmerFallback,
              color: textColor,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: l10n.checklistItemsHint,
              hintStyle: TextStyle(
                fontFamily: CreateTripFonts.condensed,
                fontFamilyFallback: CreateTripFonts.khmerFallback,
                color: secondaryColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 17,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Checklist Item
  Widget _buildChecklistItem(
      String item,
      int index,
      bool isDark,
      Color textColor,
      Color secondaryColor,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF171E2D)
            : const Color(0xFFF1F3F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Visual only
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark
                    ? Colors.white54
                    : CreateTripColors.lightText.withValues(
                  alpha: 0.5,
                ),
                width: 1.5,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Item name
          Expanded(
            child: Text(
              item,
              style: TextStyle(
                fontFamily: CreateTripFonts.condensed,
                fontFamilyFallback: CreateTripFonts.khmerFallback,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Remove
          GestureDetector(
            onTap: () => _removeChecklistItem(index),
            child: Icon(
              Icons.close_rounded,
              size: 18,
              color: secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}