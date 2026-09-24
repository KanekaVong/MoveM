import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movem/features/trip/presentation/screens/Create_trip/create_trip_packing_screen.dart';
import 'package:movem/l10n/app_localizations.dart';

import '../../controllers/create_trip_controller.dart';
import 'package:movem/features/trip/presentation/models/create_trip_stop_draft.dart';
import 'create_trip_friends_screen.dart';
import 'create_trip_stop_map_screen.dart';
import '../../widgets/create_trip_component.dart';
import 'package:movem/features/friends/domain/repositories/friends_repository.dart';
import 'package:movem/features/friends/presentation/bindings/friends_binding.dart';

class CreateTripStopScreen extends StatefulWidget {

  const CreateTripStopScreen({
    super.key,
  });

  @override
  State<CreateTripStopScreen> createState() => _CreateTripStopScreenState();
}

class _CreateTripStopScreenState extends State<CreateTripStopScreen> {

  final CreateTripController controller = Get.find<CreateTripController>();

  String _formatDateRange(
      BuildContext context,
      DateTime start,
      DateTime end,
      ) {
    final localizations = MaterialLocalizations.of(context);

    if (start.year == end.year &&
        start.month == end.month) {
      return '${localizations.formatMediumDate(start)}'
          ' – '
          '${end.day} '
          '${localizations.formatMediumDate(end).split(' ').skip(1).join(' ')}';
    }

    return '${localizations.formatMediumDate(start)}'
        ' – '
        '${localizations.formatMediumDate(end)}';
  }


  void _removeStop(int index) {
    controller.removeStop(index);
  }

  Future<void> _openStopMap() async {

    final result = await Get.to<CreateTripStopMapResult>(
          () => const CreateTripStopMapScreen(),
    );

    if (result == null) return;

    controller.addStop(
      result.stop,
      insertionIndex: result.insertionIndex,
    );
  }

