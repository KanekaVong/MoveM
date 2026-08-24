class LabelResponse {
  final int id;
  final String name;
  final String color;

  LabelResponse({
    required this.id,
    required this.name,
    required this.color,
  });

  factory LabelResponse.fromJson(Map<String, dynamic> json) {
    return LabelResponse(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      color: json['color'] ?? '',
    );
  }
}
