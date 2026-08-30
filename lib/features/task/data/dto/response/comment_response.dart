class CommentResponse {
  final int id;
  final int userId;
  final String username;
  final String? firstname;
  final String? lastname;
  final String? profilePic;
  final String content;
  final String createdAt;
  final String? updatedAt;
  final bool edited;

  CommentResponse({
    required this.id,
    required this.userId,
    required this.username,
    this.firstname,
    this.lastname,
    this.profilePic,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.edited = false,
  });

  String get displayName {
    if (firstname != null && firstname!.isNotEmpty) {
      if (lastname != null && lastname!.isNotEmpty) {
        return '$firstname $lastname';
      }
      return firstname!;
    }
    return username;
  }

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    return CommentResponse(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      username: json['username'] ?? '',
      firstname: json['firstname'],
      lastname: json['lastname'],
      profilePic: json['profilePic'],
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'],
      edited: json['edited'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'profilePic': profilePic,
      'content': content,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'edited': edited,
    };
  }
}
