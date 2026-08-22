class FitnessProfileModel {
  final int userId;
  final double height; // in cm
  final double weight; // in kg
  final double bmi;
  final DateTime? updatedAt;

  FitnessProfileModel({
    required this.userId,
    required this.height,
    required this.weight,
    required this.bmi,
    this.updatedAt,
  });

  factory FitnessProfileModel.fromJson(Map<String, dynamic> json) {
    return FitnessProfileModel(
      userId: json['userId'] ?? 0,
      height: (json['height'] ?? 0).toDouble(),
      weight: (json['weight'] ?? 0).toDouble(),
      bmi: (json['bmi'] ?? 0).toDouble(),
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'height': height,
      'weight': weight,
      'bmi': bmi,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
