import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/create_trip_controller.dart';
import 'create_trip_location_screen.dart';
import '../../widgets/create_trip_component.dart';
import 'package:movem/l10n/app_localizations.dart';

class CreateTripNameScreen extends StatefulWidget {
  const CreateTripNameScreen({
    super.key,
  });

  @override
  State<CreateTripNameScreen> createState() => _CreateTripNameScreenState();
}

class _CreateTripNameScreenState extends State<CreateTripNameScreen> {

  final CreateTripController controller = Get.find<CreateTripController>();

  late final TextEditingController _tripNameController;

  @override
  void initState() {
    super.initState();

    _tripNameController = TextEditingController(
      text: controller.draft.value.activityName ?? '',
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
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.tripNameRequired,
          ),
        ),
      );
      return;
    }

    controller.setActivityName(name);

    Get.to(
          () => const CreateTripLocationScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final keyboardOpen = keyboardHeight > 0;

    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final imageHeight = screenHeight * 0.50;

    final formTop = keyboardOpen ? screenHeight * 0.15 : screenHeight * 0.43;

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

          // header + step indicator
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Column(
                children: [
                  CreateTripHeader(
                    title: l10n.createNewTrip,
                    onBack: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 8),
                  const CreateTripStepIndicator(activeIndex: 0),
                ],
              ),
            ),
          ),

          // form panel
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            top: formTop,
            left: 0,
            right: 0,
            bottom: keyboardHeight,
            child: CreateTripFormPanel(
              bottomAction: Obx(() {
                final name = controller.draft.value.activityName?.trim() ?? '';
                return CreateTripBottomButton(
                  text: l10n.continueButton,
                  onPressed: name.isEmpty ? null : _continue,
                );
              }),
              children: [
                Text(
                  l10n.tripNameTitle,
                  style: TextStyle(
                    color: isDark ? Colors.white : CreateTripColors.lightText,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.tripNameSubtitle,
                  style: TextStyle(
                    color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 28),
                TextField(
                  controller: _tripNameController,
                  onChanged: controller.setActivityName,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(
                    color: isDark ? Colors.white : CreateTripColors.lightText,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.tripNameHint,
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white30 : const Color(0xFF9CA3AF),
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
              ],
            ),
          ),
        ],
      ),
    );
  }



}