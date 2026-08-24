class ChecklistResponse {
  final int id;
  final String itemName;
  final bool completed;

  ChecklistResponse({
    required this.id,
    required this.itemName,
    required this.completed,
  });

  factory ChecklistResponse.fromJson(Map<String, dynamic> json) {
    return ChecklistResponse(
      id: json['id'] ?? 0,
      itemName: json['itemName'] ?? '',
      completed: json['completed'] ?? false,
    );
  }
}
