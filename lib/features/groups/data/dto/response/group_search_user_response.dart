class GroupSearchUserResponse {
  final int userId;
  final String username;
  final String? firstname;
  final String? lastname;
  final String? email;

  GroupSearchUserResponse({
    required this.userId,
    required this.username,
    this.firstname,
    this.lastname,
    this.email,
  });

  String get displayName {
    final first = firstname ?? '';
    final last = lastname ?? '';
    final full = '$first $last'.trim();
    return full.isNotEmpty ? full : username;
  }

  factory GroupSearchUserResponse.fromJson(Map<String, dynamic> json) {
    return GroupSearchUserResponse(
      userId: json['userId'] is int
          ? json['userId']
          : int.tryParse(json['userId']?.toString() ?? '0') ?? 0,
      username: json['username'] ?? '',
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
    };
  }
}
