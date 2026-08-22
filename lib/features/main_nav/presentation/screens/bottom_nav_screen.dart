import 'dart:ui';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../fitness/presentation/screens/fitness_screen.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../../task/presentation/screens/task_screen.dart';
import '../../../trip/presentation/screens/trip_screen.dart';
import '../controllers/main_nav_controller.dart';
import '../widgets/nav_bar_clipper.dart';

class BottomNavScreen extends GetView<MainNavController> {
  const BottomNavScreen({super.key});

  int _getVisualIndex(int logicIndex) {
    switch(logicIndex) {
      case 0: return 0;
      case 3: return 1;
      case 1: return 2;
      case 2: return 3;
      case 4: return 4;
      default: return 0;
    }
  }

  int _getLogicIndex(int visualIndex) {
    switch(visualIndex) {
      case 0: return 0;
      case 1: return 3;
      case 2: return 1;
      case 3: return 2;
      case 4: return 4;
      default: return 0;
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
                controller.visitedTabs.contains(1) ? const TaskScreen() : const SizedBox.shrink(),
                controller.visitedTabs.contains(2) ? const FitnessScreen() : const SizedBox.shrink(),
                controller.visitedTabs.contains(3) ? const TripScreen() : const SizedBox.shrink(),
                controller.visitedTabs.contains(4) ? const SettingsScreen() : const SizedBox.shrink(),
              ],
            );
          }),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Obx(() {
              final visualIndex = _getVisualIndex(controller.currentIndex.value);
              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  // Glass background (only bottom 60px)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFFFFFFF).withValues(alpha: 0.15),
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(35),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // The actual Navigation Bar
                  ClipPath(
                clipper: NavBarClipper(),
                child: CurvedNavigationBar(
                  index: visualIndex,
                  height: 60.0,
                  items: <Widget>[
                    Icon(Icons.home_filled, size: 28, color: visualIndex == 0 ? Colors.white : const Color(0xFFA0AAB2)),
                    Icon(Icons.map_outlined, size: 28, color: visualIndex == 1 ? Colors.white : const Color(0xFFA0AAB2)),
                    Icon(Icons.task, size: 28, color: visualIndex == 2 ? Colors.white : const Color(0xFFA0AAB2)),
                    Icon(Icons.fitness_center, size: 28, color: visualIndex == 3 ? Colors.white : const Color(0xFFA0AAB2)),
                    Icon(Icons.settings, size: 28, color: visualIndex == 4 ? Colors.white : const Color(0xFFA0AAB2)),
                  ],
                  color: const Color(0xFFE8E8E8).withValues(alpha: 0.15), // Glass color
                  backgroundColor: Colors.transparent,
                  buttonBackgroundColor: Colors.transparent, // Remove active background circle
                  animationCurve: Curves.easeInOut,
                  animationDuration: const Duration(milliseconds: 300),
                  onTap: (index) {
                    controller.changeTab(_getLogicIndex(index));
                  },
                  letIndexChange: (index) => true,
                ),
              ),
            ],
          );
            }),
          ),
        ],
      ),
    );
  }
}
