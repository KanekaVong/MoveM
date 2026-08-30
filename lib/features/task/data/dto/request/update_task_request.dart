class UpdateTaskRequest {
  final String activityName;
  final String? description;
  final String? startActivity;
  final String? deadline;
  final String priority;
  final String status;
  final bool? isRecurring;
  final String? recurringType;
  final int? recurringInterval;
  final String? recurringEndDate;
  final List<int>? labelIds;
  final List<int>? attachmentIds;

  UpdateTaskRequest({
    required this.activityName,
    this.description,
    this.startActivity,
    this.deadline,
    required this.priority,
    required this.status,
    this.isRecurring,
    this.recurringType,
    this.recurringInterval,
    this.recurringEndDate,
    this.labelIds,
    this.attachmentIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'activityName': activityName,
      if (description != null) 'description': description,
      if (startActivity != null || deadline != null) 'startActivity': startActivity ?? deadline,
      if (deadline != null) 'deadline': deadline,
      'priority': priority,
      'status': status,
      if (isRecurring != null) 'isRecurring': isRecurring,
      if (recurringType != null) 'recurringType': recurringType,
      if (recurringInterval != null) 'recurringInterval': recurringInterval,
      if (recurringEndDate != null) 'recurringEndDate': recurringEndDate,
      if (labelIds != null && labelIds!.isNotEmpty) 'labelIds': labelIds,
      if (attachmentIds != null && attachmentIds!.isNotEmpty) 'attachmentIds': attachmentIds,
    };
  }
}
