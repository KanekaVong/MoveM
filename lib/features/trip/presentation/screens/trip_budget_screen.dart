import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/trip_budget_action_panel.dart';
import '../widgets/clear_glass_container.dart';
import '../../data/dto/response/trip_budget_response.dart';
import '../controllers/trip_budget_controller.dart';
import 'trip_budget_history_screen.dart';

class TripBudgetScreen extends StatefulWidget {
  final TripBudgetController budgetController;

  const TripBudgetScreen({
    super.key,
    required this.budgetController,
  });

  @override
  State<TripBudgetScreen> createState() => _TripBudgetScreenState();
}

class _TripBudgetScreenState extends State<TripBudgetScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.budgetController.loadBudget();
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
          // Background Image with dark overlay
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
                    return RefreshIndicator(
                      onRefresh: controller.loadBudget,
                      color: Colors.white,
                      backgroundColor: const Color(0xFF0F172A),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: Column(
                          children: [

                            // Budget Overview
                            ClearGlassContainer(
                              padding: const EdgeInsets.all(20),
                              borderRadius: 24,
                              backgroundOpacity: 0.20,
                              borderOpacity: 0.18,
                              child: _buildBudgetHeader(
                                l10n,
                                controller.totalBudget.value,
                                controller.budgets,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Categories
                            ClearGlassContainer(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 24,
                              ),
                              borderRadius: 28,
                              backgroundOpacity: 0.20,
                              borderOpacity: 0.18,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildCategoriesHeader(l10n),

                                  const SizedBox(height: 20),

                                  ...controller.budgets.map(
                                        (budget) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: _buildCategoryItem(
                                        context,
                                        controller,
                                        budget,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Add Expense / Budget
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  useSafeArea: false,
                                  builder: (sheetContext) {
                                    final keyboardHeight =
                                        MediaQuery.viewInsetsOf(sheetContext).bottom;

                                    return AnimatedPadding(
                                      duration: const Duration(milliseconds: 250),
                                      curve: Curves.easeOut,
                                      padding: EdgeInsets.only(
                                        bottom: keyboardHeight,
                                      ),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: MediaQuery.sizeOf(sheetContext).height * 0.42,
                                        child: TripBudgetActionPanel(
                                          budgetController: controller,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: ClearGlassContainer(
                                padding: EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                borderRadius: 20,
                                backgroundOpacity: 0.20,
                                borderOpacity: 0.18,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      l10n.addExpenseBudget,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),
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

  // App bar
  Widget _buildAppBar(BuildContext context, AppLocalizations l10n,) {

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const ClearGlassContainer(
              borderRadius: 50,
              padding: EdgeInsets.all(10),
              backgroundOpacity: 0.20,
              borderOpacity: 0.20,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                l10n.tripExpenses,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 40),
        ],
      ),
    );
  }

  // Header
  Widget _buildBudgetHeader(
      AppLocalizations l10n,
      double totalAmount,
      List<TripBudgetResponse> budgets,
      ) {
    final totalSpent = budgets.fold<double>(
      0,
          (sum, budget) => sum + (budget.spentAmount ?? 0),
    );

    final totalRemaining = totalAmount - totalSpent;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.totalBudget,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '\$${totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),

            const ClearGlassContainer(
              borderRadius: 50,
              padding: EdgeInsets.all(10),
              backgroundOpacity: 0.25,
              borderOpacity: 0.30,
              child: Icon(
                Icons.account_balance_wallet_rounded,
                color: Color(0xFFFF9800),
                size: 20,
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        Row(
          children: [
            Expanded(
              child: _buildHeaderStat(
                label: l10n.spent,
                amount: totalSpent,
                icon: Icons.trending_down_rounded,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _buildHeaderStat(
                label: l10n.remaining,
                amount: totalRemaining,
                icon: Icons.account_balance_wallet_outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderStat({
    required String label,
    required double amount,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.10),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white60,
            size: 16,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  '\$${amount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Category Header
  Widget _buildCategoriesHeader(
      AppLocalizations l10n,
      ) {
    return Row(
      children: [
       Text(
          l10n.categories,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(width: 8),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.more_horiz,
            color: Colors.white70,
            size: 16,
          ),
        ),
      ],
    );
  }


  // _buildCategoryItem
  Widget _buildCategoryItem(
      BuildContext context,
      TripBudgetController controller,
      TripBudgetResponse budget,
      ) {
    final l10n = AppLocalizations.of(context)!;
    final iconData = _getCategoryIcon(budget.category);
    final iconColor = _getCategoryColor(budget.category);
    final title = _formatCategory(l10n, budget.category,).toUpperCase();
    final allocated = budget.allocatedAmount ?? 0;

    final latestExpense =
    controller.getLatestExpenseForBudget(budget.id);

    return GestureDetector(
      onTap: () {
        Get.to(
              () => TripBudgetHistoryScreen(
            budgetController: controller,
            selectedBudget: budget,
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClearGlassContainer(
            borderRadius: 14,
            padding: const EdgeInsets.all(10),
            backgroundOpacity: 0.20,
            borderOpacity: 0.20,
            child: Icon(
              iconData,
              color: iconColor,
              size: 20,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  latestExpense != null
                      ? l10n.paidBy(
                    '\$${(latestExpense.amount ?? 0).toStringAsFixed(0)}',
                    latestExpense.payerName ?? l10n.unknown,
                  )
                      : '\$${allocated.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right_rounded,
            color: Colors.white38,
            size: 20,
          ),
        ],
      ),
    );
  }

  // edit budget
  Future<void> _showEditBudgetDialog(
      BuildContext context,
      TripBudgetController controller,
      TripBudgetResponse budget,
      ) async {
    final textController = TextEditingController(
      text: (budget.allocatedAmount ?? 0).toStringAsFixed(0),
    );

    final l10n = AppLocalizations.of(context)!;

    final amount = await showDialog<double>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClearGlassContainer(
            borderRadius: 24,
            padding: const EdgeInsets.all(20),
            backgroundOpacity: 0.85,
            borderOpacity: 0.30,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.editCategory(
                    _formatCategory(
                      l10n,
                      budget.category,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: textController,
                  keyboardType:
                  const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.allocatedAmount,
                    labelStyle: const TextStyle(
                      color: Colors.white60,
                    ),
                    prefixText: '\$ ',
                    prefixStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(
                      alpha: 0.08,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        l10n.cancel,
                        style: TextStyle(
                          color: Colors.white60,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    ElevatedButton(
                      onPressed: () {
                        final value = double.tryParse(
                          textController.text.trim(),
                        );

                        if (value == null || value < 0) {
                          return;
                        }

                        Navigator.pop(context, value);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(l10n.save),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    textController.dispose();

    if (amount == null) return;

    await controller.updateBudget(
      budget: budget,
      allocatedAmount: amount,
    );
  }

  // CATEGORY ICON
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

  // CATEGORY COLOR
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

  // CATEGORY NAME
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