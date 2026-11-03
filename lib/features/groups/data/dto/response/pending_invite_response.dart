class PendingInviteResponse {
  final int inviteId;
  final int? groupId;
  final String activityId;
  final String? activityName;
  final int inviteeId;
  final String inviteeUsername;
  final String? inviteeEmail;
  final String status;
  final String? invitedAt;

  PendingInviteResponse({
    required this.inviteId,
    this.groupId,
    required this.activityId,
    this.activityName,
    required this.inviteeId,
    required this.inviteeUsername,
    this.inviteeEmail,
    required this.status,
    this.invitedAt,
  });

  factory PendingInviteResponse.fromJson(Map<String, dynamic> json) {
    return PendingInviteResponse(
      inviteId: json['inviteId'] is int
          ? json['inviteId']
          : int.tryParse(json['inviteId']?.toString() ?? '0') ?? 0,
      groupId: json['groupId'] is int
          ? json['groupId']
          : int.tryParse(json['groupId']?.toString() ?? ''),
      activityId: json['activityId']?.toString() ?? '',
      activityName: json['activityName']?.toString(),
      inviteeId: json['inviteeId'] is int
          ? json['inviteeId']
          : int.tryParse(json['inviteeId']?.toString() ?? '0') ?? 0,
      inviteeUsername: json['inviteeUsername']?.toString() ?? '',
      inviteeEmail: json['inviteeEmail']?.toString(),
      status: json['status']?.toString() ?? 'PENDING',
      invitedAt: json['invitedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inviteId': inviteId,
      'groupId': groupId,
      'activityId': activityId,
      'activityName': activityName,
      'inviteeId': inviteeId,
      'inviteeUsername': inviteeUsername,
      'inviteeEmail': inviteeEmail,
      'status': status,
      'invitedAt': invitedAt,
    };
  }
}
