class UserResponse {
  final String id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? cityProvince;
  final String? dateOfBirth;
  final String? jointDate;
  final String? languagePreference;
  final String? themePreference;
  final String? profilePic;
  final String? gender;
  final bool? isActive;

  UserResponse({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.cityProvince,
    this.dateOfBirth,
    this.jointDate,
    this.languagePreference,
    this.themePreference,
    this.profilePic,
    this.gender,
    this.isActive,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      phone: json['phone']?.toString(),
      cityProvince: json['cityProvince']?.toString(),
      dateOfBirth: json['dateOfBirth']?.toString(),
      jointDate: json['jointDate']?.toString(),
      languagePreference: json['languagePreference']?.toString(),
      themePreference: json['themePreference']?.toString(),
      profilePic: json['profilePic']?.toString(),
      gender: json['gender']?.toString(),
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'cityProvince': cityProvince,
      'dateOfBirth': dateOfBirth,
      'jointDate': jointDate,
      'languagePreference': languagePreference,
      'themePreference': themePreference,
      'profilePic': profilePic,
      'gender': gender,
      'isActive': isActive,
    };
  }
}
