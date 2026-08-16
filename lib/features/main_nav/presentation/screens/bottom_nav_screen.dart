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
              children: const [
                HomeScreen(),
                TaskScreen(),
                FitnessScreen(),
                TripScreen(),
                SettingsScreen(),
              ],
            );
          }),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Obx(() {
              final visualIndex = _getVisualIndex(controller.currentIndex.value);
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5)),
                  ],
                ),
                child: ClipPath(
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
                    color: const Color(0xFF1E1F22),
                    backgroundColor: Colors.transparent,
                    animationCurve: Curves.easeInOut,
                    animationDuration: const Duration(milliseconds: 300),
                    onTap: (index) {
                      controller.changeTab(_getLogicIndex(index));
                    },
                    letIndexChange: (index) => true,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
