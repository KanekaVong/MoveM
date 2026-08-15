class TaskResponse {
  final String activityId;
  final String activityName;
  final String? description;
  final String? status;
  final String? startActivity;
  final String? deadline;

  TaskResponse({
    required this.activityId,
    required this.activityName,
    this.description,
    this.status,
    this.startActivity,
    this.deadline,
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) {
    return TaskResponse(
      activityId: json['activityId'] ?? '',
      activityName: json['activityName'] ?? '',
      description: json['description'],
      status: json['status'],
      startActivity: json['startActivity'],
      deadline: json['deadline'],
    );
  }
}
