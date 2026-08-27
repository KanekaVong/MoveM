import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/fitness_profile_controller.dart';

class FitnessOnboardingScreen extends StatefulWidget {
  final FitnessProfileController controller;
  const FitnessOnboardingScreen({super.key, required this.controller});

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

  void _nextPage() async {
    if (_currentPage == 0) {
      if (_heightController.text.isEmpty) {
        Get.snackbar('Error', 'Please enter your height');
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
        Get.snackbar('Error', 'Please enter your weight');
        return;
      }
      double w = double.tryParse(_weightController.text) ?? 0.0;
      if (!_isKg) {
        w = w * 0.453592;
      }
      widget.controller.setWeight(w);

      await widget.controller.saveProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
                  const Text(
                    'Your details',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildProgressIndicator(_currentPage >= 0)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildProgressIndicator(_currentPage >= 1)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildProgressIndicator(false)),
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
                          _currentPage == 0 ? 'Next' : 'Submit',
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
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
        color: isActive ? const Color(0xFF3B82F6) : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeightStep() {
    return Column(
      children: [
        const Text(
          "What's your height?",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        _buildToggleContainer(
          leftText: 'cm',
          rightText: 'ft',
          isLeftActive: _isCm,
          onLeftTap: () => setState(() => _isCm = true),
          onRightTap: () => setState(() => _isCm = false),
        ),
        const SizedBox(height: 64),
        Container(
          width: 200,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF131B2F),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '--',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _isCm ? 'cm' : 'ft',
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
        const Text(
          "What's your current weight ?",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        _buildToggleContainer(
          leftText: 'kg',
          rightText: 'Lbs',
          isLeftActive: _isKg,
          onLeftTap: () => setState(() => _isKg = true),
          onRightTap: () => setState(() => _isKg = false),
        ),
        const SizedBox(height: 64),
        Container(
          width: 200,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF131B2F),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '--',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _isKg ? 'kg' : 'Lbs',
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
        color: const Color(0xFF131B2F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
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
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
