import '../../../../core/utils/app_images.dart';

class MoreActivityModel {
  final String title;
  final String? subtitle;
  final String imagePath;
  final String type;

  const MoreActivityModel({
    required this.title,
    this.subtitle,
    required this.imagePath,
    required this.type,
  });
}

class SoloChallengeModel {
  final int id;
  final String name;
  final String type;
  final String workoutLevel;
  final int targetValue;
  final String targetUnit;
  final int calories;
  final String description;
  final int sets;
  final int repsPerSet;
  final double progress;
  final String category;
  final String imagePath;
  final String heroImagePath;
  final List<MoreActivityModel> moreActivities;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SoloChallengeModel({
    required this.id,
    required this.name,
    required this.type,
    required this.workoutLevel,
    required this.targetValue,
    required this.targetUnit,
    required this.calories,
    required this.description,
    this.sets = 4,
    this.repsPerSet = 15,
    this.progress = 0.35,
    this.category = 'Step Count',
    this.imagePath = AppImages.pushUpCard,
    this.heroImagePath = AppImages.pushUpHero,
    this.moreActivities = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory SoloChallengeModel.fromJson(Map<String, dynamic> json) {
    return SoloChallengeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      workoutLevel: json['workoutLevel'] ?? '',
      targetValue: json['targetValue'] ?? 0,
      targetUnit: json['targetUnit'] ?? '',
      calories: json['calories'] ?? 0,
      description: json['description'] ?? '',
      sets: json['sets'] ?? 4,
      repsPerSet: json['repsPerSet'] ?? 15,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.35,
      category: json['category'] ?? 'Step Count',
      imagePath: json['imagePath'] ?? AppImages.pushUpCard,
      heroImagePath: json['heroImagePath'] ?? AppImages.pushUpHero,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  static SoloChallengeModel get pushUpChallenge => SoloChallengeModel(
        id: 1,
        name: '4 Sets of 15 Push Up',
        type: 'Push Up',
        workoutLevel: 'INTERMEDIATE',
        targetValue: 60,
        targetUnit: 'Reps',
        calories: 180,
        sets: 4,
        repsPerSet: 15,
        progress: 0.35,
        category: 'Step Count',
        description:
            "An exercise done to improve upper body strength, performed by resting on one's toes and hands and pushing one's weight off the floo",
        imagePath: AppImages.pushUpCard,
        heroImagePath: AppImages.pushUpHero,
        moreActivities: const [
          MoreActivityModel(
            title: 'Running',
            subtitle: null,
            imagePath: AppImages.runningActivity,
            type: 'Running',
          ),
          MoreActivityModel(
            title: 'Squats',
            subtitle: '10 minutes a day',
            imagePath: AppImages.squatsActivity,
            type: 'Squats',
          ),
        ],
      );

  static List<SoloChallengeModel> get defaultChallenges => [
        pushUpChallenge,
      ];
}
