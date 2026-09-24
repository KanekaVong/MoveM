class GroupMemberResponse {
  final int userId;
  final String username;
  final String? firstname;
  final String? lastname;
  final String? profilePic;
  final String? role;
  final String? joinedAt;

  GroupMemberResponse({
    required this.userId,
    required this.username,
    this.firstname,
    this.lastname,
    this.profilePic,
    this.role,
    this.joinedAt,
  });

  String get displayName {
    final first = firstname ?? '';
    final last = lastname ?? '';
    final full = '$first $last'.trim();
    return full.isNotEmpty ? full : username;
  }

  factory GroupMemberResponse.fromJson(Map<String, dynamic> json) {
    return GroupMemberResponse(
      userId: json['userId'] is int
          ? json['userId']
          : int.tryParse(json['userId']?.toString() ?? '0') ?? 0,
      username: json['username'] ?? '',
      firstname: json['firstname'],
      lastname: json['lastname'],
      profilePic: json['profilePic'],
      role: json['role'],
      joinedAt: json['joinedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'profilePic': profilePic,
      'role': role,
      'joinedAt': joinedAt,
    };
  }
}
