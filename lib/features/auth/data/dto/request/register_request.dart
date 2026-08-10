class RegisterRequest {
  final String email;
  final String username;
  final String passwordHash;
  final String firstname;
  final String lastname;

  RegisterRequest({
    required this.email,
    required this.username,
    required this.passwordHash,
    required this.firstname,
    required this.lastname,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'passwordHash': passwordHash,
      'firstname': firstname,
      'lastname': lastname,
    };
  }
}
