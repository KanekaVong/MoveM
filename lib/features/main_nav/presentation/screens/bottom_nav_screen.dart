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

  Widget _buildNavItem(IconData icon, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? const Color(0xFFFFFFFF).withValues(alpha: 0.15)
            : Colors.transparent,
        border: Border.all(
          color: isActive
              ? Colors.white.withValues(alpha: 0.3)
              : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Center(
        child: Icon(
          icon,
          color: isActive ? Colors.white : const Color(0xFFA0AAB2),
          size: 28,
        ),
      ),
    );
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
            left: 20,
            right: 20,
            bottom: 24,
            child: Obx(() {
              final visualIndex =
                  _getVisualIndex(controller.currentIndex.value);
              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [

                  ClipPath(
                    clipper: NavBarClipper(),
                    child: CurvedNavigationBar(
                      index: visualIndex,
                      height: 60.0,
                      items: <Widget>[
                        _buildNavItem(Icons.home_filled, visualIndex == 0),
                        _buildNavItem(Icons.map_outlined, visualIndex == 1),
                        _buildNavItem(Icons.task, visualIndex == 2),
                        _buildNavItem(Icons.fitness_center, visualIndex == 3),
                        _buildNavItem(Icons.settings, visualIndex == 4),
                      ],
                      color: const Color(0xFFFFFFFF).withValues(alpha: 0.15),
                      backgroundColor: Colors.transparent,
                      buttonBackgroundColor: Colors.transparent,
                      animationCurve: Curves.easeOutBack,
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
