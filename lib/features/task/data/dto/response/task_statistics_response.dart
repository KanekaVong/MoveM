class TaskStatisticsResponse {
  final int activeTasks;
  final int completedTasks;
  final int pendingTasks;
  final int inProgressTasks;
  final int overdueTasks;
  final double completionRate;
  final int tasksDueToday;
  final int tasksDueThisWeek;

  TaskStatisticsResponse({
    this.activeTasks = 0,
    this.completedTasks = 0,
    this.pendingTasks = 0,
    this.inProgressTasks = 0,
    this.overdueTasks = 0,
    this.completionRate = 0.0,
    this.tasksDueToday = 0,
    this.tasksDueThisWeek = 0,
  });

  factory TaskStatisticsResponse.fromJson(Map<String, dynamic> json) {
    return TaskStatisticsResponse(
      activeTasks: json['activeTasks'] ?? 0,
      completedTasks: json['completedTasks'] ?? 0,
      pendingTasks: json['pendingTasks'] ?? 0,
      inProgressTasks: json['inProgressTasks'] ?? 0,
      overdueTasks: json['overdueTasks'] ?? 0,
      completionRate: (json['completionRate'] as num?)?.toDouble() ?? 0.0,
      tasksDueToday: json['tasksDueToday'] ?? 0,
      tasksDueThisWeek: json['tasksDueThisWeek'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activeTasks': activeTasks,
      'completedTasks': completedTasks,
      'pendingTasks': pendingTasks,
      'inProgressTasks': inProgressTasks,
      'overdueTasks': overdueTasks,
      'completionRate': completionRate,
      'tasksDueToday': tasksDueToday,
      'tasksDueThisWeek': tasksDueThisWeek,
    };
  }
}
