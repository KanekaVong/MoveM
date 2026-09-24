class HomeFeedItem {
  final String id;
  final int? sessionId;
  final String userName;
  final String? userAvatar;
  final String title;
  final String? caption;
  final String? duration;
  final String? calories;
  final String? steps;
  final double? distanceKm;
  final String workoutType;
  final String? imageUrl;
  final bool hasGpsRoute;
  final DateTime? createdAt;
  final int kudosCount;
  final bool myKudos;
  final int commentCount;
  final bool myPost;
  final int durationSeconds;
  final int stepsCount;
  final int caloriesCount;
  final String? averagePace;
  final String? challengeName;

  const HomeFeedItem({
    required this.id,
    this.sessionId,
    required this.userName,
    this.userAvatar,
    required this.title,
    this.caption,
    this.duration,
    this.calories,
    this.steps,
    this.distanceKm,
    this.workoutType = 'WORKOUT',
    this.imageUrl,
    this.hasGpsRoute = false,
    this.createdAt,
    this.kudosCount = 0,
    this.myKudos = false,
    this.commentCount = 0,
    this.myPost = false,
    this.durationSeconds = 0,
    this.stepsCount = 0,
    this.caloriesCount = 0,
    this.averagePace,
    this.challengeName,
  });

  HomeFeedItem copyWith({
    String? id,
    int? sessionId,
    String? userName,
    String? userAvatar,
    String? title,
    String? caption,
    String? duration,
    String? calories,
    String? steps,
    double? distanceKm,
    String? workoutType,
    String? imageUrl,
    bool? hasGpsRoute,
    DateTime? createdAt,
    int? kudosCount,
    bool? myKudos,
    int? commentCount,
    bool? myPost,
    int? durationSeconds,
    int? stepsCount,
    int? caloriesCount,
    String? averagePace,
    String? challengeName,
  }) {
    return HomeFeedItem(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      title: title ?? this.title,
      caption: caption ?? this.caption,
      duration: duration ?? this.duration,
      calories: calories ?? this.calories,
      steps: steps ?? this.steps,
      distanceKm: distanceKm ?? this.distanceKm,
      workoutType: workoutType ?? this.workoutType,
      imageUrl: imageUrl ?? this.imageUrl,
      hasGpsRoute: hasGpsRoute ?? this.hasGpsRoute,
      createdAt: createdAt ?? this.createdAt,
      kudosCount: kudosCount ?? this.kudosCount,
      myKudos: myKudos ?? this.myKudos,
      commentCount: commentCount ?? this.commentCount,
      myPost: myPost ?? this.myPost,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      stepsCount: stepsCount ?? this.stepsCount,
      caloriesCount: caloriesCount ?? this.caloriesCount,
      averagePace: averagePace ?? this.averagePace,
      challengeName: challengeName ?? this.challengeName,
    );
  }
}
