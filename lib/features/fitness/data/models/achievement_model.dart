class AchievementModel {
  final int achievementId;
  final String name;
  final String description;
  final String icon;
  final String category;
  final String conditionType;
  final double conditionValue;
  final double currentProgress;
  final double progressPercentage;
  final bool earned;

  AchievementModel({
    required this.achievementId,
    required this.name,
    required this.description,
    required this.icon,
    this.category = 'GENERAL',
    required this.conditionType,
    required this.conditionValue,
    this.currentProgress = 0.0,
    this.progressPercentage = 0.0,
    this.earned = false,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      achievementId: (json['achievementId'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      icon: json['icon']?.toString() ?? 'emoji_events',
      category: json['category']?.toString() ?? 'GENERAL',
      conditionType: json['conditionType']?.toString() ?? '',
      conditionValue: (json['conditionValue'] as num?)?.toDouble() ?? 0.0,
      currentProgress: (json['currentProgress'] as num?)?.toDouble() ?? 0.0,
      progressPercentage: (json['progressPercentage'] as num?)?.toDouble() ?? 0.0,
      earned: json['earned'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'achievementId': achievementId,
      'name': name,
      'description': description,
      'icon': icon,
      'category': category,
      'conditionType': conditionType,
      'conditionValue': conditionValue,
      'currentProgress': currentProgress,
      'progressPercentage': progressPercentage,
      'earned': earned,
    };
  }
}

class UserAchievementModel {
  final int achievementId;
  final String name;
  final String description;
  final String icon;
  final String conditionType;
  final double conditionValue;
  final DateTime? earnedAt;

  UserAchievementModel({
    required this.achievementId,
    required this.name,
    required this.description,
    required this.icon,
    required this.conditionType,
    required this.conditionValue,
    this.earnedAt,
  });

  factory UserAchievementModel.fromJson(Map<String, dynamic> json) {
    return UserAchievementModel(
      achievementId: (json['achievementId'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      icon: json['icon']?.toString() ?? 'emoji_events',
      conditionType: json['conditionType']?.toString() ?? '',
      conditionValue: (json['conditionValue'] as num?)?.toDouble() ?? 0.0,
      earnedAt: json['earnedAt'] != null ? DateTime.tryParse(json['earnedAt'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'achievementId': achievementId,
      'name': name,
      'description': description,
      'icon': icon,
      'conditionType': conditionType,
      'conditionValue': conditionValue,
      'earnedAt': earnedAt?.toIso8601String(),
    };
  }
}
