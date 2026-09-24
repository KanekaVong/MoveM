class TripBudgetResponse {
  final int? id;
  final String? category;
  final double? allocatedAmount;
  final double? spentAmount;
  final double? remaining;
  final double? perPersonShare;

  TripBudgetResponse({
    this.id,
    this.category,
    this.allocatedAmount,
    this.spentAmount,
    this.remaining,
    this.perPersonShare,
  });

  factory TripBudgetResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return TripBudgetResponse(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(
        json['id']?.toString() ?? '',
      ),

      category: json['category']?.toString(),

      allocatedAmount: json['allocatedAmount'] != null
          ? double.tryParse(
        json['allocatedAmount'].toString(),
      )
          : null,

      spentAmount: json['spentAmount'] != null
          ? double.tryParse(
        json['spentAmount'].toString(),
      )
          : null,

      remaining: json['remaining'] != null
          ? double.tryParse(
        json['remaining'].toString(),
      )
          : null,

      perPersonShare: json['perPersonShare'] != null
          ? double.tryParse(
        json['perPersonShare'].toString(),
      )
          : null,
    );
  }
}