class UserResponse {
  final String id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? bio;
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
    this.bio,
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
      firstName: json['firstname']?.toString() ?? json['firstName']?.toString(),
      lastName: json['lastname']?.toString() ?? json['lastName']?.toString(),
      bio: json['bio']?.toString(),
      phone: json['phone']?.toString(),
      cityProvince: json['cityProvince']?.toString() ?? json['city_province']?.toString(),
      dateOfBirth: json['dateOfBirth']?.toString() ?? json['date_of_birth']?.toString(),
      jointDate: json['jointDate']?.toString() ?? json['joint_date']?.toString(),
      languagePreference: json['languagePreference']?.toString() ?? json['language_preference']?.toString(),
      themePreference: json['themePreference']?.toString() ?? json['theme_preference']?.toString(),
      profilePic: json['profilePic']?.toString() ?? json['profile_pic']?.toString(),
      gender: json['gender']?.toString(),
      isActive: json['isActive'] ?? json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstname': firstName,
      'lastname': lastName,
      'bio': bio,
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
