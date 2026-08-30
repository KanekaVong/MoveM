import 'checklist_response.dart';
import 'reminder_response.dart';
import 'label_response.dart';

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
  final String? recurringType;
  final List<LabelResponse>? labels;
  final List<ChecklistResponse>? checklists;
  final List<ReminderResponse>? reminders;
  final List<dynamic>? attachments;
  final List<dynamic>? collaborators;

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
    this.recurringType,
    this.labels,
    this.checklists,
    this.reminders,
    this.attachments,
    this.collaborators,
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
      recurring: json['recurring'] ?? json['isRecurring'] ?? false,
      recurringType: json['recurringType'],
      labels: json['labels'] != null
          ? (json['labels'] as List).map((e) => LabelResponse.fromJson(e)).toList()
          : null,
      checklists: json['checklists'] != null
          ? (json['checklists'] as List).map((e) => ChecklistResponse.fromJson(e)).toList()
          : null,
      reminders: json['reminders'] != null
          ? (json['reminders'] as List).map((e) => ReminderResponse.fromJson(e)).toList()
          : null,
      attachments: json['attachments'] is List ? json['attachments'] as List : null,
      collaborators: json['collaborators'] is List ? json['collaborators'] as List : (json['assignedUsers'] is List ? json['assignedUsers'] as List : null),
    );
  }
}
