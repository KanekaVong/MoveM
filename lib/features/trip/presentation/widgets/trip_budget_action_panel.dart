import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../../../../l10n/app_localizations.dart';
import '../../data/dto/response/trip_budget_response.dart';
import '../controllers/trip_budget_controller.dart';
import 'clear_glass_container.dart';

class TripBudgetActionPanel extends StatefulWidget {
  final TripBudgetController budgetController;
  final TripBudgetResponse? budget;

  const TripBudgetActionPanel({
    super.key,
    required this.budgetController,
    this.budget,
  });

  @override
  State<TripBudgetActionPanel> createState() =>
      _TripBudgetActionPanelState();
}

class _TripBudgetActionPanelState
    extends State<TripBudgetActionPanel> {

  final RxBool isExpense = true.obs;

  final RxDouble amount = 0.0.obs;

  final RxnString selectedCategory = RxnString();

  final RxString description = ''.obs;

  final TextEditingController descriptionController =
  TextEditingController();

  final TextEditingController amountController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    // Default to the first available budget category.
    if (widget.budgetController.budgets.isNotEmpty) {
      selectedCategory.value =
          widget.budgetController.budgets.first.category;
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // BUILD
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(32),
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(32),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 18,
            sigmaY: 18,
          ),
          child: SafeArea(
            top: false,
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                20,
              ),
              child: Obx(
                    () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(l10n),

                    const SizedBox(height: 20),

                    _buildModeToggle(l10n),

                    const SizedBox(height: 24),

                    _buildAmount(l10n),

                    if (isExpense.value) ...[
                      const SizedBox(height: 16),
                      _buildExpenseOptions(l10n),
                    ],

                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  // header
  Widget _buildHeader(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: Text(
            isExpense.value
                ? l10n.addExpense
                : l10n.addBudget,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        GestureDetector(
          onTap: _submit,
          child: const ClearGlassContainer(
            borderRadius: 50,
            padding: EdgeInsets.all(10),
            backgroundOpacity: 0.20,
            borderOpacity: 0.25,
            child: Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }


  // BUDGET / EXPENSE TOGGLE
  Widget _buildModeToggle(AppLocalizations l10n) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.10),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildModeButton(
              title: l10n.budget,
              selected: !isExpense.value,
              onTap: () {
                _setMode(false);
              },
            ),
          ),
          Expanded(
            child: _buildModeButton(
              title: l10n.expense,
              selected: isExpense.value,
              onTap: () {
                _setMode(true);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseOptions(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: _buildDescriptionButton(l10n),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _buildCategoryButton(l10n),
        ),
      ],
    );
  }

  void _showDescriptionInput(AppLocalizations l10n) {
    descriptionController.text = description.value;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: ClearGlassContainer(
              padding: const EdgeInsets.all(20),
              borderRadius: 28,
              backgroundOpacity: 0.85,
              borderOpacity: 0.25,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ClearGlassContainer(
                        borderRadius: 14,
                        padding: EdgeInsets.all(10),
                        backgroundOpacity: 0.2,
                        borderOpacity: 0.2,
                        child: Icon(
                          Icons.note_alt_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.addDescriptions,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              l10n.descriptionDetailsHint,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      GestureDetector(
                        onTap: () {
                          description.value =
                              descriptionController.text.trim();

                          Navigator.pop(dialogContext);
                        },
                        child: const ClearGlassContainer(
                          borderRadius: 50,
                          padding: EdgeInsets.all(8),
                          backgroundOpacity: 0.25,
                          borderOpacity: 0.3,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Text Field
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: descriptionController,
                    builder: (context, value, child) {
                      final charCount = value.text.length;

                      return Container(
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Stack(
                          children: [
                            TextField(
                              controller: descriptionController,
                              autofocus: false,
                              maxLength: 100,
                              maxLines: null,
                              expands: true,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: l10n.descriptionHint,
                                hintStyle: const TextStyle(
                                  color: Colors.white38,
                                ),
                                contentPadding: const EdgeInsets.all(14),
                                border: InputBorder.none,
                                counterText: '',
                              ),
                              onChanged: (val) {
                                description.value = val;
                              },
                            ),

                            Positioned(
                              right: 12,
                              bottom: 8,
                              child: Text(
                                '$charCount/100',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
          ),
        );
      },
    );
  }

  Widget _buildDescriptionButton(AppLocalizations l10n) {
    return GestureDetector(
      onTap: () => _showDescriptionInput(l10n),
      child: SizedBox(
        height: 52,
        child: ClearGlassContainer(
          borderRadius: 16,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
          ),
          backgroundOpacity: 0.10,
          borderOpacity: 0.15,
          child: Row(
            children: [
              const Icon(
                Icons.description_outlined,
                color: Colors.white70,
                size: 19,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Obx(
                      () => Text(
                    description.value.trim().isEmpty
                        ? l10n.description
                        : description.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: description.value.trim().isEmpty
                          ? Colors.white60
                          : Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const Icon(
                Icons.edit_rounded,
                color: Colors.white54,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(AppLocalizations l10n) {
    return GestureDetector(
      onTap: () => _showCategorySelector(l10n),
      child: SizedBox(
        height: 52,
        child: ClearGlassContainer(
          borderRadius: 16,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
          ),
          backgroundOpacity: 0.10,
          borderOpacity: 0.15,
          child: Row(
            children: [
              Icon(
                Icons.folder_outlined,
                color: _getCategoryColor(
                  selectedCategory.value,
                ),
                size: 19,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  selectedCategory.value == null
                      ? l10n.type
                      : _formatCategory(l10n, selectedCategory.value,),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white54,
                size: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? Colors.white.withValues(alpha: 0.16)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            color: selected
                ? Colors.white
                : Colors.white54,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  // amount
  Widget _buildAmount(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: ClearGlassContainer(
        borderRadius: 20,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        backgroundOpacity: 0.12,
        borderOpacity: 0.16,
        child: Row(
          children: [
            const Text(
              '\$',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.done,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
                decoration: InputDecoration(
                  hintText: '0.00',
                  hintStyle: const TextStyle(
                    color: Colors.white30,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
                onChanged: (value) {
                  amount.value = double.tryParse(value) ?? 0;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // category selector
  Future<void> _showCategorySelector(
      AppLocalizations l10n,
      ) async {
    final budgets = widget.budgetController.budgets;

    if (budgets.isEmpty) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF111827).withValues(
              alpha: 0.96,
            ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    l10n.type,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 16),

                  ...budgets.map(
                        (budget) => _buildCategoryOption(budget, context, l10n,),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryOption(
      TripBudgetResponse budget,
      BuildContext context,
      AppLocalizations l10n,
      ) {
    final selected =
        selectedCategory.value == budget.category;

    return GestureDetector(
      onTap: () {
        selectedCategory.value = budget.category;
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white.withValues(alpha: 0.14)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? Colors.white.withValues(alpha: 0.20)
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            Icon(
              _getCategoryIcon(budget.category),
              color: _getCategoryColor(budget.category),
              size: 20,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                _formatCategory(l10n, budget.category,),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            if (selected)
              const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }


  // SUBMIT
  Future<void> _submit() async {
    if (amount.value <= 0) {
      return;
    }

    if (isExpense.value) {
      final selected = selectedCategory.value;

      if (selected == null) {
        return;
      }

      if (description.value.trim().isEmpty) {
        return;
      }

      final budget =
      widget.budgetController.budgets.firstWhereOrNull(
            (item) => item.category == selected,
      );

      if (budget == null) {
        return;
      }

      final success =
      await widget.budgetController.createExpense(
        budget: budget,
        amount: amount.value,
        description: description.value.trim(),
      );

      if (success && mounted) {
        Navigator.pop(context);
      }

      return;
    }

    // BUDGET
    final success =
    await widget.budgetController.updateTotalBudget(
      totalBudget: amount.value,
    );

    if (success && mounted) {
      Navigator.pop(context);
    }
  }


  // category helper
  IconData _getCategoryIcon(String? category) {
    switch (category) {
      case 'FOOD_DRINKS':
        return Icons.restaurant_rounded;

      case 'ACCOMMODATIONS':
        return Icons.hotel_rounded;

      case 'TRANSPORTATION':
        return Icons.directions_car_rounded;

      case 'OTHERS':
        return Icons.category_rounded;

      default:
        return Icons.category_rounded;
    }
  }

  Color _getCategoryColor(String? category) {
    switch (category) {
      case 'FOOD_DRINKS':
        return const Color(0xFFFF9800);

      case 'ACCOMMODATIONS':
        return const Color(0xFF43A047);

      case 'TRANSPORTATION':
        return const Color(0xFF29B6F6);

      case 'OTHERS':
        return const Color(0xFFAB47BC);

      default:
        return Colors.white70;
    }
  }

  String _formatCategory(
      AppLocalizations l10n,
      String? category,
      ) {
    switch (category) {
      case 'FOOD_DRINKS':
        return l10n.foodsAndDrinks;

      case 'ACCOMMODATIONS':
        return l10n.accommodations;

      case 'TRANSPORTATION':
        return l10n.transportation;

      case 'OTHERS':
        return l10n.others;

      default:
        return l10n.others;
    }
  }

  void _setMode(bool expenseMode) {
    isExpense.value = expenseMode;

    if (expenseMode) {
      amount.value = 0;
      amountController.clear();
      return;
    }

    _loadTotalBudget();
  }

  void _loadTotalBudget() {
    final total = widget.budgetController.totalBudget.value;

    amount.value = total;
    amountController.text = total.toStringAsFixed(2);

    amountController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: amountController.text.length,
      ),
    );
  }


}