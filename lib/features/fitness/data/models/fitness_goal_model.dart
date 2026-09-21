class FitnessGoalModel {
  final String id;
  final String userId;
  final String goalType;
  final double? targetWeight;
  final int? targetTimeline;
  final String? workoutLevel;
  final double? estimatedWeightChange;
  final double? estimatedDailyDeficit;

  FitnessGoalModel({
    required this.id,
    required this.userId,
    required this.goalType,
    this.targetWeight,
    this.targetTimeline,
    this.workoutLevel,
    this.estimatedWeightChange,
    this.estimatedDailyDeficit,
  });

  factory FitnessGoalModel.fromJson(Map<String, dynamic> json) {
    return FitnessGoalModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      goalType: json['goalType']?.toString() ?? '',
      targetWeight: (json['targetWeight'] as num?)?.toDouble(),
      targetTimeline: (json['targetTimeline'] as num?)?.toInt(),
      workoutLevel: json['workoutLevel']?.toString(),
      estimatedWeightChange: (json['estimatedWeightChange'] as num?)?.toDouble(),
      estimatedDailyDeficit: (json['estimatedDailyDeficit'] as num?)?.toDouble(),
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
    };
  }
}

class CreateFitnessGoalRequest {
  final String goalType;
  final double? targetWeight;
  final int? targetTimeline;
  final String? workoutLevel;

  CreateFitnessGoalRequest({
    required this.goalType,
    this.targetWeight,
    this.targetTimeline,
    this.workoutLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'goalType': goalType,
      if (targetWeight != null) 'targetWeight': targetWeight,
      if (targetTimeline != null) 'targetTimeline': targetTimeline,
      if (workoutLevel != null) 'workoutLevel': workoutLevel,
    };
  }
}
