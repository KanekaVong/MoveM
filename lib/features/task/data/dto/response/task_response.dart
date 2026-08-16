class TaskResponse {
  final String activityId;
  final String activityName;
  final String? description;
  final String? status;
  final String? startActivity;
  final String? deadline;
  final int totalChecklistItems;
  final int completedChecklistItems;
  final double checklistProgress;
  final String? priority;
  final bool recurring;
  final List<dynamic>? labels; // Keep as dynamic for now, can map to LabelResponse if needed

  TaskResponse({
    required this.activityId,
    required this.activityName,
    this.description,
    this.status,
    this.startActivity,
    this.deadline,
    this.totalChecklistItems = 0,
    this.completedChecklistItems = 0,
    this.checklistProgress = 0.0,
    this.priority,
    this.recurring = false,
    this.labels,
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) {
    return TaskResponse(
      activityId: json['activityId'] ?? '',
      activityName: json['activityName'] ?? '',
      description: json['description'],
      status: json['status'],
      startActivity: json['startActivity'],
      deadline: json['deadline'],
      totalChecklistItems: json['totalChecklistItems'] ?? 0,
      completedChecklistItems: json['completedChecklistItems'] ?? 0,
      checklistProgress: (json['checklistProgress'] ?? 0.0).toDouble(),
      priority: json['priority'],
      recurring: json['recurring'] ?? false,
      labels: json['labels'],
    );
  }
}
