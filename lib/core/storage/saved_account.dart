import '../../features/auth/data/dto/response/user_response.dart';

class SavedAccount {
  final String accessToken;
  final String trustToken;
  final UserResponse user;

  SavedAccount({
    required this.accessToken,
    required this.trustToken,
    required this.user,
  });

  factory SavedAccount.fromJson(Map<String, dynamic> json) {
    return SavedAccount(
      accessToken: json['accessToken']?.toString() ?? '',
      trustToken: json['trustToken']?.toString() ?? '',
      user: UserResponse.fromJson(
        Map<String, dynamic>.from(json['user'] as Map),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'trustToken': trustToken,
      'user': user.toJson(),
    };
  }
}