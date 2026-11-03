class ActivityFeedItemResponse {
  final int id;
  final String activityId;
  final int userId;
  final String username;
  final String? firstname;
  final String? lastname;
  final String? profilePic;
  final String eventType;
  final String message;
  final String? referenceId;
  final String createdAt;

  ActivityFeedItemResponse({
    required this.id,
    required this.activityId,
    required this.userId,
    required this.username,
    this.firstname,
    this.lastname,
    this.profilePic,
    required this.eventType,
    required this.message,
    this.referenceId,
    required this.createdAt,
  });

  String get displayName {
    final first = firstname?.trim() ?? '';
    if (first.isNotEmpty) return first;
    if (username.trim().isNotEmpty) return username.trim();
    return 'Someone';
  }

  factory ActivityFeedItemResponse.fromJson(Map<String, dynamic> json) {
    return ActivityFeedItemResponse(
      id: json['id'] ?? 0,
      activityId: json['activityId']?.toString() ?? '',
      userId: json['userId'] ?? 0,
      username: json['username']?.toString() ?? '',
      firstname: json['firstname']?.toString(),
      lastname: json['lastname']?.toString(),
      profilePic: json['profilePic']?.toString(),
      eventType: json['eventType']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      referenceId: json['referenceId']?.toString(),
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}
