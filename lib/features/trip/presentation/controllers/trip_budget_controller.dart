import 'package:get/get.dart';

import '../../../../shared/base/base_controller.dart';
import '../../data/dto/request/trip_budget_request.dart';
import '../../data/dto/response/trip_budget_response.dart';
import '../../domain/repositories/trip_repository.dart';
import 'package:movem/core/storage/user_manager.dart';
import '../../data/dto/request/trip_expense_request.dart';
import '../../data/dto/response/trip_expense_response.dart';
import '../../data/dto/request/update_trip_request.dart';
import '../../data/dto/response/trip_response.dart';
import '../../data/dto/request/trip_expense_split_request.dart';


class TripBudgetController extends BaseController {
  final TripRepository repository;
  final String activityId;

  TripBudgetController({
    required this.repository,
    required this.activityId,
  });

  final Rxn<TripResponse> trip = Rxn<TripResponse>();

  final budgets = <TripBudgetResponse>[].obs;
  final expenses = <TripExpenseResponse>[].obs;
  final totalBudget = 0.0.obs;

  final RxSet<int> splitBillCreatedExpenseIds = <int>{}.obs;
  final RxMap<int, String> splitModes = <int, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadBudget();
    loadExpenses();
  }

  Future<void> loadBudget() async {
    await executeApi(
      apiCall: () async {
        return await repository.getTripDetail(activityId);
      },
      onSuccess: (result) {
        if (result == null) return;

        trip.value = result;
        totalBudget.value = result.totalBudget ?? 0;
        budgets.assignAll(result.budgets);
      },
    );
  }

  Future<void> loadExpenses() async {
    await executeApi(
      apiCall: () => repository.getTripExpenses(activityId),
      onSuccess: (result) {
        if (result == null) {
          expenses.clear();
          return;
        }

        expenses.assignAll(result);
      },
    );
  }

  TripExpenseResponse? getLatestExpenseForBudget(int? budgetId) {
    if (budgetId == null) {
      return null;
    }

    final matchingExpenses = expenses.where(
      (expense) => expense.budgetId == budgetId,
    );

    if (matchingExpenses.isEmpty) {
      return null;
    }

    TripExpenseResponse? latest;

    for (final expense in matchingExpenses) {
      if (latest == null) {
        latest = expense;
        continue;
      }

      final currentDate = expense.expenseDate;
      final latestDate = latest.expenseDate;

      if (currentDate != null &&
          (latestDate == null || currentDate.isAfter(latestDate))) {
        latest = expense;
      }
    }

    return latest;
  }

  Future<bool> updateTotalBudget({
    required double totalBudget,
  }) async {
    final currentTrip = trip.value;

    if (currentTrip == null) {
      return false;
    }

    var success = false;

    await executeApi(
      apiCall: () => repository.updateTrip(
        activityId,
        UpdateTripRequest(
          activityName: currentTrip.activityName,
          startActivity: currentTrip.startActivity,
          deadline: currentTrip.deadline,
          destination: currentTrip.destination,
          totalBudget: totalBudget,
        ),
      ),
      onSuccess: (result) {
        if (result == null) return;

        trip.value = result;
        this.totalBudget.value =
            result.totalBudget ?? totalBudget;
        budgets.assignAll(result.budgets);

        success = true;
      },
    );

    return success;
  }

  Future<bool> updateBudget({
    required TripBudgetResponse budget,
    required double allocatedAmount,
  }) async {
    if (budget.id == null || budget.category == null) {
      return false;
    }

    var success = false;

    await executeApi(
      apiCall: () => repository.updateTripBudget(
        activityId,
        budget.id!,
        TripBudgetRequest(
          id: budget.id!,
          category: budget.category!,
          allocatedAmount: allocatedAmount,
        ),
      ),
      onSuccess: (updatedBudget) {
        if (updatedBudget == null) {
          return;
        }

        final index = budgets.indexWhere(
          (item) => item.id == updatedBudget.id,
        );

        if (index != -1) {
          budgets[index] = updatedBudget;
        }

        success = true;
      },
    );

    return success;
  }

  Future<bool> createExpense({
    required TripBudgetResponse budget,
    required double amount,
    required String description,
  }) async {
    if (budget.id == null) {
      return false;
    }

    final payerId = int.tryParse(
      UserManager().userId ?? '',
    );

    if (payerId == null) {
      return false;
    }

    var success = false;

    await executeApi(
      apiCall: () => repository.createTripExpense(
        activityId,
        TripExpenseRequest(
          budgetId: budget.id!,
          amount: amount,
          description: description,
          expenseDate: DateTime.now(),
          payerId: payerId,
          splitMode: 'EQUAL',
          customSplits: [],
        ),
      ),
      onSuccess: (expense) async {
        if (expense == null) {
          return;
        }

        success = true;

        await loadBudget();
        await loadExpenses();
      },
    );

    return success;
  }

  Future<bool> deleteExpense({
    required int expenseId,
  }) async {
    var success = false;

    await executeApi(
      apiCall: () => repository.deleteTripExpense(
        activityId,
        expenseId,
      ),
      onSuccess: (_) async {
        success = true;

        await loadBudget();
        await loadExpenses();
      },
    );

    return success;
  }

  Future<TripExpenseResponse?> createSplitBill({
    required String tripActivityId,
    required int expenseId,
    required String splitMode,
    required List<Map<String, dynamic>> customSplits,
  }) async {
    TripExpenseResponse? updatedExpense;

    await executeApi(
      apiCall: () => repository.createExpenseSplits(
        activityId,
        tripActivityId,
        expenseId,
        TripExpenseSplitRequest(
          splitMode: splitMode,
          customSplits: customSplits,
        ),
      ),
      onSuccess: (result) {
        if (result == null) {
          return;
        }

        updatedExpense = result;

        splitBillCreatedExpenseIds.add(expenseId);
        splitModes[expenseId] = splitMode;

        final index = expenses.indexWhere(
              (item) => item.id == expenseId,
        );

        if (index != -1) {
          expenses[index] = result;
        }
      },
    );

    return updatedExpense;
  }

  Future<bool> settleSplit({
    required int expenseId,
    required int splitId,
  }) async {
    var success = false;

    await executeApi(
      apiCall: () => repository.settleExpenseSplit(
        activityId,
        expenseId,
        splitId,
      ),
      onSuccess: (_) async {
        success = true;

        await loadExpenses();
      },
    );

    return success;
  }

}
