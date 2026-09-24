class GroupInviteResponse {
  final int? inviteId;
  final int? groupId;
  final String? activityId;
  final String? activityName;
  final int? inviterId;
  final String? inviterUsername;
  final int? inviteeId;
  final String? inviteeUsername;
  final String? status;
  final String? invitedAt;
  final String? respondedAt;

  GroupInviteResponse({
    this.inviteId,
    this.groupId,
    this.activityId,
    this.activityName,
    this.inviterId,
    this.inviterUsername,
    this.inviteeId,
    this.inviteeUsername,
    this.status,
    this.invitedAt,
    this.respondedAt,
  });

  factory GroupInviteResponse.fromJson(Map<String, dynamic> json) {
    return GroupInviteResponse(
      inviteId: json['inviteId'] is int
          ? json['inviteId']
          : int.tryParse(json['inviteId']?.toString() ?? ''),
      groupId: json['groupId'] is int
          ? json['groupId']
          : int.tryParse(json['groupId']?.toString() ?? ''),
      activityId: json['activityId'],
      activityName: json['activityName'],
      inviterId: json['inviterId'] is int
          ? json['inviterId']
          : int.tryParse(json['inviterId']?.toString() ?? ''),
      inviterUsername: json['inviterUsername'],
      inviteeId: json['inviteeId'] is int
          ? json['inviteeId']
          : int.tryParse(json['inviteeId']?.toString() ?? ''),
      inviteeUsername: json['inviteeUsername'],
      status: json['status'],
      invitedAt: json['invitedAt'],
      respondedAt: json['respondedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inviteId': inviteId,
      'groupId': groupId,
      'activityId': activityId,
      'activityName': activityName,
      'inviterId': inviterId,
      'inviterUsername': inviterUsername,
      'inviteeId': inviteeId,
      'inviteeUsername': inviteeUsername,
      'status': status,
      'invitedAt': invitedAt,
      'respondedAt': respondedAt,
    };
  }
}
