class CreateTaskRequest {
  final String activityName;
  final String description;
  final String? startActivity;
  final String? deadline;
  final String? locationName;
  final String? locationAddress;
  final double? lat;
  final double? lng;
  final String? googlePlaceId;
  final String? coordinates;
  final String? parentActivityId;
  final String? priority;
  final bool? isRecurring;
  final String? recurringType;
  final int? recurringInterval;
  final String? recurringEndDate;
  final List<int>? labelIds;
  final List<Map<String, String>> checklists;
  final List<Map<String, dynamic>>? reminders;

  CreateTaskRequest({
    required this.activityName,
    required this.description,
    this.startActivity,
    this.deadline,
    this.locationName,
    this.locationAddress,
    this.lat,
    this.lng,
    this.googlePlaceId,
    this.coordinates,
    this.parentActivityId,
    this.priority,
    this.isRecurring,
    this.recurringType,
    this.recurringInterval,
    this.recurringEndDate,
    this.labelIds,
    required this.checklists,
    this.reminders,
  });

  Map<String, dynamic> toJson() {
    return {
      'activityName': activityName,
      'description': description,
      if (startActivity != null || deadline != null) 'startActivity': startActivity ?? deadline,
      if (deadline != null) 'deadline': deadline,
      if (locationName != null) 'locationName': locationName,
      if (locationAddress != null) 'locationAddress': locationAddress,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (googlePlaceId != null) 'googlePlaceId': googlePlaceId,
      if (coordinates != null) 'coordinates': coordinates,
      if (parentActivityId != null) 'parentActivityId': parentActivityId,
      if (priority != null) 'priority': priority,
      'isRecurring': isRecurring ?? false,
      if (recurringType != null) 'recurringType': recurringType,
      if (recurringInterval != null) 'recurringInterval': recurringInterval,
      if (recurringEndDate != null) 'recurringEndDate': recurringEndDate,
      if (labelIds != null && labelIds!.isNotEmpty) 'labelIds': labelIds,
      if (checklists.isNotEmpty) 'checklists': checklists,
      if (reminders != null && reminders!.isNotEmpty) 'reminders': reminders,
    };
  }
}
