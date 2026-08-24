class DashboardResponse {
  final TaskStatistics? statistics;
  final FitnessStatistics? fitnessStatistics;
  final List<DashboardTaskItem>? dueToday;
  final List<DashboardTaskItem>? overdueTasks;
  final List<DashboardTaskItem>? upcomingTasks;
  final List<RecentActivityItem>? recentActivities;
  final List<DashboardReminderItem>? upcomingReminders;

  DashboardResponse({
    this.statistics,
    this.fitnessStatistics,
    this.dueToday,
    this.overdueTasks,
    this.upcomingTasks,
    this.recentActivities,
    this.upcomingReminders,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      statistics: json['statistics'] != null ? TaskStatistics.fromJson(json['statistics']) : null,
      fitnessStatistics: json['fitnessStatistics'] != null ? FitnessStatistics.fromJson(json['fitnessStatistics']) : null,
      dueToday: json['dueToday'] != null ? (json['dueToday'] as List).map((e) => DashboardTaskItem.fromJson(e)).toList() : null,
      overdueTasks: json['overdueTasks'] != null ? (json['overdueTasks'] as List).map((e) => DashboardTaskItem.fromJson(e)).toList() : null,
      upcomingTasks: json['upcomingTasks'] != null ? (json['upcomingTasks'] as List).map((e) => DashboardTaskItem.fromJson(e)).toList() : null,
      recentActivities: json['recentActivities'] != null ? (json['recentActivities'] as List).map((e) => RecentActivityItem.fromJson(e)).toList() : null,
      upcomingReminders: json['upcomingReminders'] != null ? (json['upcomingReminders'] as List).map((e) => DashboardReminderItem.fromJson(e)).toList() : null,
    );
  }
}

class TaskStatistics {
  final int activeTasks;
  final int completedTasks;
  final int pendingTasks;
  final int inProgressTasks;
  final int overdueTasks;
  final double completionRate;
  final int tasksDueToday;
  final int tasksDueThisWeek;
  final int completedThisWeek;
  final int highPriorityTasks;
  final int mediumPriorityTasks;
  final int lowPriorityTasks;
  final int personalTasks;
  final int collaborativeTasks;

  TaskStatistics({
    this.activeTasks = 0,
    this.completedTasks = 0,
    this.pendingTasks = 0,
    this.inProgressTasks = 0,
    this.overdueTasks = 0,
    this.completionRate = 0.0,
    this.tasksDueToday = 0,
    this.tasksDueThisWeek = 0,
    this.completedThisWeek = 0,
    this.highPriorityTasks = 0,
    this.mediumPriorityTasks = 0,
    this.lowPriorityTasks = 0,
    this.personalTasks = 0,
    this.collaborativeTasks = 0,
  });

  factory TaskStatistics.fromJson(Map<String, dynamic> json) {
    return TaskStatistics(
      activeTasks: json['activeTasks'] ?? 0,
      completedTasks: json['completedTasks'] ?? 0,
      pendingTasks: json['pendingTasks'] ?? 0,
      inProgressTasks: json['inProgressTasks'] ?? 0,
      overdueTasks: json['overdueTasks'] ?? 0,
      completionRate: (json['completionRate'] ?? 0.0).toDouble(),
      tasksDueToday: json['tasksDueToday'] ?? 0,
      tasksDueThisWeek: json['tasksDueThisWeek'] ?? 0,
      completedThisWeek: json['completedThisWeek'] ?? 0,
      highPriorityTasks: json['highPriorityTasks'] ?? 0,
      mediumPriorityTasks: json['mediumPriorityTasks'] ?? 0,
      lowPriorityTasks: json['lowPriorityTasks'] ?? 0,
      personalTasks: json['personalTasks'] ?? 0,
      collaborativeTasks: json['collaborativeTasks'] ?? 0,
    );
  }
}

class FitnessStatistics {
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
  final List<MetricGoal>? metricGoals;

  FitnessStatistics({
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
    this.metricGoals,
  });

