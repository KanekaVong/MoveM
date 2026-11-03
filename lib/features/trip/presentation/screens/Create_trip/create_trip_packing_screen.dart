import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:movem/l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../controllers/create_trip_controller.dart';
import 'package:movem/features/trip/presentation/screens/Create_trip/trip_checklist_screen.dart';
import 'package:movem/features/trip/presentation/widgets/create_trip_component.dart';

class CreateTripPackingScreen extends StatefulWidget {
  const CreateTripPackingScreen({
    super.key,
  });

  @override
  State<CreateTripPackingScreen> createState() =>
      _CreateTripPackingScreenState();
}

class _CreateTripPackingScreenState
    extends State<CreateTripPackingScreen> {
  final CreateTripController controller = Get.find<CreateTripController>();

  final TextEditingController _packingController = TextEditingController();

  @override
  void dispose() {
    _packingController.dispose();
    super.dispose();
  }

  // Packing
  void _addPackingItem() {
    final item = _packingController.text.trim();

    if (item.isEmpty) return;

    controller.addPackingItem(item);
    _packingController.clear();
  }

  void _removeItem(int index) {
    controller.removePackingItem(index);
  }

  void _continue() {
    Get.to(
          () => const TripChecklistScreen(),
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

    // Move panel higher when keyboard opens
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
          // bg img
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
                          Colors.black.withValues(alpha: 0.45),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.15),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // header
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
                    onBack: () => Navigator.pop(context),
                  ),

                  const SizedBox(height: 8),

                  const CreateTripStepIndicator(
                    activeIndex: 5,
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

          // packing form panel
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            top: formTop,
            left: 0,
            right: 0,
            bottom: keyboardHeight,
            child: Obx(
                  () => _buildPackingContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackingContent() {
    final l10n = AppLocalizations.of(context)!;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark
        ? Colors.white
        : CreateTripColors.lightText;

    final secondaryColor = isDark
        ? Colors.white54
        : CreateTripColors.lightText.withValues(
      alpha: 0.5,
    );

    final packingItems = controller.currentDraft.packingItems;

    return CreateTripFormPanel(
      bottomAction: CreateTripBottomButton(
        text: l10n.continueButton,
        onPressed: _continue,
      ),
      children: [
        // Title
        Text(
          l10n.tripPackingTitle,
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
          l10n.tripPackingDescription,
          style: TextStyle(
            fontFamily: CreateTripFonts.condensed,
            fontFamilyFallback: CreateTripFonts.khmerFallback,
            fontSize: 13,
            color: secondaryColor,
          ),
        ),

        const SizedBox(height: 22),

        // Trip Essentials title
        Row(
          children: [
            Icon(
              Icons.work_outline,
              size: 32,
              color: textColor,
            ),
            const SizedBox(width: 12),
            Text(
              l10n.tripEssentials,
              style: TextStyle(
                fontFamily: CreateTripFonts.condensed,
                fontFamilyFallback:
                CreateTripFonts.khmerFallback,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        // Existing packing items
        if (packingItems.isNotEmpty)
          ...List.generate(
            packingItems.length,
                (index) {
              final item = packingItems[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
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
                      // Circle
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
                            fontFamilyFallback:
                            CreateTripFonts.khmerFallback,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? Colors.white
                                : CreateTripColors.lightText,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Remove
                      GestureDetector(
                        onTap: () => _removeItem(index),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: isDark
                              ? Colors.white54
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

        const SizedBox(height: 4),

        // Add packing item
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10,
              sigmaY: 10,
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0x99162341)
                    : const Color(0x66999999),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF0C1425)
                      : const Color(0xFFD6D6D6),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x73000000),
                    blurRadius: 30,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _packingController,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _addPackingItem(),
                style: TextStyle(
                  fontFamily: CreateTripFonts.condensed,
                  fontFamilyFallback: CreateTripFonts.khmerFallback,
                  color: isDark
                      ? Colors.white
                      : CreateTripColors.lightText,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: l10n.packingItemsHint,
                  hintStyle: TextStyle(
                    fontFamily: CreateTripFonts.condensed,
                    fontFamilyFallback: CreateTripFonts.khmerFallback,
                    color: isDark
                        ? Colors.white30
                        : const Color(0xFF9CA3AF),
                  ),
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF171E2D)
                      : const Color(0xFFF1F3F6),
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
          ),
        ),
      ],
    );
  }
}