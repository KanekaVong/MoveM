class TripMemberResponse {
  final int userId;
  final String username;
  final String firstname;
  final String lastname;
  final String profilePic;
  final String role;
  final DateTime? joinedAt;

  TripMemberResponse({
    required this.userId,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.profilePic,
    required this.role,
    this.joinedAt,
  });

  factory TripMemberResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return TripMemberResponse(
      userId: json['userId'] is int
          ? json['userId']
          : int.tryParse(
        json['userId']?.toString() ?? '',
      ) ?? 0,
      username: json['username']?.toString() ?? '',
      firstname: json['firstname']?.toString() ?? '',
      lastname: json['lastname']?.toString() ?? '',
      profilePic: json['profilePic']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      joinedAt: json['joinedAt'] != null
          ? DateTime.tryParse(
        json['joinedAt'].toString(),
      )
          : null,
    );
  }
}