import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_images.dart';
import '../../data/models/solo_challenge_model.dart';
import '../../data/repositories/fitness_challenge_repository.dart';
import '../controllers/fitness_profile_controller.dart';
import 'solo_fitness_detail_screen.dart';
import '../../../../core/theme/app_colors.dart';

class SoloChallengeListScreen extends StatefulWidget {
  final FitnessChallengeRepository? repository;

  const SoloChallengeListScreen({
    super.key,
    this.repository,
  });

  @override
  State<SoloChallengeListScreen> createState() => _SoloChallengeListScreenState();
}

class _SoloChallengeListScreenState extends State<SoloChallengeListScreen> {
  late final FitnessChallengeRepository _repository;
  final List<SoloChallengeModel> _challenges = [];
  bool _isLoading = true;
  String _selectedFilter = 'ALL';

  static final List<SoloChallengeModel> _defaultFallbackChallenges = [
    SoloChallengeModel(
      id: 101,
      name: 'Running',
      type: 'RUNNING',
      workoutLevel: 'NOVICE_LEVEL',
      targetValue: 5,
      targetUnit: 'KM',
      calories: 250,
      description: 'Track your distance, pace, and calories while running.',
      sets: 1,
      repsPerSet: 5,
      imagePath: AppImages.runningActivity,
      heroImagePath: AppImages.runningActivity,
    ),
    SoloChallengeModel(
      id: 102,
      name: 'Push Up',
      type: 'PUSH_UP',
      workoutLevel: 'NOVICE_LEVEL',
      targetValue: 60,
      targetUnit: 'REPS',
      calories: 120,
      description: "An exercise done to improve upper body strength, performed by resting on one's toes and hands and pushing one's weight off the floor",
      sets: 4,
      repsPerSet: 15,
      imagePath: AppImages.pushUpCard,
      heroImagePath: AppImages.pushUpHero,
    ),
    SoloChallengeModel(
      id: 103,
      name: 'Squats',
      type: 'SQUATS',
      workoutLevel: 'NOVICE_LEVEL',
      targetValue: 10,
      targetUnit: 'MINUTES',
      calories: 150,
      description: 'Lower hips from standing position and stand back up.',
      sets: 3,
      repsPerSet: 15,
      imagePath: AppImages.squatsActivity,
      heroImagePath: AppImages.squatsActivity,
    ),
    SoloChallengeModel(
      id: 104,
      name: 'Pull ups',
      type: 'PULL_UPS',
      workoutLevel: 'INTERMEDIATE_LEVEL',
      targetValue: 20,
      targetUnit: 'REPS',
      calories: 100,
      description: 'Upper-body exercise where you pull yourself up to a bar.',
      sets: 4,
      repsPerSet: 5,
      imagePath: AppImages.pullUpsActivity,
      heroImagePath: AppImages.pullUpsActivity,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? FitnessChallengeRepository();

    if (Get.isRegistered<FitnessProfileController>()) {
      final profileCtrl = Get.find<FitnessProfileController>();
      if (profileCtrl.soloChallenges.isNotEmpty) {
        _challenges.addAll(profileCtrl.soloChallenges);
        _isLoading = false;
      }
    }

    _fetchChallenges();
  }

  Future<void> _fetchChallenges() async {
    if (_challenges.isEmpty) {
      setState(() => _isLoading = true);
    }

    try {
      final result = await _repository.getSoloChallenges();
      if (!mounted) return;

      if (result.isSuccess && result.data != null && result.data!.isNotEmpty) {
        setState(() {
          _challenges.clear();
          _challenges.addAll(result.data!);
          _isLoading = false;
        });

        if (Get.isRegistered<FitnessProfileController>()) {
          Get.find<FitnessProfileController>().soloChallenges.value = result.data!;
        }
      } else if (_challenges.isEmpty) {
        setState(() {
          _challenges.addAll(_defaultFallbackChallenges);
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted && _challenges.isEmpty) {
        setState(() {
          _challenges.addAll(_defaultFallbackChallenges);
          _isLoading = false;
        });
      }
    } finally {
      if (mounted && _isLoading) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onChallengeTap(SoloChallengeModel item) {
    Get.to(() => SoloFitnessDetailScreen(challenge: item));
  }

  List<String> _getAvailableCategories() {
    final types = <String>{'ALL'};
    for (final c in _challenges) {
      if (c.type.isNotEmpty) {
        types.add(c.type.toUpperCase());
      }
    }
    return types.toList();
  }

  void _showFilterModal() {
    final categories = _getAvailableCategories();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: const BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Filter Challenges',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((cat) {
                    final isSelected = _selectedFilter == cat;
                    return ChoiceChip(
                      label: Text(
                        cat == 'ALL' ? 'All' : cat.replaceAll('_', ' ').capitalizeFirst ?? cat,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF2563EB),
                      backgroundColor: AppColors.chipSurface,
                      side: BorderSide(
                        color: isSelected ? AppColors.accentBlue : AppColors.borderLight,
                      ),
                      onSelected: (val) {
                        setState(() => _selectedFilter = cat);
                        Get.back();
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _formatSubtitle(SoloChallengeModel item) {
    final parts = <String>[];

    if (item.targetValue > 0) {
      final unitStr = item.targetUnit.isNotEmpty ? item.targetUnit.toLowerCase() : '';
      parts.add('${item.targetValue} $unitStr');
    }

    if (item.workoutLevel.isNotEmpty) {
      final level = item.workoutLevel
          .replaceAll('_LEVEL', '')
          .replaceAll('_', ' ')
          .toLowerCase()
          .capitalizeFirst;
      if (level != null && level.isNotEmpty) {
        parts.add(level);
      }
    }

    if (item.calories > 0) {
      parts.add('${item.calories} kcal');
    }

    if (parts.isEmpty && item.description.isNotEmpty) {
      return item.description;
    }

    return parts.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    final items = _selectedFilter == 'ALL'
        ? _challenges
        : _challenges.where((c) {
            final filter = _selectedFilter.toUpperCase();
            final type = c.type.toUpperCase();
            if (filter == 'SQUATS' && (type == 'BODYWEIGHT' || type == 'SQUATS')) {
              return true;
            }
            return type == filter;
          }).toList();

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.cardSurface,
                        border: Border.all(
                          color: AppColors.borderLight,
                          width: 1.2,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textPrimary,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Workout Challenge',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                  GestureDetector(
                    onTap: _showFilterModal,
                    child: Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        Icons.tune_rounded,
                        color: AppColors.textPrimary,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading && _challenges.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF2563EB),
                        strokeWidth: 2.5,
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchChallenges,
                      color: const Color(0xFF2563EB),
                      backgroundColor: AppColors.cardSurface,
                      child: items.isEmpty
                          ? ListView(
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.fitness_center_outlined,
                                        size: 52,
                                        color: AppColors.borderMuted,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'No challenges found for $_selectedFilter',
                                        style: TextStyle(
                                          color: AppColors.textPrimary.withValues(alpha: 0.7),
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                              itemCount: items.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 14),
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return _buildChallengeCard(item);
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeCard(SoloChallengeModel item) {
    final imagePath = item.effectiveImagePath;
    final isWhiteBg = imagePath == AppImages.pushUpHero ||
        imagePath == AppImages.squatsActivity ||
        imagePath == AppImages.pullUpsActivity;
    final subtitle = _formatSubtitle(item);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onChallengeTap(item),
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.borderLight,
              width: 1.2,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 72,
                decoration: BoxDecoration(
                  color: isWhiteBg ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: imagePath.startsWith('http')
                      ? Image.network(
                          imagePath,
                          width: 80,
                          height: 72,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 80,
                            height: 72,
                            color: AppColors.borderLight,
                            child: const Icon(Icons.fitness_center, color: AppColors.textCaption),
                          ),
                        )
                      : Image.asset(
                          imagePath,
                          width: 80,
                          height: 72,
                          fit: isWhiteBg ? BoxFit.contain : BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 80,
                            height: 72,
                            color: AppColors.borderLight,
                            child: const Icon(Icons.fitness_center, color: AppColors.textCaption),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
