class TripChecklistResponse {
  final int id;
  final String itemName;
  final bool completed;

  TripChecklistResponse({
    required this.id,
    required this.itemName,
    required this.completed,
  });

  factory TripChecklistResponse.fromJson(Map<String, dynamic> json) {
    return TripChecklistResponse(
      id: json['id'],
      itemName: json['itemName']?.toString() ?? '',
      completed: json['completed'] ?? false,
    );
  }
}
