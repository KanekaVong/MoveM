class LoginResponse {
  final String? accessToken;
  final String? trustToken;
  final String? message;

  LoginResponse({this.accessToken, this.trustToken, this.message});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'],
      trustToken: json['trustToken'],
      message: json['message'],
    );
  }

  bool get isFullyLoggedIn => accessToken != null && accessToken!.isNotEmpty;
}