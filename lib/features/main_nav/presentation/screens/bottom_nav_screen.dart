import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../fitness/presentation/screens/fitness_screen.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../../task/presentation/screens/task_screen.dart';
import '../../../trip/presentation/screens/trip_screen.dart';
import '../controllers/main_nav_controller.dart';
import '../widgets/notched_pill_nav_bar.dart';

class BottomNavScreen extends GetView<MainNavController> {
  const BottomNavScreen({super.key});

  int _getVisualIndex(int logicIndex) {
    switch (logicIndex) {
      case 0:
        return 0;
      case 3:
        return 1;
      case 1:
        return 2;
      case 2:
        return 3;
      case 4:
        return 4;
      default:
        return 0;
    }
  }

  int _getLogicIndex(int visualIndex) {
    switch (visualIndex) {
      case 0:
        return 0;
      case 1:
        return 3;
      case 2:
        return 1;
      case 3:
        return 2;
      case 4:
        return 4;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Obx(() {
            return IndexedStack(
              index: controller.currentIndex.value,
              children: [
                const HomeScreen(),
                controller.visitedTabs.contains(1)
                    ? const TaskScreen()
                    : const SizedBox.shrink(),
                controller.visitedTabs.contains(2)
                    ? const FitnessScreen()
                    : const SizedBox.shrink(),
                controller.visitedTabs.contains(3)
                    ? const TripScreen()
                    : const SizedBox.shrink(),
                controller.visitedTabs.contains(4)
                    ? const SettingsScreen()
                    : const SizedBox.shrink(),
              ],
            );
          }),
          Positioned(
            left: 16,
            right: 16,
            bottom: 18,
            child: Obx(() {
              final visualIndex =
                  _getVisualIndex(controller.currentIndex.value);
              return NotchedPillNavBar(
                currentIndex: visualIndex,
                onTap: (index) => controller.changeTab(_getLogicIndex(index)),
                icons: const [
                  Icons.home_rounded,
                  Icons.map_outlined,
                  Icons.assignment_outlined,
                  Icons.fitness_center,
                  Icons.settings_outlined,
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
