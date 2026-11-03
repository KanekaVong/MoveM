class TripExpenseResponse {
  final int? id;
  final int? budgetId;
  final String? category;
  final int? payerId;
  final String? payerName;
  final double? amount;
  final String? description;
  final DateTime? expenseDate;
  final List<TripExpenseSplitResponse> splits;

  TripExpenseResponse({
    this.id,
    this.budgetId,
    this.category,
    this.payerId,
    this.payerName,
    this.amount,
    this.description,
    this.expenseDate,
    this.splits = const [],
  });

  factory TripExpenseResponse.fromJson(Map<String, dynamic> json) {
    return TripExpenseResponse(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      budgetId: json['budgetId'] is int
          ? json['budgetId']
          : int.tryParse(json['budgetId']?.toString() ?? ''),
      category: json['category']?.toString(),
      payerId: json['payerId'] is int
          ? json['payerId']
          : int.tryParse(json['payerId']?.toString() ?? ''),
      payerName: json['payerName']?.toString(),
      amount: json['amount'] != null
          ? double.tryParse(json['amount'].toString())
          : null,
      description: json['description']?.toString(),
      expenseDate: json['expenseDate'] != null
          ? DateTime.tryParse(json['expenseDate'].toString())
          : null,
      splits: (json['splits'] as List<dynamic>?)
          ?.map(
            (e) => TripExpenseSplitResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
          .toList() ??
          [],
    );
  }
}

class TripExpenseSplitResponse {
  final int? id;
  final int? userId;
  final String? username;
  final double? amountOwed;
  final bool? isSettled;
  final DateTime? settledAt;

  TripExpenseSplitResponse({
    this.id,
    this.userId,
    this.username,
    this.amountOwed,
    this.isSettled,
    this.settledAt,
  });

  factory TripExpenseSplitResponse.fromJson(Map<String, dynamic> json) {
    return TripExpenseSplitResponse(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      userId: json['userId'] is int
          ? json['userId']
          : int.tryParse(json['userId']?.toString() ?? ''),
      username: json['username']?.toString(),
      amountOwed: json['amountOwed'] != null
          ? double.tryParse(json['amountOwed'].toString())
          : null,
      isSettled: json['isSettled'] as bool?,
      settledAt: json['settledAt'] != null
          ? DateTime.tryParse(json['settledAt'].toString())
          : null,
    );
  }
}