  factory FitnessStatistics.fromJson(Map<String, dynamic> json) {
    return FitnessStatistics(
      totalWorkouts: json['totalWorkouts'] ?? 0,
      workoutsToday: json['workoutsToday'] ?? 0,
      workoutsThisWeek: json['workoutsThisWeek'] ?? 0,
      totalSteps: json['totalSteps'] ?? 0,
      stepsToday: json['stepsToday'] ?? 0,
      stepsThisWeek: json['stepsThisWeek'] ?? 0,
      totalDistance: (json['totalDistance'] ?? 0.0).toDouble(),
      distanceToday: (json['distanceToday'] ?? 0.0).toDouble(),
      distanceThisWeek: (json['distanceThisWeek'] ?? 0.0).toDouble(),
      caloriesToday: (json['caloriesToday'] ?? 0.0).toDouble(),
      caloriesThisWeek: (json['caloriesThisWeek'] ?? 0.0).toDouble(),
      totalCalories: (json['totalCalories'] ?? 0.0).toDouble(),
      metricGoals: json['metricGoals'] != null ? (json['metricGoals'] as List).map((e) => MetricGoal.fromJson(e)).toList() : null,
    );
  }
}

class MetricGoal {
  final String? metricType;
  final double current;
  final double target;
  final double remaining;
  final double progressPercent;
  final String? unit;
  final String? period;
  final bool completed;

  MetricGoal({
    this.metricType,
    this.current = 0.0,
    this.target = 0.0,
    this.remaining = 0.0,
    this.progressPercent = 0.0,
    this.unit,
    this.period,
    this.completed = false,
  });

  factory MetricGoal.fromJson(Map<String, dynamic> json) {
    return MetricGoal(
      metricType: json['metricType'],
      current: (json['current'] ?? 0.0).toDouble(),
      target: (json['target'] ?? 0.0).toDouble(),
      remaining: (json['remaining'] ?? 0.0).toDouble(),
      progressPercent: (json['progressPercent'] ?? 0.0).toDouble(),
      unit: json['unit'],
      period: json['period'],
      completed: json['completed'] ?? false,
    );
  }
}

class DashboardTaskItem {
  final String activityId;
  final String activityName;
  final String priority;
  final String status;
  final String? deadline;
  final bool isCollaborative;

  DashboardTaskItem({
    required this.activityId,
    required this.activityName,
    required this.priority,
    required this.status,
    this.deadline,
    this.isCollaborative = false,
  });

  factory DashboardTaskItem.fromJson(Map<String, dynamic> json) {
    return DashboardTaskItem(
      activityId: json['activityId'] ?? '',
      activityName: json['activityName'] ?? '',
      priority: json['priority'] ?? 'LOW',
      status: json['status'] ?? 'PENDING',
      deadline: json['deadline'],
      isCollaborative: json['isCollaborative'] ?? false,
    );
  }
}

class RecentActivityItem {
  final int id;
  final String activityId;
  final int userId;
  final String? username;
  final String? firstname;
  final String? lastname;
  final String? profilePic;
  final String? eventType;
  final String? message;
  final int referenceId;
  final String? createdAt;

  RecentActivityItem({
    required this.id,
    required this.activityId,
    required this.userId,
    this.username,
    this.firstname,
    this.lastname,
    this.profilePic,
    this.eventType,
    this.message,
    this.referenceId = 0,
    this.createdAt,
  });

  factory RecentActivityItem.fromJson(Map<String, dynamic> json) {
    return RecentActivityItem(
      id: json['id'] ?? 0,
      activityId: json['activityId'] ?? '',
      userId: json['userId'] ?? 0,
      username: json['username'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      profilePic: json['profilePic'],
      eventType: json['eventType'],
      message: json['message'],
      referenceId: json['referenceId'] ?? 0,
      createdAt: json['createdAt'],
    );
  }
}

class DashboardReminderItem {
  final int id;
  final String? remindAt;
  final String? type;
  final bool sent;

  DashboardReminderItem({
    required this.id,
    this.remindAt,
    this.type,
    this.sent = false,
  });

  factory DashboardReminderItem.fromJson(Map<String, dynamic> json) {
    return DashboardReminderItem(
      id: json['id'] ?? 0,
      remindAt: json['remindAt'],
      type: json['type'],
      sent: json['sent'] ?? false,
    );
  }
}
