import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/fitness_profile_controller.dart';
import 'setup_goal_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class FitnessOnboardingScreen extends StatefulWidget {
  final FitnessProfileController controller;

  /// When true the screen edits an existing profile: values are prefilled and
  /// saving returns to the caller instead of continuing to the goal setup.
  final bool isEditing;

  const FitnessOnboardingScreen({
    super.key,
    required this.controller,
    this.isEditing = false,
  });

  @override
  State<FitnessOnboardingScreen> createState() => _FitnessOnboardingScreenState();
}

class _FitnessOnboardingScreenState extends State<FitnessOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  bool _isCm = true;
  final TextEditingController _heightController = TextEditingController();

  bool _isKg = true;
  final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      final profile = widget.controller.profile.value;
      if (profile != null) {
        if (profile.height > 0) _heightController.text = _formatNumber(profile.height);
        if (profile.weight > 0) _weightController.text = _formatNumber(profile.weight);
      }
    }
  }

  String _formatNumber(double value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
  }

  void _nextPage() async {
    final l10n = AppLocalizations.of(context);
    if (_currentPage == 0) {
      if (_heightController.text.isEmpty) {
        Get.snackbar(l10n?.errorTitle ?? 'Error', l10n?.pleaseEnterHeight ?? 'Please enter your height');
        return;
      }
      double h = double.tryParse(_heightController.text) ?? 0.0;
      if (!_isCm) {
        h = h * 30.48;
      }
      widget.controller.setHeight(h);

      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (_currentPage == 1) {
      if (_weightController.text.isEmpty) {
        Get.snackbar(l10n?.errorTitle ?? 'Error', l10n?.pleaseEnterWeight ?? 'Please enter your weight');
        return;
      }
      double w = double.tryParse(_weightController.text) ?? 0.0;
      if (!_isKg) {
        w = w * 0.453592;
      }
      widget.controller.setWeight(w);

      if (widget.isEditing) {
        final saved = await widget.controller.saveBodyMetrics(
          widget.controller.inputHeight.value,
          w,
        );
        if (saved) {
          Get.back(result: true);
          Get.snackbar(
            l10n?.savedTitle ?? 'Saved',
            l10n?.profileUpdated ?? 'Fitness profile updated.',
            backgroundColor: const Color(0xFF166534),
            colorText: Colors.white,
          );
        }
        return;
      }

      await widget.controller.saveProfile();
      if (widget.controller.hasProfile.value) {
        Get.off(() => const SetupGoalScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.chipSurface, AppColors.cardSurface],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
                    onPressed: () {
                      if (_currentPage > 0) {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Get.back();
                      }
                    },
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Text(
                    widget.isEditing ? 'Edit your details' : 'Your details',
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildProgressIndicator(_currentPage >= 0)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildProgressIndicator(_currentPage >= 1)),
                      if (!widget.isEditing) ...[
                        const SizedBox(width: 8),
                        Expanded(child: _buildProgressIndicator(false)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    height: 300,
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      children: [
                        _buildHeightStep(),
                        _buildWeightStep(),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _currentPage == 0
                              ? (AppLocalizations.of(context)?.next ?? 'Next')
                              : (widget.isEditing
                                  ? (AppLocalizations.of(context)?.save ?? 'Save')
                                  : (AppLocalizations.of(context)?.submit ?? 'Submit')),
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(bool isActive) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF3B82F6) : AppColors.chipSurface,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeightStep() {
    return Column(
      children: [
        Text(
          "What's your height?",
          style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 32),
        _buildToggleContainer(
          leftText: 'cm',
          rightText: 'ft',
          isLeftActive: _isCm,
          onLeftTap: () => setState(() => _isCm = true),
          onRightTap: () => setState(() => _isCm = false),
        ),
        SizedBox(height: 64),
        Container(
          width: 200,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '--',
                    hintStyle: TextStyle(color: AppColors.textPrimary.withValues(alpha: 0.3)),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                _isCm ? 'cm' : 'ft',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeightStep() {
    return Column(
      children: [
        Text(
          "What's your current weight ?",
          style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 32),
        _buildToggleContainer(
          leftText: 'kg',
          rightText: 'Lbs',
          isLeftActive: _isKg,
          onLeftTap: () => setState(() => _isKg = true),
          onRightTap: () => setState(() => _isKg = false),
        ),
        SizedBox(height: 64),
        Container(
          width: 200,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '--',
                    hintStyle: TextStyle(color: AppColors.textPrimary.withValues(alpha: 0.3)),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                _isKg ? 'kg' : 'Lbs',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleContainer({
    required String leftText,
    required String rightText,
    required bool isLeftActive,
    required VoidCallback onLeftTap,
    required VoidCallback onRightTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onLeftTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: BoxDecoration(
                color: isLeftActive ? const Color(0xFF2E394E) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                leftText,
                style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GestureDetector(
            onTap: onRightTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: BoxDecoration(
                color: !isLeftActive ? const Color(0xFF2E394E) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                rightText,
                style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