  Future<void> _openExistingStopMap(CreateTripStopDraft stop,) async {

    if (stop.lat == null || stop.lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'This stop does not have a location on the map.',
          ),
        ),
      );
      return;
    }

    final result = await Get.to<CreateTripStopMapResult>(
          () => CreateTripStopMapScreen(
        existingStop: stop,
      ),
    );

    if (result == null) return;

    final index =
    controller.currentDraft.stops.indexOf(stop);

    if (index != -1) {
      controller.updateStop(
        index,
        result.stop,
      );
    }
  }

  void _continue() {
    if (!Get.isRegistered<FriendsRepository>()) {
      FriendsBinding().dependencies();
    }

    Get.to(
          () => const CreateTripPackingScreen(),
      binding: FriendsBinding(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final keyboardOpen = keyboardHeight > 0;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final imageHeight = screenHeight * 0.50;

    // Move form higher when keyboard opens
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
          Obx(
                () {
              final draft = controller.currentDraft;

              return SafeArea(
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

                      const CreateTripStepIndicator(
                        activeIndex: 3,
                      ),

                      const SizedBox(height: 10),

                      Text(
                        draft.activityName ?? '',
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
                            '',
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
                                borderRadius:
                                BorderRadius.circular(12),
                              ),
                              child: Text(
                                '\$${draft.budget.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontFamily:
                                  CreateTripFonts.mono,
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
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color:
                                Colors.white.withOpacity(0.12),
                                borderRadius:
                                BorderRadius.circular(12),
                              ),
                              child: Text(
                                _formatDateRange(
                                  context,
                                  draft.startDate!,
                                  draft.endDate!,
                                ),
                                style: TextStyle(
                                  fontFamily:
                                  CreateTripFonts.mono,
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
                    ],
                  ),
                ),
              );
            },
          ),

          // Form panel
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            top: formTop,
            left: 0,
            right: 0,
            bottom: keyboardHeight,
            child: Obx(
                  () => CreateTripFormPanel(
                    bottomAction: CreateTripBottomButton(
                      text: l10n.continueButton,
                      onPressed: _continue,
                    ),
                children: [
                  _buildStopContent(context, l10n),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStopContent(
      BuildContext context,
      AppLocalizations l10n,
      ) {
    final draft = controller.currentDraft;

    final isDark =
        Theme.of(context).brightness == Brightness.dark;

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
          l10n.tripStopsTitle,
          style: TextStyle(
            fontFamily: CreateTripFonts.condensed,
            fontFamilyFallback:
            CreateTripFonts.khmerFallback,
            color: textColor,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            height: 1.05,
          ),
        ),

        const SizedBox(height: 7),

        Text(
          l10n.tripStopsSubtitle,
          style: TextStyle(
            fontFamily: CreateTripFonts.condensed,
            fontFamilyFallback:
            CreateTripFonts.khmerFallback,
            color: secondaryColor,
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 18),

        // ADD STOP
        InkWell(
          onTap: _openStopMap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white12
                    : CreateTripColors.lightBorder,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.add_location_alt_outlined,
                  color: textColor,
                  size: 21,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    l10n.tripAddStop,
                    style: TextStyle(
                      fontFamily:
                      CreateTripFonts.condensed,
                      fontFamilyFallback:
                      CreateTripFonts.khmerFallback,
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Icon(
                  Icons.chevron_right_rounded,
                  color: secondaryColor,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 18),

        if (draft.stops.isEmpty)
          _buildStopHint(
            context,
            l10n,
          )
        else
          _buildStops(
            context,
            l10n,
          ),
      ],
    );
  }

  Widget _buildStopHint(
      BuildContext context,
      AppLocalizations l10n,
      ) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(
        top: 4,
        bottom: 8,
      ),
      child: Row(
        children: [
          Icon(
            Icons.map_outlined,
            color: isDark
                ? Colors.white38
                : const Color(0xFF9CA3AF),
            size: 18,
          ),

          const SizedBox(width: 10),

          Text(
            l10n.tripStopsEmpty,
            style: TextStyle(
              fontFamily:
              CreateTripFonts.condensed,
              fontFamilyFallback:
              CreateTripFonts.khmerFallback,
              color: isDark
                  ? Colors.white38
                  : const Color(0xFF9CA3AF),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStops(
      BuildContext context,
      AppLocalizations l10n,
      ) {

    final stops = controller.currentDraft.stops;

    return Column(
      children: [
        for (int i = 0; i < stops.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _buildStopItem(
              stop: stops[i],
              index: i,
            ),
          ),

        _buildStopHint(
          context,
          l10n,
        ),
      ],
    );
  }

  Widget _buildStopItem({
    required CreateTripStopDraft stop,
    required int index,
  }) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark
        ? Colors.white
        : CreateTripColors.lightText;

    final secondaryColor = isDark
        ? Colors.white54
        : const Color(0xFF6B7280);

    final circleColor = isDark
        ? const Color(0xFF222B3D)
        : Colors.white;

    final borderColor = isDark
        ? Colors.white12
        : CreateTripColors.lightBorder;

    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: borderColor,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontFamily:
                  CreateTripFonts.mono,
                  fontFamilyFallback:
                  CreateTripFonts.khmerFallback,
                  color: textColor,
                  fontSize: 11,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ),

            if (index < controller.currentDraft.stops.length - 1)
              Container(
                width: 1,
                height: 24,
                color: borderColor,
              ),
          ],
        ),

        const SizedBox(width: 12),

        Expanded(
          child: InkWell(
            onTap: () =>
                _openExistingStopMap(stop),
            borderRadius:
            BorderRadius.circular(12),
            child: Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 4,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    stop.locationName ??
                        AppLocalizations.of(
                          context,
                        )!
                            .tripUnnamedStop,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily:
                      CreateTripFonts
                          .condensed,
                      fontFamilyFallback:
                      CreateTripFonts
                          .khmerFallback,
                      color: textColor,
                      fontSize: 14,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  if (stop.locationAddress != null &&
                      stop.locationAddress!
                          .isNotEmpty)
                    Padding(
                      padding:
                      const EdgeInsets.only(
                        top: 3,
                      ),
                      child: Text(
                        stop.locationAddress!,
                        maxLines: 2,
                        overflow:
                        TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily:
                          CreateTripFonts
                              .condensed,
                          fontFamilyFallback:
                          CreateTripFonts
                              .khmerFallback,
                          color:
                          secondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        IconButton(
          onPressed: () =>
              _removeStop(index),
          icon: Icon(
            Icons.close_rounded,
            color: secondaryColor,
            size: 20,
          ),
        ),
      ],
    );
  }
}