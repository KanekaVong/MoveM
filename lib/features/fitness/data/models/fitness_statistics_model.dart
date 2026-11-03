class FitnessMetricProgressModel {
  final String metricType;
  final double current;
  final double target;
  final double remaining;
  final double progressPercent;
  final String unit;
  final String period;
  final bool completed;

  FitnessMetricProgressModel({
    required this.metricType,
    required this.current,
    required this.target,
    required this.remaining,
    required this.progressPercent,
    required this.unit,
    required this.period,
    required this.completed,
  });

  factory FitnessMetricProgressModel.fromJson(Map<String, dynamic> json) {
    return FitnessMetricProgressModel(
      metricType: json['metricType']?.toString() ?? '',
      current: (json['current'] as num?)?.toDouble() ?? 0.0,
      target: (json['target'] as num?)?.toDouble() ?? 0.0,
      remaining: (json['remaining'] as num?)?.toDouble() ?? 0.0,
      progressPercent: (json['progressPercent'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit']?.toString() ?? '',
      period: json['period']?.toString() ?? '',
      completed: json['completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metricType': metricType,
      'current': current,
      'target': target,
      'remaining': remaining,
      'progressPercent': progressPercent,
      'unit': unit,
      'period': period,
      'completed': completed,
    };
  }
}

class FitnessStatisticsModel {
  final int totalWorkouts;
  final int workoutsToday;
  final int workoutsThisWeek;
  final int totalSteps;
  final int stepsToday;
  final int stepsThisWeek;
  final double totalDistance;
  final double distanceToday;
  final double distanceThisWeek;
  final double caloriesToday;
  final double caloriesThisWeek;
  final double totalCalories;
  final List<FitnessMetricProgressModel> metricGoals;

  FitnessStatisticsModel({
    this.totalWorkouts = 0,
    this.workoutsToday = 0,
    this.workoutsThisWeek = 0,
    this.totalSteps = 0,
    this.stepsToday = 0,
    this.stepsThisWeek = 0,
    this.totalDistance = 0.0,
    this.distanceToday = 0.0,
    this.distanceThisWeek = 0.0,
    this.caloriesToday = 0.0,
    this.caloriesThisWeek = 0.0,
    this.totalCalories = 0.0,
    this.metricGoals = const [],
  });

  factory FitnessStatisticsModel.fromJson(Map<String, dynamic> json) {
    return FitnessStatisticsModel(
      totalWorkouts: (json['totalWorkouts'] as num?)?.toInt() ?? 0,
      workoutsToday: (json['workoutsToday'] as num?)?.toInt() ?? 0,
      workoutsThisWeek: (json['workoutsThisWeek'] as num?)?.toInt() ?? 0,
      totalSteps: (json['totalSteps'] as num?)?.toInt() ?? 0,
      stepsToday: (json['stepsToday'] as num?)?.toInt() ?? 0,
      stepsThisWeek: (json['stepsThisWeek'] as num?)?.toInt() ?? 0,
      totalDistance: (json['totalDistance'] as num?)?.toDouble() ?? 0.0,
      distanceToday: (json['distanceToday'] as num?)?.toDouble() ?? 0.0,
      distanceThisWeek: (json['distanceThisWeek'] as num?)?.toDouble() ?? 0.0,
      caloriesToday: (json['caloriesToday'] as num?)?.toDouble() ?? 0.0,
      caloriesThisWeek: (json['caloriesThisWeek'] as num?)?.toDouble() ?? 0.0,
      totalCalories: (json['totalCalories'] as num?)?.toDouble() ?? 0.0,
      metricGoals: json['metricGoals'] != null && json['metricGoals'] is List
          ? (json['metricGoals'] as List)
              .map((i) => FitnessMetricProgressModel.fromJson(i))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalWorkouts': totalWorkouts,
      'workoutsToday': workoutsToday,
      'workoutsThisWeek': workoutsThisWeek,
      'totalSteps': totalSteps,
      'stepsToday': stepsToday,
      'stepsThisWeek': stepsThisWeek,
      'totalDistance': totalDistance,
      'distanceToday': distanceToday,
      'distanceThisWeek': distanceThisWeek,
      'caloriesToday': caloriesToday,
      'caloriesThisWeek': caloriesThisWeek,
      'totalCalories': totalCalories,
      'metricGoals': metricGoals.map((g) => g.toJson()).toList(),
    };
  }
}
