import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/fitness_profile_controller.dart';
import 'setup_goal_screen.dart';
import '../../../../core/theme/app_colors.dart';

class FitnessProfileGoalScreen extends StatefulWidget {
  const FitnessProfileGoalScreen({super.key});

  @override
  State<FitnessProfileGoalScreen> createState() => _FitnessProfileGoalScreenState();
}

class _FitnessProfileGoalScreenState extends State<FitnessProfileGoalScreen> {
  late final FitnessProfileController controller;
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  bool _synced = false;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<FitnessProfileController>()
        ? Get.find<FitnessProfileController>()
        : Get.put(FitnessProfileController());
    _syncFromProfile();
  }

  void _syncFromProfile() {
    final profile = controller.profile.value;
    if (profile == null) return;
    _heightController.text = profile.height > 0 ? _formatNumber(profile.height) : '';
    _weightController.text = profile.weight > 0 ? _formatNumber(profile.weight) : '';
    _synced = true;
  }

  String _formatNumber(double value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _saveBody() async {
    final height = double.tryParse(_heightController.text.trim()) ?? 0;
    final weight = double.tryParse(_weightController.text.trim()) ?? 0;
    if (height < 50 || height > 300) {
      Get.snackbar('Height', 'Enter height in cm (50–300).');
      return;
    }
    if (weight < 20 || weight > 500) {
      Get.snackbar('Weight', 'Enter weight in kg (20–500).');
      return;
    }

    final ok = await controller.saveBodyMetrics(height, weight);
    if (ok) {
      Get.snackbar('Saved', 'Fitness profile updated.', backgroundColor: const Color(0xFF166534), colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppColors.pageBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        final profile = controller.profile.value;
        if (!_synced && profile != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(_syncFromProfile);
            }
          });
        }

        final goal = profile?.fitnessGoal;
        final bmi = profile?.bmi ?? 0;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBmiCard(bmi),
              const SizedBox(height: 22),
              const Text(
                'Body metrics',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text(
                'Height and weight are used for calories and BMI.',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12.5),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _metricField(
                      label: 'Height',
                      suffix: 'CM',
                      controller: _heightController,
                      icon: Icons.height_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _metricField(
                      label: 'Weight',
                      suffix: 'KG',
                      controller: _weightController,
                      icon: Icons.monitor_weight_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: controller.isLoading ? null : _saveBody,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    disabledBackgroundColor: AppColors.chipSurface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: controller.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textPrimary),
                        )
                      : const Text(
                          'Save profile',
                          style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Fitness goal',
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final res = await Get.to(() => const SetupGoalScreen());
                      if (res == true) {
                        await controller.fetchProfile();
                        if (mounted) setState(_syncFromProfile);
                      }
                    },
                    child: const Text(
                      'Edit',
                      style: TextStyle(color: Color(0xFF5B9BF6), fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _goalRow('Goal', _goalLabel(goal?.goalType)),
              const SizedBox(height: 10),
              _goalRow('Level', goal?.formattedWorkoutLevel.isNotEmpty == true ? goal!.formattedWorkoutLevel : 'Not set'),
              const SizedBox(height: 10),
              _goalRow(
                'Target weight',
                (goal?.targetWeight ?? 0) > 0 ? '${_formatNumber(goal!.targetWeight)} KG' : 'Not set',
              ),
              const SizedBox(height: 10),
              _goalRow(
                'Target date',
                goal?.formattedTargetDate.isNotEmpty == true ? goal!.formattedTargetDate : 'Not set',
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBmiCard(double bmi) {
    final label = _bmiLabel(bmi);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF1E2E4A), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF3B82F6), width: 3),
            ),
            child: Center(
              child: Text(
                bmi > 0 ? bmi.toStringAsFixed(1) : '--',
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BMI',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Based on your current height and weight',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricField({
    required String label,
    required String suffix,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1E2E4A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF5B9BF6), size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              suffixText: suffix,
              suffixStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _goalRow(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E2E4A)),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 13.5, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  String _bmiLabel(double bmi) {
    if (bmi <= 0) return 'Not set';
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Healthy';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  String _goalLabel(String? type) {
    if (type == null || type.isEmpty) return 'Not set';
    return type
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');
  }
}
