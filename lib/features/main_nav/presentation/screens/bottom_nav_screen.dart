import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_nav_controller.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../task/presentation/screens/task_screen.dart';
import '../../../fitness/presentation/screens/fitness_screen.dart';
import '../../../trip/presentation/screens/trip_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';

class BottomNavScreen extends GetView<MainNavController> {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
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
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Obx(() {
          return BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment),
                label: 'Task',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center),
                label: 'Fitness',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Trip',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          );
        }),
      ),
    );
  }
}
