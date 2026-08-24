import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main_nav/presentation/controllers/main_nav_controller.dart';
import '../../../friends/presentation/bindings/friends_binding.dart';
import '../../../friends/presentation/screens/add_friends_screen.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildQuickActionBtn(context, Icons.check_box, const Color(0xFF4C8DB3), 'Add Task', onTap: () {
              if (Get.isRegistered<MainNavController>()) {
                Get.find<MainNavController>().changeTab(1);
              }
            }),
            _buildQuickActionBtn(context, Icons.directions_run, const Color(0xFFE28743), 'Log Workout'),
            _buildQuickActionBtn(context, Icons.flight, const Color(0xFF9B5DE5), 'Plan Trips'),
            _buildQuickActionBtn(context, Icons.group_add, const Color(0xFF3B82F6), 'Add Friends', onTap: () {
              Get.to(() => const AddFriendsScreen(), binding: FriendsBinding());
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionBtn(BuildContext context, IconData icon, Color color, String label, {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
