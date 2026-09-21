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
    this.progress = 0.0,
    this.category = 'Step Count',
    this.imagePath = AppImages.pushUpCard,
    this.heroImagePath = AppImages.pushUpHero,
    this.moreActivities = const [],
    this.createdAt,
    this.updatedAt,
  });

  String get effectiveHeroImagePath {
    if (heroImagePath.isNotEmpty && heroImagePath != AppImages.pushUpHero && heroImagePath != AppImages.workoutDetailsHero) {
      return heroImagePath;
    }
    final t = type.toUpperCase();
    final n = name.toLowerCase();
    final u = targetUnit.toUpperCase();
    if (t == 'RUNNING' || t == 'WALKING' || n.contains('run') || n.contains('sprint') || u == 'KM' || u == 'STEPS') {
      return AppImages.runningActivity;
    } else if (t == 'CYCLING' || n.contains('cycl') || n.contains('bike')) {
      return AppImages.pic2;
    } else if (t == 'SWIMMING' || n.contains('swim')) {
      return AppImages.pic3;
    } else if (t == 'HIKING' || n.contains('hike')) {
      return AppImages.pic1;
    } else if (t == 'BADMINTON' || n.contains('badminton')) {
      return AppImages.pic7;
    } else if (t == 'TENNIS' || n.contains('tennis')) {
      return AppImages.pic8;
    } else if (t == 'YOGA' || n.contains('yoga')) {
      return AppImages.pic9;
    } else if (t == 'STRETCHING' || n.contains('stretch')) {
      return AppImages.pic10;
    } else if (t == 'HIIT' || n.contains('hiit')) {
      return AppImages.pic12;
    } else if (t == 'CARDIO' || n.contains('cardio')) {
      return AppImages.pic14;
    } else if (t == 'STRENGTH_TRAINING' || n.contains('strength')) {
      return AppImages.pic15;
    } else if (t == 'SPORTS' || n.contains('sport')) {
      return AppImages.pic16;
    } else if (t == 'SQUATS' || ((t == 'BODYWEIGHT' || t == 'STRENGTH_TRAINING') && n.contains('squat')) || n.contains('squat')) {
      return AppImages.squatsActivity;
    } else if (t == 'PULL_UPS' || t == 'PULL_UP' || n.contains('pull')) {
      return AppImages.pullUpsActivity;
    } else if (t == 'PUSH_UP' || n.contains('push')) {
      return AppImages.pushUpHero;
    }
    return heroImagePath.isNotEmpty ? heroImagePath : AppImages.workoutDetailsHero;
  }

  String get effectiveImagePath {
    if (imagePath.isNotEmpty && imagePath != AppImages.pushUpCard && imagePath != AppImages.workoutDetailsHero) {
      return imagePath;
    }
    final t = type.toUpperCase();
    final n = name.toLowerCase();
    final u = targetUnit.toUpperCase();
    if (t == 'RUNNING' || t == 'WALKING' || n.contains('run') || n.contains('sprint') || u == 'KM' || u == 'STEPS') {
      return AppImages.runningActivity;
    } else if (t == 'CYCLING' || n.contains('cycl') || n.contains('bike')) {
      return AppImages.pic2;
    } else if (t == 'SWIMMING' || n.contains('swim')) {
      return AppImages.pic3;
    } else if (t == 'HIKING' || n.contains('hike')) {
      return AppImages.pic1;
    } else if (t == 'BADMINTON' || n.contains('badminton')) {
      return AppImages.pic7;
    } else if (t == 'TENNIS' || n.contains('tennis')) {
      return AppImages.pic8;
    } else if (t == 'YOGA' || n.contains('yoga')) {
      return AppImages.pic9;
    } else if (t == 'STRETCHING' || n.contains('stretch')) {
      return AppImages.pic10;
    } else if (t == 'HIIT' || n.contains('hiit')) {
      return AppImages.pic12;
    } else if (t == 'CARDIO' || n.contains('cardio')) {
      return AppImages.pic14;
    } else if (t == 'STRENGTH_TRAINING' || n.contains('strength')) {
      return AppImages.pic15;
    } else if (t == 'SPORTS' || n.contains('sport')) {
      return AppImages.pic16;
    } else if (t == 'SQUATS' || ((t == 'BODYWEIGHT' || t == 'STRENGTH_TRAINING') && n.contains('squat')) || n.contains('squat')) {
      return AppImages.squatsActivity;
    } else if (t == 'PULL_UPS' || t == 'PULL_UP' || n.contains('pull')) {
      return AppImages.pullUpsActivity;
    } else if (t == 'PUSH_UP' || n.contains('push')) {
      return AppImages.pushUpCard;
    }
    return imagePath.isNotEmpty ? imagePath : AppImages.workoutDetailsHero;
  }

  bool get isRunning {
    final t = type.toUpperCase();
    final n = name.toLowerCase();
    final u = targetUnit.toUpperCase();
    return t == 'RUNNING' || t == 'WALKING' || t == 'CYCLING' || t == 'HIKING' || n.contains('run') || n.contains('sprint') || n.contains('km') || u == 'KM' || u == 'STEPS';
  }

  bool get isPushUp {
    final t = type.toUpperCase();
    final n = name.toLowerCase();
    return t == 'PUSH_UP' || n.contains('push');
  }

  bool get isSquats {
    final t = type.toUpperCase();
    final n = name.toLowerCase();
    return t == 'SQUATS' || ((t == 'BODYWEIGHT' || t == 'STRENGTH_TRAINING') && n.contains('squat')) || n.contains('squat');
  }

  factory SoloChallengeModel.fromJson(Map<String, dynamic> json) {
    final rawType = json['type']?.toString() ?? '';
    final rawName = json['name']?.toString() ?? '';
    final rawTargetUnit = json['targetUnit']?.toString() ?? '';
    final rawTargetValue = (json['targetValue'] as num?)?.toInt() ?? 0;

    final t = rawType.toUpperCase();
    final n = rawName.toLowerCase();
    final u = rawTargetUnit.toUpperCase();

    final isRunning = t == 'RUNNING' || t == 'WALKING' || t == 'CYCLING' || t == 'HIKING' || n.contains('run') || n.contains('sprint') || (t != 'BODYWEIGHT' && (u == 'KM' || u == 'STEPS'));
    final isSquats = t == 'SQUATS' || ((t == 'BODYWEIGHT' || t == 'STRENGTH_TRAINING') && n.contains('squat')) || n.contains('squat');
    final isPullUps = t == 'PULL_UPS' || t == 'PULL_UP' || n.contains('pull');
    final isPushUp = t == 'PUSH_UP' || n.contains('push');

    final int defaultSets = isRunning ? 1 : (isSquats ? 3 : (isPullUps ? 4 : 4));
    final int defaultReps = isRunning
        ? (rawTargetValue > 0 ? rawTargetValue : 1)
        : (isSquats ? 15 : (isPullUps ? 5 : 15));

    final String defaultHero = isRunning
        ? AppImages.runningActivity
        : (isSquats
            ? AppImages.squatsActivity
            : (isPullUps
                ? AppImages.pullUpsActivity
                : (isPushUp ? AppImages.pushUpHero : AppImages.workoutDetailsHero)));

    final String defaultCard = isRunning
        ? AppImages.runningActivity
        : (isSquats
            ? AppImages.squatsActivity
            : (isPullUps
                ? AppImages.pullUpsActivity
                : (isPushUp ? AppImages.pushUpCard : AppImages.workoutDetailsHero)));

    return SoloChallengeModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: rawName,
      type: rawType,
      workoutLevel: json['workoutLevel']?.toString() ?? '',
      targetValue: rawTargetValue,
      targetUnit: rawTargetUnit,
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      description: json['description']?.toString() ?? '',
      sets: (json['sets'] as num?)?.toInt() ?? defaultSets,
      repsPerSet: (json['repsPerSet'] as num?)?.toInt() ?? defaultReps,
      progress: () {
        final raw = json['progress'] ?? json['completionRate'] ?? json['completionPercentage'] ?? json['currentProgress'];
        if (raw is num) {
          final val = raw.toDouble();
          return val > 1.0 ? val / 100.0 : val;
        }
        return 0.0;
      }(),
      category: json['category']?.toString() ?? (isRunning && rawTargetValue > 0 ? '$rawTargetValue $rawTargetUnit' : (rawType.isNotEmpty ? rawType : 'Workout')),
      imagePath: (json['imagePath'] != null && json['imagePath'].toString().isNotEmpty)
          ? json['imagePath'].toString()
          : defaultCard,
      heroImagePath: (json['heroImagePath'] != null && json['heroImagePath'].toString().isNotEmpty)
          ? json['heroImagePath'].toString()
          : defaultHero,
      moreActivities: const [],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null,
    );
  }

  static SoloChallengeModel get sprintChallenge => SoloChallengeModel(
        id: 2,
        name: '4K Sprint Challenge',
        type: 'Running',
        workoutLevel: 'INTERMEDIATE',
        targetValue: 4000,
        targetUnit: 'Steps',
        calories: 320,
        sets: 1,
        repsPerSet: 4000,
        progress: 1.0,
        category: '4000 Steps',
        description: 'Run 4 kilometers or 4000 steps to complete this challenge.',
        imagePath: AppImages.runningActivity,
        heroImagePath: AppImages.runningActivity,
        moreActivities: const [],
      );

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
            "An exercise done to improve upper body strength, performed by resting on one's toes and hands and pushing one's weight off the floor",
        imagePath: AppImages.pushUpCard,
        heroImagePath: AppImages.pushUpHero,
        moreActivities: const [],
      );

  static List<SoloChallengeModel> get defaultChallenges => [
        sprintChallenge,
        pushUpChallenge,
      ];
}
