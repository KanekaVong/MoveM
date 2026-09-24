import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../controllers/setup_goal_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class SetupGoalScreen extends StatelessWidget {
  const SetupGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SetupGoalController());

    return Obx(() => PopScope(
      canPop: controller.currentStep.value == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (controller.currentStep.value > 0) {
          controller.previousStep();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
                    onPressed: controller.previousStep,
                  ),
                ),
              ),

              SizedBox(height: 20),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.cardSurface,
                  ),
                  child: Obx(() {
                    final step = controller.currentStep.value;
                    final title = step == 3
                        ? (AppLocalizations.of(context)?.fitnessAssessment ?? 'Fitness Assessment')
                        : (AppLocalizations.of(context)?.setupGoal ?? 'Goal & Focus');

                    return Column(
                      children: [
                        SizedBox(height: 24),
                        Text(title, style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (index) {
                            return Container(
                              width: 60,
                              height: 4,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: index <= step ? Colors.blueAccent : AppColors.chipSurface,
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
                          child: AppButton(
                            label: step == 3 ? 'Set Goal' : 'Next',
                            isLoading: controller.isLoading,
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
      ),
    ));
  }

  Widget _buildGoalTypeStep(SetupGoalController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Text(AppLocalizations.of(Get.context!)?.mainGoalQuestion ?? 'What’s your main goal?', style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          _buildGoalCard(controller, AppLocalizations.of(Get.context!)?.loseWeightGoal ?? 'Lose Weight', 'WEIGHT_LOSS', 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=500&auto=format&fit=crop'),
          SizedBox(height: 16),
          _buildGoalCard(controller, AppLocalizations.of(Get.context!)?.buildMuscleGoal ?? 'Build Muscle', 'MUSCLE_GAIN', 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?q=80&w=500&auto=format&fit=crop'),
          SizedBox(height: 16),
          _buildGoalCard(controller, AppLocalizations.of(Get.context!)?.keepFitGoal ?? 'Keep fit', 'STAYING_HEALTHY', 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=500&auto=format&fit=crop'),
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
            color: AppColors.textPrimary.withValues(alpha: 0.2),
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
                  child: Text(title, style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
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
          Text(AppLocalizations.of(Get.context!)?.targetWeightQuestion ?? 'What’s your target\nweight ?', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 32),
          Obx(() => Container(
            width: 200,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.chipSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.isKg.value = true,
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller.isKg.value ? AppColors.textPrimary.withValues(alpha: 0.2) : Colors.transparent,
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                      ),
                      alignment: Alignment.center,
                      child: Text(AppLocalizations.of(Get.context!)?.kgUnit ?? 'kg', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.isKg.value = false,
                    child: Container(
                      decoration: BoxDecoration(
                        color: !controller.isKg.value ? AppColors.textPrimary.withValues(alpha: 0.2) : Colors.transparent,
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
                      ),
                      alignment: Alignment.center,
                      child: Text(AppLocalizations.of(Get.context!)?.lbsUnit ?? 'Lbs', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          )),
          SizedBox(height: 64),
          Container(
            width: 150,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.chipSurface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: controller.weightTextController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(border: InputBorder.none, hintText: '0', hintStyle: TextStyle(color: AppColors.textCaption)),
                    onChanged: (val) {
                      controller.targetWeight.value = double.tryParse(val) ?? 0;
                    },
                  ),
                ),
                SizedBox(width: 8),
                Obx(() => Text(controller.isKg.value ? (AppLocalizations.of(Get.context!)?.kgUnit ?? 'kg') : (AppLocalizations.of(Get.context!)?.lbsUnit ?? 'Lbs'), style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold))),
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
          Text(AppLocalizations.of(Get.context!)?.targetDateQuestion ?? 'What’s your target\ndate ?', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 48),
          GlassContainer(
            height: 252,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            borderRadius: BorderRadius.circular(12),
            color: AppColors.chipSurface,
            opacity: 0.85,
            border: Border.all(color: Colors.transparent),
            child: _buildCustomDatePicker(controller),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomDatePicker(SetupGoalController controller) {
    final locale = Localizations.localeOf(Get.context!).toString();
    final months = List.generate(12, (i) => DateFormat.MMMM(locale).format(DateTime(2020, i + 1)));
    final days = List.generate(31, (i) => i + 1);

    Widget buildWheelColumn({
      required List<String> items,
      required FixedExtentScrollController scrollController,
      required ValueChanged<int> onChanged,
    }) {
      return Expanded(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GlassContainer(
                height: 39,
                width: double.infinity,
                color: AppColors.chipSurface,
                opacity: 0.85,
                border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.40), width: 0.8),
                borderRadius: BorderRadius.circular(6),
                child: SizedBox.shrink(),
              ),
            ),
            CupertinoPicker(
              itemExtent: 39,
              scrollController: scrollController,
              onSelectedItemChanged: onChanged,
              selectionOverlay: null,
              children: items.map((item) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    item,
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        buildWheelColumn(
          items: months,
          scrollController: controller.monthScrollController,
          onChanged: (index) {
            final cur = controller.targetDate.value;
            controller.targetDate.value = DateTime(cur.year, index + 1, cur.day);
          },
        ),
        buildWheelColumn(
          items: days.map((e) => e.toString()).toList(),
          scrollController: controller.dayScrollController,
          onChanged: (index) {
            final cur = controller.targetDate.value;
            controller.targetDate.value = DateTime(cur.year, cur.month, index + 1);
          },
        ),
        buildWheelColumn(
          items: controller.years.map((e) => e.toString()).toList(),
          scrollController: controller.yearScrollController,
          onChanged: (index) {
            final cur = controller.targetDate.value;
            controller.targetDate.value = DateTime(controller.years[index], cur.month, cur.day);
          },
        ),
      ],
    );
  }

  Widget _buildWorkoutLevelStep(SetupGoalController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Text(AppLocalizations.of(Get.context!)?.workoutLevelQuestion ?? 'Choose your preferred\nworkout level?', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          _buildWorkoutLevelCard(controller, AppLocalizations.of(Get.context!)?.noviceLevel ?? 'New Beginner', AppLocalizations.of(Get.context!)?.noviceLevelSub ?? 'Small steps, big changes. Perfect if you\'re just starting your fitness journey.', 'NOVICE_LEVEL'),
          const SizedBox(height: 16),
          _buildWorkoutLevelCard(controller, AppLocalizations.of(Get.context!)?.intermediateLevel ?? 'Little Experience', AppLocalizations.of(Get.context!)?.intermediateLevelSub ?? 'You know the basics. Great for those who exercise occasionally.', 'INTERMEDIATE_LEVEL'),
          SizedBox(height: 16),
          _buildWorkoutLevelCard(controller, AppLocalizations.of(Get.context!)?.advancedLevel ?? 'Fitness-Guru (Sport Enthusiast)', AppLocalizations.of(Get.context!)?.advancedLevelSub ?? 'Push your limits. For seasoned athletes and daily gym-goers.', 'ADVANCED_LEVEL'),
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
            color: AppColors.textPrimary.withValues(alpha: 0.2),
            width: isSelected ? 1.5 : 0.3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                alignment: Alignment.topCenter,
                child: isSelected && subtitle.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(subtitle, style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4)),
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
