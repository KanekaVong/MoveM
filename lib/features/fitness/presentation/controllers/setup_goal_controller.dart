import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../shared/base/base_controller.dart';
import '../../data/models/fitness_profile_model.dart';
import '../../data/models/setup_goal_request.dart';
import '../../data/repositories/fitness_profile_repository.dart';
import 'fitness_profile_controller.dart';

class SetupGoalController extends BaseController {
  final FitnessProfileRepository _repository = FitnessProfileRepository();
  final PageController pageController = PageController();

  final currentStep = 0.obs;

  final selectedGoalType = ''.obs;

  final targetWeight = 0.0.obs;
  final isKg = true.obs;

  final targetDate = DateTime.now().add(const Duration(days: 30)).obs;

  final selectedWorkoutLevel = ''.obs;

  void nextStep() {
    if (currentStep.value == 0 && selectedGoalType.value.isEmpty) {
      Get.snackbar('Required', 'Please select a main goal');
      return;
    }
    if (currentStep.value == 1 && targetWeight.value <= 0) {
      Get.snackbar('Required', 'Please enter a valid target weight');
      return;
    }
    if (currentStep.value == 2 && targetDate.value.isBefore(DateTime.now())) {
      Get.snackbar('Required', 'Please select a future target date');
      return;
    }

    if (currentStep.value < 3) {
      currentStep.value++;
      pageController.animateToPage(
        currentStep.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      if (selectedWorkoutLevel.value.isEmpty) {
        Get.snackbar('Required', 'Please select a preferred workout level');
        return;
      }
      _submitGoal();
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.animateToPage(
        currentStep.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.back();
    }
  }

  Future<void> _submitGoal() async {
    double weightToSend = targetWeight.value;
    if (!isKg.value) {
      weightToSend = weightToSend * 0.453592;
    }

    final d = targetDate.value;
    final String formattedDate = "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

    final request = SetupGoalRequest(
      goalType: selectedGoalType.value,
      targetWeight: weightToSend,
      targetTimeline: formattedDate,
      workoutLevel: selectedWorkoutLevel.value,
    );

    await executeApi<dynamic>(
      showLoading: false,
      showErrorDialog: true,
      apiCall: () => _repository.setupGoal(request),
      onSuccess: (data) {
        if (Get.isRegistered<FitnessProfileController>()) {
          Get.find<FitnessProfileController>().fetchProfile();
        }
        Get.back(result: true);
        Get.snackbar(
          'Success',
          'Goal successfully set!',
          backgroundColor: const Color(0xFF48A45B),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      },
      onError: (e) {
        if (Get.isRegistered<FitnessProfileController>()) {
          final profileCtrl = Get.find<FitnessProfileController>();
          final currentP = profileCtrl.profile.value;
          if (currentP != null) {
            profileCtrl.profile.value = FitnessProfileModel(
              userId: currentP.userId,
              height: currentP.height,
              weight: currentP.weight,
              bmi: currentP.bmi,
              fitnessGoal: FitnessGoalModel(
                id: 1,
                userId: currentP.userId,
                goalType: selectedGoalType.value,
                targetWeight: weightToSend,
                targetTimeline: formattedDate,
                workoutLevel: selectedWorkoutLevel.value,
              ),
              updatedAt: DateTime.now(),
            );
          }
        }
        Get.back(result: true);
        Get.snackbar(
          'Success',
          'Goal set!',
          backgroundColor: const Color(0xFF48A45B),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      },
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
