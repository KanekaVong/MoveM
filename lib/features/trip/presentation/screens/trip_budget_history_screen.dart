import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/trip_budget_controller.dart';
import '../widgets/clear_glass_container.dart';
import '../../data/dto/response/trip_budget_response.dart';
import '../../data/dto/response/trip_expense_response.dart';
import 'trip_budget_split_bill_screen.dart';

class TripBudgetHistoryScreen extends StatefulWidget {
  final TripBudgetController budgetController;
  final TripBudgetResponse? selectedBudget;

  const TripBudgetHistoryScreen({
    super.key,
    required this.budgetController,
    this.selectedBudget,
  });

  @override
  State<TripBudgetHistoryScreen> createState() =>
      _TripBudgetHistoryScreenState();
}

class _TripBudgetHistoryScreenState
    extends State<TripBudgetHistoryScreen> {
  late final RxnInt selectedBudgetId;

  @override
  void initState() {
    super.initState();

    selectedBudgetId =
        RxnInt(widget.selectedBudget?.id);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.budgetController.loadExpenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.budgetController;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/trip_detail_bg.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: Colors.black.withValues(alpha: 0.45),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context, l10n),

                Expanded(
                  child: Obx(() {
                    final expenses = _getFilteredExpenses(
                      controller.expenses,
                    );

                    return RefreshIndicator(
                      onRefresh: controller.loadExpenses,
                      color: Colors.white,
                      backgroundColor:
                      const Color(0xFF0F172A),
                      child: SingleChildScrollView(
                        physics:
                        const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          12,
                          20,
                          24,
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            _buildFilterButton(l10n),

                            const SizedBox(height: 24),

                            if (expenses.isEmpty)
                              _buildEmptyState(l10n)
                            else
                              _buildExpenseContent(
                                expenses,
                                controller.budgets,
                                l10n,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppLocalizations l10n,) {

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),

          const SizedBox(width: 4),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.history,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    l10n.trackAllYourExpenses,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton( AppLocalizations l10n,) {
    return GestureDetector(
      onTap: _showCategoryFilter,
      child: ClearGlassContainer(
        borderRadius: 16,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        backgroundOpacity: 0.20,
        borderOpacity: 0.18,
        child: Row(
          children: [
            Icon(
              selectedBudgetId.value == null
                  ? Icons.filter_list_rounded
                  : _getCategoryIcon(
                _selectedBudget()?.category,
              ),
              color: selectedBudgetId.value == null
                  ? Colors.white70
                  : _getCategoryColor(
                _selectedBudget()?.category,
              ),
              size: 18,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                _selectedBudgetLabel(l10n),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white70,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseContent(
      List<TripExpenseResponse> expenses,
      List<TripBudgetResponse> budgets,
      AppLocalizations l10n,
      ) {
    final isAllCategories =
        selectedBudgetId.value == null;

    if (!isAllCategories) {
      final budget = _selectedBudget();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryHeader(
            budget?.category,
            expenses.first.category,
            l10n,
          ),

          const SizedBox(height: 14),

          ...expenses.map(
                (expense) => _buildExpenseItem(
              expense,
              l10n,
            ),
          ),
        ],
      );
    }

    final grouped = <int, List<TripExpenseResponse>>{};

    for (final expense in expenses) {
      final budgetId = expense.budgetId;

      if (budgetId == null) {
        continue;
      }

      grouped.putIfAbsent(budgetId, () => []);
      grouped[budgetId]!.add(expense);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in grouped.entries) ...[
          _buildCategoryHeader(
            _findBudget(entry.key)?.category,
            entry.value.first.category,
            l10n,
          ),

          const SizedBox(height: 14),

          ...entry.value.map(
                (expense) => _buildExpenseItem(
              expense,
              l10n,
            ),
          ),

          const SizedBox(height: 28),
        ],
      ],
    );
  }

  Widget _buildCategoryHeader(
      String? budgetCategory,
      String? expenseCategory,
      AppLocalizations l10n,
      ) {
    final category =
        budgetCategory ?? expenseCategory;

    return Row(
      children: [
        Icon(
          _getCategoryIcon(category),
          color: _getCategoryColor(category),
          size: 21,
        ),

        const SizedBox(width: 10),

        Text(
          _formatCategory(l10n, category,).toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.9,
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseItem(TripExpenseResponse expense,  AppLocalizations l10n,) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  l10n.expensePaidBy(
                    '\$${(expense.amount ?? 0).toStringAsFixed(0)}',
                    expense.payerName ?? l10n.unknown,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Text(
                _formatExpenseDate(
                  expense.expenseDate,context,
                ),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '"${expense.description ?? ''}"',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSplitBillsButton(expense,l10n,),
                  const SizedBox(width: 8),
                  _buildDeleteButton(expense),
                ],
              )
            ],
          ),

          const SizedBox(height: 18),

          Container(
            height: 1,
            width: double.infinity,
            color: Colors.white.withValues(
              alpha: 0.10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSplitBillsButton(
      TripExpenseResponse expense,
      AppLocalizations l10n,
      ) {
    return Obx(
          () {
        final hasSplitBill = widget.budgetController
            .splitBillCreatedExpenseIds
            .contains(expense.id);

        return GestureDetector(
          onTap: () {
            Get.to(
                  () => TripBudgetSplitBillScreen(
                budgetController: widget.budgetController,
                tripActivityId: widget.budgetController.activityId,
                expense: expense,
              ),
            );
          },
          child: ClearGlassContainer(
            borderRadius: 10,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            backgroundOpacity: 0.16,
            borderOpacity: 0.18,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  hasSplitBill
                      ? Icons.receipt_long_rounded
                      : Icons.call_split_rounded,
                  color: Colors.white70,
                  size: 14,
                ),

                const SizedBox(width: 5),

                Text(
                  hasSplitBill
                      ? l10n.viewBills
                      : l10n.splitBills,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildEmptyState( AppLocalizations l10n,) {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_rounded,
            color: Colors.white24,
            size: 46,
          ),

          const SizedBox(height: 14),

          Text(
            l10n.expensesWillAppearHere,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            l10n.expensesWillAppearHere,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(
      TripExpenseResponse expense,
      ) {
    return GestureDetector(
      onTap: () => _confirmDeleteExpense(expense),
      child: const Padding(
        padding: EdgeInsets.all(6),
        child: Icon(
          Icons.delete_outline_rounded,
          color: Colors.redAccent,
          size: 19,
        ),
      ),
    );
  }

  Future<void> _confirmDeleteExpense(
      TripExpenseResponse expense,
      ) async {
    final l10n = AppLocalizations.of(context)!;

    if (expense.id == null) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            l10n.deleteExpense,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            l10n.deleteExpenseConfirmation(
              expense.description ?? '',
            ),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text(
                l10n.cancel,
                style: const TextStyle(
                  color: Colors.white60,
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text(
                l10n.delete,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await widget.budgetController.deleteExpense(
      expenseId: expense.id!,
    );
  }

  Future<void> _showCategoryFilter() async {
    final controller = widget.budgetController;
    final l10n = AppLocalizations.of(context)!;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.filterExpenses,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 16),

                _buildFilterOption(
                  label: l10n.allCategories,
                  icon: Icons.filter_list_rounded,
                  color: Colors.white70,
                  budgetId: null,
                ),

                ...controller.budgets.map(
                      (budget) => _buildFilterOption(
                    label: _formatCategory(
                      l10n,
                      budget.category,
                    ),
                    icon: _getCategoryIcon(
                      budget.category,
                    ),
                    color: _getCategoryColor(
                      budget.category,
                    ),
                    budgetId: budget.id,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterOption({
    required String label,
    required IconData icon,
    required Color color,
    required int? budgetId,
  }) {
    final isSelected =
        selectedBudgetId.value == budgetId;

    return GestureDetector(
      onTap: () {
        selectedBudgetId.value = budgetId;
        Get.back();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Colors.white70,
                  fontSize: 13,
                  fontWeight: isSelected
                      ? FontWeight.w800
                      : FontWeight.w500,
                ),
              ),
            ),

            if (isSelected)
              const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }

  List<TripExpenseResponse> _getFilteredExpenses(
      List<TripExpenseResponse> allExpenses,
      ) {
    final filtered = selectedBudgetId.value == null
        ? allExpenses.toList()
        : allExpenses
        .where(
          (expense) =>
      expense.budgetId ==
          selectedBudgetId.value,
    )
        .toList();

    filtered.sort((a, b) {
      final dateA = a.expenseDate ??
          DateTime.fromMillisecondsSinceEpoch(0);

      final dateB = b.expenseDate ??
          DateTime.fromMillisecondsSinceEpoch(0);

      return dateB.compareTo(dateA);
    });

    return filtered;
  }

  TripBudgetResponse? _selectedBudget() {
    final id = selectedBudgetId.value;

    if (id == null) {
      return null;
    }

    return _findBudget(id);
  }

  TripBudgetResponse? _findBudget(int budgetId) {
    return widget.budgetController.budgets
        .firstWhereOrNull(
          (budget) => budget.id == budgetId,
    );
  }

  String _selectedBudgetLabel(AppLocalizations l10n,) {
    final budget = _selectedBudget();

    if (budget == null) {
      return l10n.allCategories;
    }

    return _formatCategory(l10n, budget.category,);
  }

  String _formatExpenseDate(
      DateTime? date,
      BuildContext context,
      ) {
    if (date == null) {
      return '';
    }

    final locale = Localizations.localeOf(context);

    return DateFormat(
      'd MMMM yyyy | h:mma',
      locale.languageCode,
    ).format(date);
  }

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

}