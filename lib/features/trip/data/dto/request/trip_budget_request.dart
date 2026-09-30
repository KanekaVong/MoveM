class TripBudgetRequest {
  final int id;
  final String category;
  final double allocatedAmount;

  TripBudgetRequest({
    required this.id,
    required this.category,
    required this.allocatedAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'allocatedAmount': allocatedAmount,
    };
  }
}