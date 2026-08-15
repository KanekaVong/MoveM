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
    this.labelIds,
    required this.checklists,
    this.reminders,
  });

  Map<String, dynamic> toJson() {
    return {
      'activityName': activityName,
      'description': description,
      'startActivity': startActivity ?? deadline, // Fallback to deadline if null
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
      'labelIds': labelIds ?? [],
      'checklists': checklists,
      if (reminders != null) 'reminders': reminders,
    };
  }
}
