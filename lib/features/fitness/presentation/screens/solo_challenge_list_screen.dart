import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/solo_challenge_model.dart';
import '../controllers/fitness_profile_controller.dart';
import 'solo_fitness_detail_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/no_data_component.dart';
import '../widgets/loading_more_label.dart';
import '../../data/repositories/fitness_challenge_repository.dart';
import '../../../../shared/widgets/top_tool_bar.dart';

class SoloChallengeListScreen extends StatefulWidget {
  final FitnessChallengeRepository? repository;
  const SoloChallengeListScreen({super.key, this.repository});

  @override
  State<SoloChallengeListScreen> createState() => _SoloChallengeListScreenState();
}

class _SoloChallengeListScreenState extends State<SoloChallengeListScreen> {
  static const int _pageSize = 10;

  late final FitnessProfileController _profileController;
  final ScrollController _scrollController = ScrollController();
  String _selectedFilter = 'ALL';
  int _visibleCount = _pageSize;
  bool _canLoadNextPage = true;
  bool _loadingMore = false;
  int _pageToken = 0;

  @override
  void initState() {
    super.initState();
    _profileController = Get.isRegistered<FitnessProfileController>()
        ? Get.find<FitnessProfileController>()
        : Get.put(FitnessProfileController());
    if (widget.repository != null) {
      widget.repository!.getSoloChallenges().then((result) {
        if (result.isSuccess && mounted) {
          _profileController.soloChallenges.value = result.data ?? [];
          _profileController.isLoadingChallenges.value = false;
        }
      });
    } else {
      _profileController.fetchSoloChallenges();
    }
    _scrollController.addListener(_loadNextPageIfNeeded);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadNextPageIfNeeded);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchChallenges() async {
    setState(() {
      _pageToken++;
      _visibleCount = _pageSize;
      _canLoadNextPage = true;
      _loadingMore = false;
    });
    if (widget.repository != null) {
      final result = await widget.repository!.getSoloChallenges();
      if (result.isSuccess && mounted) {
        _profileController.soloChallenges.value = result.data ?? [];
        _profileController.isLoadingChallenges.value = false;
      }
      return;
    }
    await _profileController.fetchSoloChallenges();
  }

  Future<void> _loadNextPageIfNeeded() async {
    if (!_scrollController.hasClients || _loadingMore) return;
    final position = _scrollController.position;
    final nearEnd = position.maxScrollExtent <= 48 ||
        position.pixels >= position.maxScrollExtent - 240;
    if (!nearEnd) {
      _canLoadNextPage = true;
      return;
    }
    if (!_canLoadNextPage) return;
    final total = _filteredChallenges(_profileController.soloChallenges).length;
    if (_visibleCount >= total) return;
    _canLoadNextPage = false;
    final token = _pageToken;
    setState(() => _loadingMore = true);
    await Future.delayed(const Duration(milliseconds: 450));
    if (!mounted || token != _pageToken) return;
    final latestTotal = _filteredChallenges(_profileController.soloChallenges).length;
    setState(() {
      _visibleCount = (_visibleCount + _pageSize).clamp(0, latestTotal);
      _loadingMore = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      if (_scrollController.position.maxScrollExtent <= 48) {
        _canLoadNextPage = true;
        _loadNextPageIfNeeded();
      }
    });
  }

  List<SoloChallengeModel> _filteredChallenges(List<SoloChallengeModel> challenges) {
    if (_selectedFilter == 'ALL') return challenges;
    final filter = _selectedFilter.toUpperCase();
    return challenges.where((c) {
      final type = c.type.toUpperCase();
      if (filter == 'SQUATS' && (type == 'BODYWEIGHT' || type == 'SQUATS')) {
        return true;
      }
      return type == filter;
    }).toList();
  }

  void _onChallengeTap(SoloChallengeModel item) {
    Get.to(() => SoloFitnessDetailScreen(challenge: item));
  }

  List<String> _getAvailableCategories() {
    final types = <String>{'ALL'};
    for (final c in _profileController.soloChallenges) {
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
        decoration: BoxDecoration(
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
            SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)?.filterChallenges ?? 'Filter Challenges',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
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
                        cat == 'ALL'
                            ? (AppLocalizations.of(context)?.allFilter ?? 'All')
                            : cat.replaceAll('_', ' ').capitalizeFirst ?? cat,
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
                        setState(() {
                          _pageToken++;
                          _selectedFilter = cat;
                          _visibleCount = _pageSize;
                          _canLoadNextPage = true;
                          _loadingMore = false;
                        });
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
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            TopToolBar(
              title: l10n?.workoutChallenge ?? 'Workout Challenge',
              actions: [
                TopToolBarAction(icon: Icons.tune_rounded, iconSize: 22, onTap: _showFilterModal),
              ],
            ),
            Expanded(
              child: Obx(() {
                final challenges = _profileController.soloChallenges.toList();
                final isLoading = _profileController.isLoadingChallenges.value;
                final filtered = _filteredChallenges(challenges);
                final visible = filtered.take(_visibleCount).toList();
                final hasMore = visible.length < filtered.length;

                if (isLoading && challenges.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.accentBlue,
                      strokeWidth: 2.5,
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _fetchChallenges,
                  color: AppColors.accentBlue,
                  backgroundColor: AppColors.cardSurface,
                  child: visible.isEmpty
                      ? ListView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.18),
                            NoDataComponent(
                              title: l10n?.noChallengesFound ?? 'No challenges found',
                              subtitle: l10n?.nothingMatchesSearch ??
                                  'Nothing matches $_selectedFilter right now.',
                            ),
                          ],
                        )
                      : ListView.separated(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                          itemCount: visible.length + (hasMore ? 1 : 0),
                          separatorBuilder: (_, __) => const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            if (index >= visible.length) {
                              return const LoadingMoreLabel();
                            }
                            return _buildChallengeCard(visible[index]);
                          },
                        ),
                );
              }),
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
                            child: Icon(Icons.fitness_center, color: AppColors.textCaption),
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
                            child: Icon(Icons.fitness_center, color: AppColors.textCaption),
                          ),
                        ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
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
