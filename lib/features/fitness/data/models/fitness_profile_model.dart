class FitnessGoalModel {
  final int id;
  final int userId;
  final String goalType;
  final double targetWeight;
  final String targetTimeline;
  final String workoutLevel;
  final double? estimatedWeightChange;
  final double? estimatedDailyDeficit;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FitnessGoalModel({
    required this.id,
    required this.userId,
    required this.goalType,
    required this.targetWeight,
    required this.targetTimeline,
    required this.workoutLevel,
    this.estimatedWeightChange,
    this.estimatedDailyDeficit,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory FitnessGoalModel.fromJson(Map<String, dynamic> json) {
    return FitnessGoalModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      goalType: json['goalType']?.toString() ?? '',
      targetWeight: (json['targetWeight'] as num?)?.toDouble() ?? 0.0,
      targetTimeline: json['targetTimeline']?.toString() ?? '',
      workoutLevel: json['workoutLevel']?.toString() ?? '',
      estimatedWeightChange: (json['estimatedWeightChange'] as num?)?.toDouble(),
      estimatedDailyDeficit: (json['estimatedDailyDeficit'] as num?)?.toDouble(),
      status: json['status']?.toString(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'goalType': goalType,
      'targetWeight': targetWeight,
      'targetTimeline': targetTimeline,
      'workoutLevel': workoutLevel,
      'estimatedWeightChange': estimatedWeightChange,
      'estimatedDailyDeficit': estimatedDailyDeficit,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String get formattedWorkoutLevel {
    switch (workoutLevel.toUpperCase()) {
      case 'NOVICE_LEVEL':
      case 'NOVICE':
        return 'Beginner';
      case 'INTERMEDIATE_LEVEL':
      case 'INTERMEDIATE':
        return 'Intermediate';
      case 'ADVANCED_LEVEL':
      case 'ADVANCED':
        return 'Advanced';
      case 'ELITE_LEVEL':
      case 'ELITE':
        return 'Elite';
      default:
        if (workoutLevel.isNotEmpty) {
          return workoutLevel
              .replaceAll('_LEVEL', '')
              .replaceAll('_', ' ')
              .split(' ')
              .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}' : '')
              .join(' ');
        }
        return 'Beginner';
    }
  }

  String get formattedTargetDate {
    if (targetTimeline.isEmpty) return '';
    try {
      final dt = DateTime.tryParse(targetTimeline);
      if (dt != null) {
        final day = dt.day.toString().padLeft(2, '0');
        final month = dt.month.toString().padLeft(2, '0');
        final year = dt.year.toString();
        return '$day / $month / $year';
      }
    } catch (_) {}
    return targetTimeline;
  }
}

class FitnessProfileModel {
  final int userId;
  final double height;
  final double weight;
  final double bmi;
  final FitnessGoalModel? fitnessGoal;
  final DateTime? updatedAt;

  FitnessProfileModel({
    required this.userId,
    required this.height,
    required this.weight,
    required this.bmi,
    this.fitnessGoal,
    this.updatedAt,
  });

  bool get hasGoal => fitnessGoal != null && (fitnessGoal!.targetWeight > 0 || fitnessGoal!.workoutLevel.isNotEmpty);

  factory FitnessProfileModel.fromJson(Map<String, dynamic> json) {
    return FitnessProfileModel(
      userId: json['userId'] ?? 0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      bmi: (json['bmi'] as num?)?.toDouble() ?? 0.0,
      fitnessGoal: json['fitnessGoal'] != null && json['fitnessGoal'] is Map<String, dynamic>
          ? FitnessGoalModel.fromJson(json['fitnessGoal'])
          : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'height': height,
      'weight': weight,
      'bmi': bmi,
      'fitnessGoal': fitnessGoal?.toJson(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
