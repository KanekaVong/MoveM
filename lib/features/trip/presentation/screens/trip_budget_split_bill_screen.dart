import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/trip_budget_controller.dart';
import '../../data/dto/response/trip_expense_response.dart';
import 'package:movem/core/storage/user_manager.dart';
import '../controllers/trip_budget_controller.dart';

class TripBudgetSplitBillScreen extends StatefulWidget {
  final TripExpenseResponse expense;
  final TripBudgetController budgetController;
  final String tripActivityId;


  const TripBudgetSplitBillScreen({
    super.key,
    required this.budgetController,
    required this.tripActivityId,
    required this.expense,
  });

  @override
  State<TripBudgetSplitBillScreen> createState() =>
      _TripBudgetSplitBillScreenState();
}

class _TripBudgetSplitBillScreenState
    extends State<TripBudgetSplitBillScreen> {

  final Rxn<TripExpenseResponse> currentExpense =
  Rxn<TripExpenseResponse>();
  final ScrollController scrollController = ScrollController();

  final RxString splitType = 'EQUAL'.obs;

  late final List<TextEditingController> customAmountControllers;
  late final List<FocusNode> customAmountFocusNodes;
  late final List<GlobalKey> customAmountKeys;


  @override
  void initState() {
    super.initState();


    currentExpense.value = widget.expense;

    customAmountControllers = widget.expense.splits
        .map(
          (split) => TextEditingController(
        text: (split.amountOwed ?? 0).toStringAsFixed(2),
      ),
    )
        .toList();

    customAmountFocusNodes = List.generate(
      widget.expense.splits.length,
          (_) => FocusNode(),
    );

    customAmountKeys = List.generate(
      widget.expense.splits.length,
          (_) => GlobalKey(),
    );
    for (int i = 0; i < customAmountFocusNodes.length; i++) {
      final index = i;

      customAmountFocusNodes[index].addListener(() {
        if (!customAmountFocusNodes[index].hasFocus) {
          return;
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToCustomField(index);
        });
      });
    }
  }

  void _scrollToCustomField(int index) {
    if (!mounted) {
      return;
    }

    final fieldContext =
        customAmountKeys[index].currentContext;

    if (fieldContext == null) {
      return;
    }

    Scrollable.ensureVisible(
      fieldContext,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      alignment: 0.25,
    );
  }

  bool get isViewMode {
    final expenseId = currentExpense.value?.id;

    if (expenseId == null) {
      return false;
    }

    return widget.budgetController
        .splitBillCreatedExpenseIds
        .contains(expenseId);
  }

  @override
  void dispose() {
    scrollController.dispose();

    for (final controller in customAmountControllers) {
      controller.dispose();
    }

    for (final focusNode in customAmountFocusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                _buildAppBar(l10n),

                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.fromLTRB(
                      20,
                      12,
                      20,
                      40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSubtitle(l10n),

                        const SizedBox(height: 20),

                        _buildMembers(l10n),

                        const SizedBox(height: 24),

                        _buildExpenseSection(l10n),

                        const SizedBox(height: 28),

                        Obx(() {
                          if (isViewMode) {
                            return _buildViewBills(l10n);
                          }

                          return Column(
                            children: [
                              _buildSplitType(l10n),

                              const SizedBox(height: 18),

                              if (splitType.value == 'EQUAL')
                                _buildEqualSplit(l10n)
                              else
                                _buildCustomSplit(l10n),

                              const SizedBox(height: 30),

                              _buildCreateButton(l10n),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewBills(AppLocalizations l10n) {
    final expense = currentExpense.value;

    if (expense == null) {
      return const SizedBox.shrink();
    }

    final mode = widget.budgetController
        .splitModes[expense.id] ?? 'EQUAL';

    final currentUserId = int.tryParse(
      UserManager().userId ?? '',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.splitType,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.16),
            ),
          ),
          child: Text(
            mode == 'CUSTOM'
                ? l10n.custom.toUpperCase()
                : l10n.equal.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ),

        const SizedBox(height: 20),

        ...expense.splits.map(
              (split) {
            final isCurrentUser =
                split.userId == currentUserId;

            return Padding(
              padding: const EdgeInsets.only(
                bottom: 16,
              ),
              child: Row(
                children: [
                  _buildMemberAvatar(
                    split.username,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          split.username ?? l10n.unknown,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '\$${(split.amountOwed ?? 0).toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _buildSettlementStatus(
                    l10n,
                    split,
                    isCurrentUser,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSettlementStatus(
      AppLocalizations l10n,
      TripExpenseSplitResponse split,
      bool isCurrentUser,
      ) {
    if (split.isSettled == true) {
      return _buildStatusChip(
        text: l10n.paid,
      );
    }

    if (!isCurrentUser) {
      return _buildStatusChip(
        text: l10n.pending,
      );
    }

    return GestureDetector(
      onTap: () => _confirmSettlement(
        l10n,
        split,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.18),
          ),
        ),
        child: Text(
          l10n.alreadySettled,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip({
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Future<void> _confirmSettlement(
      AppLocalizations l10n,
      TripExpenseSplitResponse split,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            l10n.confirmSettlement,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            l10n.confirmSettlementMessage,
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
                  color: Colors.white70,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text(
                l10n.settle,
                style: const TextStyle(
                  color: Colors.white,
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

    if (split.id == null || currentExpense.value?.id == null) {
      return;
    }

    final success =
    await widget.budgetController.settleSplit(
      expenseId: currentExpense.value!.id!,
      splitId: split.id!,
    );

    if (!mounted || !success) {
      return;
    }

    final updatedExpense =
    widget.budgetController.expenses.firstWhereOrNull(
          (expense) =>
      expense.id == currentExpense.value!.id,
    );

    if (updatedExpense != null) {
      currentExpense.value = updatedExpense;
    }
  }

  Widget _buildAppBar(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: Get.back,
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
            child: Text(
              l10n.splitBills,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle(AppLocalizations l10n) {
    return Text(
      l10n.splitBillsWithFriends,
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildMembers(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.members,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.expense.splits.length,
            separatorBuilder: (_, __) =>
            const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final split =
              widget.expense.splits[index];

              return _buildMemberAvatar(
                split.username,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMemberAvatar(String? username) {
    final name = username?.trim() ?? '';

    final initial = name.isEmpty
        ? '?'
        : name[0].toUpperCase();

    return CircleAvatar(
      radius: 20,
      backgroundColor:
      Colors.white.withValues(alpha: 0.12),
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildExpenseSection(
      AppLocalizations l10n,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.expenseAmount,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          '\$${(widget.expense.amount ?? 0).toStringAsFixed(2)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),

        const SizedBox(height: 14),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 14,
          ),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(
                  alpha: 0.18,
                ),
              ),
              bottom: BorderSide(
                color: Colors.white.withValues(
                  alpha: 0.18,
                ),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      l10n.expensePaidBy(
                        '\$${(widget.expense.amount ?? 0).toStringAsFixed(2)}',
                        widget.expense.payerName ??
                            l10n.unknown,
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Text(
                    _formatExpenseDate(
                      widget.expense.expenseDate,
                      context,
                    ),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                '"${widget.expense.description ?? ''}"',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSplitType(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.splitType,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          width: double.infinity,
          height: 52,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(
              alpha: 0.28,
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.20,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Obx(
                      () => _buildSplitTypeButton(
                    title: l10n.equal,
                    selected: splitType.value == 'EQUAL',
                    onTap: () {
                      splitType.value = 'EQUAL';
                    },
                  ),
                ),
              ),

              const SizedBox(width: 4),

              Expanded(
                child: Obx(
                      () => _buildSplitTypeButton(
                    title: l10n.custom,
                    selected: splitType.value == 'CUSTOM',
                    onTap: () {
                      splitType.value = 'CUSTOM';
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSplitTypeButton({
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
              ? Colors.white.withValues(alpha: 0.22)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: selected
                ? Colors.white.withValues(alpha: 0.30)
                : Colors.transparent,
          ),
        ),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            color: selected
                ? Colors.white
                : Colors.white54,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  Widget _buildEqualSplit(AppLocalizations l10n) {
    return Obx(
          () => Column(
        children: [
          ...(currentExpense.value?.splits ?? []).map(
                (split) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  _buildMemberAvatar(split.username),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      split.username ?? l10n.unknown,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    '\$${(split.amountOwed ?? 0).toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
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

  Widget _buildCustomSplit(
      AppLocalizations l10n,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.splitAmount,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 12),

        ...widget.expense.splits.asMap().entries.map(
              (entry) {
            final index = entry.key;
            final split = entry.value;

            return Padding(
              padding: const EdgeInsets.only(
                bottom: 14,
              ),
              child: Row(
                children: [
                  _buildMemberAvatar(
                    split.username,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      split.username ?? l10n.unknown,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const Text(
                    '\$',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(width: 6),

                  SizedBox(
                    key: customAmountKeys[index],
                    width: 95,
                    height: 42,
                    child: TextField(
                      focusNode: customAmountFocusNodes[index],
                      controller: customAmountControllers[index],
                      keyboardType:
                      const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.done,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        hintText: '0.00',
                        hintStyle: const TextStyle(
                          color: Colors.white30,
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(
                          alpha: 0.08,
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCreateButton(AppLocalizations l10n) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final buttonColor =
    isDark ? const Color(0xFFF1F5F9) : AppColors.commentBarBg;

    final textColor =
    isDark ? AppColors.commentBarBg : Colors.white;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: _createSplitBill,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(
          Icons.add_rounded,
          size: 18,
        ),
        label: Text(
          l10n.createSplitBill,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Future<void> _createSplitBill() async {
    final mode = splitType.value;

    List<Map<String, dynamic>> customSplits = [];

    if (mode == 'CUSTOM') {
      customSplits = widget.expense.splits
          .asMap()
          .entries
          .map(
            (entry) {
          final index = entry.key;
          final split = entry.value;

          final amount = double.tryParse(
            customAmountControllers[index].text.trim(),
          );

          return {
            'userId': split.userId,
            'amount': amount ?? 0,
          };
        },
      )
          .toList();
    }

    final updatedExpense =
    await widget.budgetController.createSplitBill(
      tripActivityId: widget.tripActivityId,
      expenseId: widget.expense.id!,
      splitMode: mode,
      customSplits: customSplits,
    );

    if (!mounted || updatedExpense == null) {
      return;
    }

    currentExpense.value = updatedExpense;

    for (int i = 0;
    i < updatedExpense.splits.length &&
        i < customAmountControllers.length;
    i++) {
      customAmountControllers[i].text =
          (updatedExpense.splits[i].amountOwed ?? 0)
              .toStringAsFixed(2);
    }
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
}