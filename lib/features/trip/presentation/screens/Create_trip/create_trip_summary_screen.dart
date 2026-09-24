import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movem/l10n/app_localizations.dart';

import 'package:movem/core/routes/app_routes.dart';
import 'package:movem/features/main_nav/presentation/controllers/main_nav_controller.dart';
import 'package:movem/features/trip/presentation/controllers/create_trip_controller.dart';
import 'package:movem/features/trip/presentation/widgets/create_trip_component.dart';

class CreateTripSummaryScreen extends StatelessWidget {
  const CreateTripSummaryScreen({super.key});

  CreateTripController get controller => Get.find<CreateTripController>();

  Future<void> _ready(BuildContext context) async {
    final success = await controller.submitTrip();

    if (!success || !context.mounted) {
      return;
    }

    Get.until(
          (route) => route.settings.name == AppRoutes.main,
    );

    if (Get.isRegistered<MainNavController>()) {
      Get.find<MainNavController>().changeTab(3);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';

    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];

    return '${date.day} ${months[date.month]} ${date.year}';
  }

  String _formatDateRange() {
    final draft = controller.currentDraft;

    if (draft.startDate == null) {
      return 'Dates not set';
    }

    if (draft.endDate == null) {
      return _formatDate(draft.startDate);
    }

    return '${draft.startDate!.day} - ${_formatDate(draft.endDate)}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Fullscreen Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/trip_detail_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // 2. Dark Overlay to prevent blue tint leakage and ensure readability
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.45),
            ),
          ),

          // 3. Main Content
          Positioned.fill(
            child: Column(
              children: [
                // Top Safe Header
                SafeArea(
                  bottom: false,
                  child: CreateTripHeader(
                    title: l10n.tripSummaryTitle,
                    onBack: () => Get.back(),
                  ),
                ),

                // Main Details Aligned to Bottom Edge
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      child: Obx(() => _buildSummaryContent(context, l10n)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryContent(BuildContext context, AppLocalizations l10n) {
    final draft = controller.currentDraft;

    const textColor = Colors.white;
    const secondaryColor = Colors.white70;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Large Main Trip Title
        Text(
          (draft.activityName ?? l10n.yourTrip).toUpperCase(),
          style: const TextStyle(
            color: textColor,
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(height: 20),

        // Grid Information
        _buildTripInfo(context, l10n, textColor, secondaryColor),

        const SizedBox(height: 24),

        // Routes Timeline Header & List
        _buildRoutes(context, l10n, textColor, secondaryColor),

        const SizedBox(height: 32),

        // Bottom Primary Action Glass Button
        CreateTripGlassButton(
          text: l10n.readyButton,
          onPressed: () => _ready(context),
        ),
      ],
    );
  }

  Widget _buildTripInfo(
      BuildContext context,
      AppLocalizations l10n,
      Color textColor,
      Color secondaryColor,
      ) {
    final draft = controller.currentDraft;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoTile(
                label: l10n.destination,
                value: draft.locationName ??
                    draft.destination ??
                    l10n.locationNotSelected,
                icon: Icons.location_pin,
                iconColor: Colors.redAccent,
                textColor: textColor,
                secondaryColor: secondaryColor,
              ),
              const SizedBox(height: 18),
              _buildInfoTile(
                label: l10n.budget,
                value: '\$${draft.budget.toStringAsFixed(0)}',
                icon: Icons.account_balance_wallet_rounded,
                iconColor: Colors.amber,
                showArrow: true,
                textColor: textColor,
                secondaryColor: secondaryColor,
              ),
              const SizedBox(height: 18),
              _buildInfoTile(
                label: l10n.friends,
                value: '${draft.friends.length}',
                icon: Icons.people_rounded,
                iconColor: Colors.lightBlueAccent,
                textColor: textColor,
                secondaryColor: secondaryColor,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoTile(
                label: l10n.duration,
                value: _formatDateRange(),
                icon: Icons.hourglass_bottom_rounded,
                iconColor: Colors.orangeAccent,
                textColor: textColor,
                secondaryColor: secondaryColor,
              ),
              const SizedBox(height: 18),
              _buildInfoTile(
                label: l10n.stops,
                value: '${draft.stops.length} ${l10n.places}',
                icon: Icons.map_rounded,
                iconColor: Colors.cyanAccent,
                textColor: textColor,
                secondaryColor: secondaryColor,
              ),
              const SizedBox(height: 18),
              _buildInfoTile(
                label: l10n.essentials,
                value: '${draft.packingItems.length} ${l10n.itemsToBePacked}',
                icon: Icons.backpack_rounded,
                iconColor: Colors.brown,
                textColor: textColor,
                secondaryColor: secondaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color textColor,
    required Color secondaryColor,
    bool showArrow = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 14),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            if (showArrow)
              Icon(
                Icons.chevron_right_rounded,
                color: secondaryColor,
                size: 16,
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildRoutes(
      BuildContext context,
      AppLocalizations l10n,
      Color textColor,
      Color secondaryColor,
      ) {
    final draft = controller.currentDraft;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.routes,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.map_outlined,
              color: secondaryColor,
              size: 16,
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (draft.stops.isEmpty)
          Text(
            l10n.noStopsAdded,
            style: TextStyle(
              color: secondaryColor,
              fontSize: 13,
            ),
          )
        else
          Column(
            children: List.generate(
              draft.stops.length,
                  (index) {
                final stop = draft.stops[index];
                final isLast = index == draft.stops.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white70,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        if (!isLast)
                          CustomPaint(
                            size: const Size(1, 28),
                            painter: DashedLinePainter(color: secondaryColor),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          (stop.locationName ?? l10n.unnamedStop).toUpperCase(),
                          style: TextStyle(
                            color: textColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const dashHeight = 4.0;
    const dashSpace = 3.0;
    double startY = 0;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}