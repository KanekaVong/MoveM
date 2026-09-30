class TripExpenseRequest {
  final int budgetId;
  final double amount;
  final String description;
  final DateTime expenseDate;
  final int payerId;
  final String splitMode;
  final List<TripExpenseCustomSplitRequest> customSplits;

  TripExpenseRequest({
    required this.budgetId,
    required this.amount,
    required this.description,
    required this.expenseDate,
    required this.payerId,
    required this.splitMode,
    required this.customSplits,
  });

  Map<String, dynamic> toJson() {
    return {
      'budgetId': budgetId,
      'amount': amount,
      'description': description,
      'expenseDate': expenseDate.toUtc().toIso8601String(),
      'payerId': payerId,
      'splitMode': splitMode,
      'customSplits': customSplits.map((e) => e.toJson()).toList(),
    };
  }
}

class TripExpenseCustomSplitRequest {
  final int userId;
  final double amount;

  TripExpenseCustomSplitRequest({
    required this.userId,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'amount': amount,
    };
  }
}