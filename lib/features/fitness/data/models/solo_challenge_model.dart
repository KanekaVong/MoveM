class SoloChallengeModel {
  final int id;
  final String name;
  final String type;
  final String workoutLevel;
  final int targetValue;
  final String targetUnit;
  final int calories;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SoloChallengeModel({
    required this.id,
    required this.name,
    required this.type,
    required this.workoutLevel,
    required this.targetValue,
    required this.targetUnit,
    required this.calories,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory SoloChallengeModel.fromJson(Map<String, dynamic> json) {
    return SoloChallengeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      workoutLevel: json['workoutLevel'] ?? '',
      targetValue: json['targetValue'] ?? 0,
      targetUnit: json['targetUnit'] ?? '',
      calories: json['calories'] ?? 0,
      description: json['description'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }
}
