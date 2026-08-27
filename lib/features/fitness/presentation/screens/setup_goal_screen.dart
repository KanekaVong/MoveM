import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../shared/widgets/glass_button.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../controllers/setup_goal_controller.dart';

class SetupGoalScreen extends StatelessWidget {
  const SetupGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SetupGoalController());

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: controller.previousStep,
                ),
              ),
            ),

                const SizedBox(height: 20),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0F172A),
                    ),
                    child: Obx(() {
                      final step = controller.currentStep.value;
                      final title = step == 3 ? 'Fitness Assessment' : 'Goal & Focus';

                      return Column(
                        children: [
                          const SizedBox(height: 24),
                          Text(title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(4, (index) {
                              return Container(
                                width: 60,
                                height: 4,
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: index <= step ? Colors.blueAccent : const Color(0xFF1E293B),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 40),

                          Expanded(
                            child: PageView(
                              controller: controller.pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                _buildGoalTypeStep(controller),
                                _buildTargetWeightStep(controller),
                                _buildTargetDateStep(controller),
                                _buildWorkoutLevelStep(controller),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: GlassButton(
                              text: 'Next',
                              onPressed: controller.nextStep,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildGoalTypeStep(SetupGoalController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Text('What’s your main goal?', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          _buildGoalCard(controller, 'Lose Weight', 'WEIGHT_LOSS', 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=500&auto=format&fit=crop'),
          const SizedBox(height: 16),
          _buildGoalCard(controller, 'Build Muscle', 'MUSCLE_GAIN', 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?q=80&w=500&auto=format&fit=crop'),
          const SizedBox(height: 16),
          _buildGoalCard(controller, 'Keep fit', 'STAYING_HEALTHY', 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=500&auto=format&fit=crop'),
        ],
      ),
    );
  }

  Widget _buildGoalCard(SetupGoalController controller, String title, String value, String imageUrl) {
    return Obx(() {
      final isSelected = controller.selectedGoalType.value == value;
      return GestureDetector(
        onTap: () => controller.selectedGoalType.value = value,
        child: GlassContainer(
          height: 120,
          borderRadius: BorderRadius.circular(24),
          opacity: isSelected ? 0.20 : 0.0,
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: isSelected ? 1.5 : 0.3,
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 160,
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [Colors.transparent, Colors.white],
                      stops: [0.0, 0.4],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTargetWeightStep(SetupGoalController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Text('What’s your target\nweight ?', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          Obx(() => Container(
            width: 200,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.isKg.value = true,
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller.isKg.value ? Colors.white.withOpacity(0.2) : Colors.transparent,
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                      ),
                      alignment: Alignment.center,
                      child: const Text('kg', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.isKg.value = false,
                    child: Container(
                      decoration: BoxDecoration(
                        color: !controller.isKg.value ? Colors.white.withOpacity(0.2) : Colors.transparent,
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
                      ),
                      alignment: Alignment.center,
                      child: const Text('Lbs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 64),
          Container(
            width: 150,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0B1220),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(border: InputBorder.none, hintText: '0', hintStyle: TextStyle(color: Colors.white24)),
                    onChanged: (val) {
                      controller.targetWeight.value = double.tryParse(val) ?? 0;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Obx(() => Text(controller.isKg.value ? 'kg' : 'Lbs', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetDateStep(SetupGoalController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Text('What’s your target\ndate ?', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 48),
          GlassContainer(
            height: 252,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFF002468),
            opacity: 0.20,
            border: Border.all(color: Colors.transparent),
            child: _buildCustomDatePicker(controller),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomDatePicker(SetupGoalController controller) {
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    final currentYear = DateTime.now().year;
    final years = List.generate(10, (i) => currentYear + i);
    final days = List.generate(31, (i) => i + 1);

    Widget buildWheelColumn(List<String> items, int initialIndex, ValueChanged<int> onChanged) {
      return Expanded(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GlassContainer(
                height: 39,
                width: double.infinity,
                color: const Color(0xFF002468),
                opacity: 0.20,
                border: Border.all(color: Colors.white.withOpacity(0.40), width: 0.8),
                borderRadius: BorderRadius.circular(6),
                child: const SizedBox.shrink(),
              ),
            ),
            _buildWheel(
              items: items,
              initialIndex: initialIndex,
              onSelectedItemChanged: onChanged,
            ),
          ],
        ),
      );
    }

    return Obx(() {
      final selectedDate = controller.targetDate.value;
      return Row(
        children: [
          buildWheelColumn(
            months,
            selectedDate.month - 1,
            (index) => controller.targetDate.value = DateTime(selectedDate.year, index + 1, selectedDate.day),
          ),
          buildWheelColumn(
            days.map((e) => e.toString()).toList(),
            selectedDate.day - 1,
            (index) => controller.targetDate.value = DateTime(selectedDate.year, selectedDate.month, index + 1),
          ),
          buildWheelColumn(
            years.map((e) => e.toString()).toList(),
            years.indexOf(selectedDate.year) == -1 ? 0 : years.indexOf(selectedDate.year),
            (index) => controller.targetDate.value = DateTime(years[index], selectedDate.month, selectedDate.day),
          ),
        ],
      );
    });
  }

  Widget _buildWheel({required List<String> items, required int initialIndex, required ValueChanged<int> onSelectedItemChanged}) {
    return CupertinoPicker(
      itemExtent: 39,
      scrollController: FixedExtentScrollController(initialItem: initialIndex),
      onSelectedItemChanged: onSelectedItemChanged,
      selectionOverlay: null,
      children: items.map((item) {
        return Container(
          alignment: Alignment.center,
          child: Text(
            item,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWorkoutLevelStep(SetupGoalController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Text('Choose your preferred\nworkout level?', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          _buildWorkoutLevelCard(controller, 'New Beginner', 'Small steps, big changes. Perfect if you\'re just starting your fitness journey.', 'NOVICE_LEVEL'),
          const SizedBox(height: 16),
          _buildWorkoutLevelCard(controller, 'Little Experience', 'You know the basics. Great for those who exercise occasionally.', 'INTERMEDIATE_LEVEL'),
          const SizedBox(height: 16),
          _buildWorkoutLevelCard(controller, 'Fitness-Guru (Sport Enthusiast)', 'Push your limits. For seasoned athletes and daily gym-goers.', 'ADVANCED_LEVEL'),
        ],
      ),
    );
  }

  Widget _buildWorkoutLevelCard(SetupGoalController controller, String title, String subtitle, String value) {
    return Obx(() {
      final isSelected = controller.selectedWorkoutLevel.value == value;
      return GestureDetector(
        onTap: () => controller.selectedWorkoutLevel.value = value,
        child: GlassContainer(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          borderRadius: BorderRadius.circular(24),
          opacity: isSelected ? 0.20 : 0.0,
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: isSelected ? 1.5 : 0.3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                alignment: Alignment.topCenter,
                child: isSelected && subtitle.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
    });
  }
}
