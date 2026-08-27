class SetupGoalRequest {
  final String goalType;
  final double targetWeight;
  final String targetTimeline;
  final String workoutLevel;

  SetupGoalRequest({
    required this.goalType,
    required this.targetWeight,
    required this.targetTimeline,
    required this.workoutLevel,
  });

  Map<String, dynamic> toJson() => {
    'goalType': goalType,
    'targetWeight': targetWeight,
    'targetTimeline': targetTimeline,
    'workoutLevel': workoutLevel,
  };
}
