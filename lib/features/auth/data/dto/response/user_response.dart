class UserResponse {
  final String id;
  final String email;
  final String name;
  final String? accessToken;
  final String? trustToken;

  UserResponse({
    required this.id,
    required this.email,
    required this.name,
    this.accessToken,
    this.trustToken,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      accessToken: json['accessToken']?.toString(),
      trustToken: json['trustToken']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }
}
