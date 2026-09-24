export 'task_endpoints.dart';
export 'fitness_endpoints.dart';

/// Aggregated API Endpoints Helper
class ApiEndpoints {
  // Task shortcuts
  static const String tasks = 'tasks';
  static const String taskLabels = 'task-labels';
  static const String taskStatistics = 'statistics/tasks';

  // Fitness shortcuts
  static const String fitnessProfile = 'fitness/profile';
  static const String fitnessStatistics = 'statistics/fitness';
  static const String fitnessGoals = 'fitness/goals';
  static const String fitnessAchievements = 'fitness/achievements';
  static const String fitnessSoloChallenges = 'fitness/solo-challenges';
  static const String fitnessClubs = 'fitness/clubs';
  static const String fitnessWorkouts = 'fitness/workouts';
}
