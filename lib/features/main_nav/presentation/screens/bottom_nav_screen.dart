import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/main_nav_controller.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../task/presentation/screens/task_screen.dart';
import '../../../fitness/presentation/screens/fitness_screen.dart';
import '../../../trip/presentation/screens/trip_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';

class BottomNavScreen extends GetView<MainNavController> {
  const BottomNavScreen({super.key});

  static const _barColor = Color(0xFF2B3245);
  static const _activeColor = Color(0xFF1E2B6B);

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;

    final icons = <IconData>[
      Icons.home_rounded,
      Icons.assignment_outlined,
      Icons.fitness_center,
      Icons.map_outlined,
      Icons.settings_outlined,
    ];

    // Key lets us programmatically move the curved bar in sync with
    // controller.currentIndex (e.g. if something else changes the tab).
    final navKey = GlobalKey<CurvedNavigationBarState>();

    return Scaffold(
      extendBody: true,
      body: Obx(() {
        // Keep the curved bar's internal animation in sync if the index
        // changes from somewhere other than tapping it directly.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navKey.currentState?.setPage(controller.currentIndex.value);
        });
        return IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            HomeScreen(),
            TaskScreen(),
            FitnessScreen(),
            TripScreen(),
            SettingsScreen(),
          ],
        );
      }),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: SizedBox(
          // Extra height above the bar gives the floating bubble room
          // to pop out without hitting the clip boundary.
          height: 56 + 28,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CurvedNavigationBar(
                key: navKey,
                index: controller.currentIndex.value,
                height: 56,
                color: _barColor,
                buttonBackgroundColor: _activeColor,
                backgroundColor: Colors.transparent,
                animationCurve: Curves.easeOutCubic,
                animationDuration: const Duration(milliseconds: 350),
                items: List.generate(icons.length, (index) {
                  final isSelected = index == controller.currentIndex.value;
                  return Icon(
                    icons[index],
                    size: isSelected ? 26 : 22,
                    color: isSelected ? Colors.white : Colors.white60,
                  );
                }),
                onTap: controller.changeTab,
              ),
            ),
          ),
        ),
      ),
    );
  }
}