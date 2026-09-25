abstract class FitnessEndpoints {
  static const String profile = 'fitness/profile';
  static const String statistics = 'statistics/fitness';

  static const String goals = 'fitness/goals';
  static String goalDetail(dynamic goalId) => 'fitness/goals/$goalId';

  static const String achievements = 'fitness/achievements';
  static const String myAchievements = 'fitness/achievements/me';
  static const String myAchievementCount = 'fitness/achievements/me/count';

  static const String soloChallenges = 'fitness/solo-challenges';
  static String soloChallengesByType(String workoutType) => 'fitness/solo-challenges/type/$workoutType';
  static String soloChallengeDetail(dynamic challengeId) => 'fitness/solo-challenges/$challengeId';

  static const String clubs = 'fitness/clubs';
  static const String searchClubs = 'fitness/clubs/search';
  static String clubByJoinToken(String joinToken) => 'fitness/clubs/join/$joinToken';
  static const String myClubJoinRequests = 'fitness/clubs/join-requests/my';
  static String cancelClubJoinRequest(dynamic requestId) => 'fitness/clubs/join-requests/$requestId';
  static String clubDetail(dynamic clubId) => 'fitness/clubs/$clubId';
  static String clubJoin(dynamic clubId) => 'fitness/clubs/$clubId/join';
  static String clubJoinRequest(dynamic clubId) => 'fitness/clubs/$clubId/join-request';
  static String clubPendingRequests(dynamic clubId) => 'fitness/clubs/$clubId/join-requests';
  static String approveClubJoinRequest(dynamic clubId, dynamic requestId) =>
      'fitness/clubs/$clubId/join-requests/$requestId/approve';
  static String rejectClubJoinRequest(dynamic clubId, dynamic requestId) =>
      'fitness/clubs/$clubId/join-requests/$requestId/reject';
  static String clubMembers(dynamic clubId) => 'fitness/clubs/$clubId/members';
  static String clubMemberDetail(dynamic clubId, dynamic userId) => 'fitness/clubs/$clubId/members/$userId';
  static String clubMemberRole(dynamic clubId, dynamic userId) => 'fitness/clubs/$clubId/members/$userId/role';
  static String clubChallenges(dynamic clubId) => 'fitness/clubs/$clubId/challenges';
  static String clubChallengeFromCatalog(dynamic clubId, dynamic catalogId) =>
      'fitness/clubs/$clubId/challenges/from-catalog/$catalogId';

  static const String groupChallengeCatalog = 'fitness/group-challenge/catalog';
  static String groupChallengeCatalogByType(String workoutType) =>
      'fitness/group-challenge/catalog/workout-type/$workoutType';
  static String groupChallengeCatalogDetail(dynamic catalogId) => 'fitness/group-challenge/catalog/$catalogId';
  static const String myGroupChallenges = 'fitness/challenges/my';
  static String groupChallengeDetail(dynamic challengeId) => 'fitness/challenges/$challengeId';
  static String joinGroupChallenge(dynamic challengeId) => 'fitness/group-challenges/$challengeId/join';
  static String leaveGroupChallenge(dynamic challengeId) => 'fitness/group-challenges/$challengeId/leave';
  static String groupChallengeParticipants(dynamic challengeId) =>
      'fitness/group-challenges/$challengeId/participants';
  static String groupChallengeMyParticipation(dynamic challengeId) =>
      'fitness/group-challenges/$challengeId/participants/me';
  static const String myParticipation = 'fitness/group-challenges/participants/me';
  static String participantDetail(dynamic participantId) => 'fitness/group-challenges/participants/$participantId';
  static String challengeSocial(dynamic challengeId) => 'fitness/$challengeId/social';

  static const String workouts = 'fitness/workouts';
  static const String workoutHistory = 'fitness/workouts/history';
  static const String searchWorkouts = 'fitness/workouts/search';
  static const String workoutSocialFeed = 'fitness/workouts/social-feed';
  static const String startWorkout = 'fitness/workouts/start';
  static String workoutDetail(dynamic sessionId) => 'fitness/workouts/$sessionId';
  static String workoutSummary(dynamic sessionId) => 'fitness/workouts/$sessionId/summary';
  static String pauseWorkout(dynamic sessionId) => 'fitness/workouts/$sessionId/pause';
  static String resumeWorkout(dynamic sessionId) => 'fitness/workouts/$sessionId/resume';
  static String updateWorkoutProgress(dynamic sessionId) => 'fitness/workouts/$sessionId/progress';
  static String finishWorkout(dynamic sessionId) => 'fitness/workouts/$sessionId/finish';
  static String workoutRoute(dynamic sessionId) => 'fitness/workouts/$sessionId/route';
  static String workoutRoutePoints(dynamic sessionId) => 'fitness/workouts/$sessionId/route-points';
  static String workoutAnalysis(dynamic sessionId) => 'fitness/workouts/$sessionId/analysis';
  static String workoutAttachments(dynamic sessionId) => 'fitness/workouts/$sessionId/attachments';
  static String shareWorkout(dynamic sessionId) => 'fitness/workouts/$sessionId/share';
  static String socialWorkout(dynamic sessionId) => 'fitness/workouts/$sessionId/social';
  static String workoutKudos(dynamic sessionId) => 'fitness/workouts/$sessionId/kudos';
  static String workoutKudosCount(dynamic sessionId) => 'fitness/workouts/$sessionId/kudos/count';
  static String hasGivenWorkoutKudos(dynamic sessionId) => 'fitness/workouts/$sessionId/kudos/me';
  static String workoutComments(dynamic sessionId) => 'comments/workouts/$sessionId';
}
