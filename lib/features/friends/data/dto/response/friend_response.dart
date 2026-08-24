class FriendResponse {
  final int userId;
  final String username;
  final String firstname;
  final String lastname;
  final String profilePic;
  final String? friendStatus;

  FriendResponse({
    required this.userId,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.profilePic,
    this.friendStatus,
  });

  factory FriendResponse.fromJson(Map<String, dynamic> json) {
    return FriendResponse(
      userId: json['userId'] ?? 0,
      username: json['username'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      profilePic: json['profilePic'] ?? '',
      friendStatus: json['friendStatus'],
    );
  }
}
