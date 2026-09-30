class TripExpenseSplitRequest {
  final String splitMode;
  final List<Map<String, dynamic>> customSplits;

  TripExpenseSplitRequest({
    required this.splitMode,
    required this.customSplits,
  });

  Map<String, dynamic> toJson() {
    return {
      'splitMode': splitMode,
      'customSplits': customSplits,
    };
  }
}