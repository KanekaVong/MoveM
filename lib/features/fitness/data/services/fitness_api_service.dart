import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/fitness_endpoints.dart';

/// Comprehensive Fitness API Service providing direct access to all Swagger fitness endpoints.
/// Supports Profile, Statistics, Goals, Achievements, Solo Challenges, Clubs,
/// Group Challenges, and Live Workout Sessions.
class FitnessApiService {
  final Dio dio = DioClient().dio;

  Future<Response> getProfile() async {
    return await dio.get(FitnessEndpoints.profile, options: Options(responseType: ResponseType.json));
  }

  Future<Response> createProfile(Map<String, dynamic> data) async {
    return await dio.post(FitnessEndpoints.profile, data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> updateProfile(Map<String, dynamic> data) async {
    return await dio.put(FitnessEndpoints.profile, data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> deleteProfile() async {
    return await dio.delete(FitnessEndpoints.profile, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getFitnessStatistics() async {
    return await dio.get(FitnessEndpoints.statistics, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getMyGoals() async {
    return await dio.get(FitnessEndpoints.goals, options: Options(responseType: ResponseType.json));
  }

  Future<Response> createGoal(Map<String, dynamic> data) async {
    return await dio.post(FitnessEndpoints.goals, data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getGoal(dynamic goalId) async {
    return await dio.get(FitnessEndpoints.goalDetail(goalId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> updateGoal(dynamic goalId, Map<String, dynamic> data) async {
    return await dio.put(FitnessEndpoints.goalDetail(goalId), data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> deleteGoal(dynamic goalId) async {
    return await dio.delete(FitnessEndpoints.goalDetail(goalId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getAllAchievements() async {
    return await dio.get(FitnessEndpoints.achievements, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getMyAchievements() async {
    return await dio.get(FitnessEndpoints.myAchievements, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getMyAchievementCount() async {
    return await dio.get(FitnessEndpoints.myAchievementCount, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getAllSoloChallenges() async {
    return await dio.get(FitnessEndpoints.soloChallenges, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getSoloChallengesByType(String workoutType) async {
    return await dio.get(FitnessEndpoints.soloChallengesByType(workoutType), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getSoloChallenge(dynamic challengeId) async {
    return await dio.get(FitnessEndpoints.soloChallengeDetail(challengeId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> createSoloChallenge(Map<String, dynamic> data) async {
    return await dio.post(FitnessEndpoints.soloChallenges, data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> updateSoloChallenge(dynamic challengeId, Map<String, dynamic> data) async {
    return await dio.put(FitnessEndpoints.soloChallengeDetail(challengeId), data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> deleteSoloChallenge(dynamic challengeId) async {
    return await dio.delete(FitnessEndpoints.soloChallengeDetail(challengeId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> createClub(Map<String, dynamic> data) async {
    return await dio.post(FitnessEndpoints.clubs, data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getMyClubs() async {
    return await dio.get(FitnessEndpoints.myClubs, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getPublicClubs() async {
    return await dio.get(FitnessEndpoints.publicClubs, options: Options(responseType: ResponseType.json));
  }

  Future<Response> searchClubs({Map<String, dynamic>? queryParameters}) async {
    return await dio.get(FitnessEndpoints.searchClubs, queryParameters: queryParameters, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getClubByJoinToken(String joinToken) async {
    return await dio.get(FitnessEndpoints.clubByJoinToken(joinToken), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getMyClubJoinRequests() async {
    return await dio.get(FitnessEndpoints.myClubJoinRequests, options: Options(responseType: ResponseType.json));
  }

  Future<Response> cancelClubJoinRequest(dynamic requestId) async {
    return await dio.delete(FitnessEndpoints.cancelClubJoinRequest(requestId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getClub(dynamic clubId) async {
    return await dio.get(FitnessEndpoints.clubDetail(clubId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> updateClub(dynamic clubId, Map<String, dynamic> data) async {
    return await dio.put(FitnessEndpoints.clubDetail(clubId), data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> deleteClub(dynamic clubId) async {
    return await dio.delete(FitnessEndpoints.clubDetail(clubId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> joinClub(dynamic clubId) async {
    return await dio.post(FitnessEndpoints.clubJoin(clubId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> requestToJoinClub(dynamic clubId) async {
    return await dio.post(FitnessEndpoints.clubJoinRequest(clubId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getClubPendingRequests(dynamic clubId) async {
    return await dio.get(FitnessEndpoints.clubPendingRequests(clubId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> approveClubJoinRequest(dynamic clubId, dynamic requestId) async {
    return await dio.post(FitnessEndpoints.approveClubJoinRequest(clubId, requestId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> rejectClubJoinRequest(dynamic clubId, dynamic requestId) async {
    return await dio.post(FitnessEndpoints.rejectClubJoinRequest(clubId, requestId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getClubMembers(dynamic clubId) async {
    return await dio.get(FitnessEndpoints.clubMembers(clubId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> addClubMember(dynamic clubId, Map<String, dynamic> data) async {
    return await dio.post(FitnessEndpoints.clubMembers(clubId), data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getClubMember(dynamic clubId, dynamic userId) async {
    return await dio.get(FitnessEndpoints.clubMemberDetail(clubId, userId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> removeClubMember(dynamic clubId, dynamic userId) async {
    return await dio.delete(FitnessEndpoints.clubMemberDetail(clubId, userId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> updateClubMemberRole(dynamic clubId, dynamic userId, String role) async {
    return await dio.put(FitnessEndpoints.clubMemberRole(clubId, userId), data: {'role': role}, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getClubChallenges(dynamic clubId) async {
    return await dio.get(FitnessEndpoints.clubChallenges(clubId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> createClubChallenge(dynamic clubId, Map<String, dynamic> data) async {
    return await dio.post(FitnessEndpoints.clubChallenges(clubId), data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> createClubChallengeFromCatalog(dynamic clubId, dynamic catalogId, Map<String, dynamic> data) async {
    return await dio.post(FitnessEndpoints.clubChallengeFromCatalog(clubId, catalogId), data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getGroupChallengeCatalog() async {
    return await dio.get(FitnessEndpoints.groupChallengeCatalog, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getGroupChallengeCatalogByType(String workoutType) async {
    return await dio.get(FitnessEndpoints.groupChallengeCatalogByType(workoutType), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getGroupChallengeCatalogItem(dynamic catalogId) async {
    return await dio.get(FitnessEndpoints.groupChallengeCatalogDetail(catalogId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> createGroupChallengeCatalogItem(Map<String, dynamic> data) async {
    return await dio.post(FitnessEndpoints.groupChallengeCatalog, data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> updateGroupChallengeCatalogItem(dynamic catalogId, Map<String, dynamic> data) async {
    return await dio.put(FitnessEndpoints.groupChallengeCatalogDetail(catalogId), data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> deleteGroupChallengeCatalogItem(dynamic catalogId) async {
    return await dio.delete(FitnessEndpoints.groupChallengeCatalogDetail(catalogId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getMyCreatedGroupChallenges() async {
    return await dio.get(FitnessEndpoints.myGroupChallenges, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getGroupChallenge(dynamic challengeId) async {
    return await dio.get(FitnessEndpoints.groupChallengeDetail(challengeId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> updateGroupChallenge(dynamic challengeId, Map<String, dynamic> data) async {
    return await dio.put(FitnessEndpoints.groupChallengeDetail(challengeId), data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> deleteGroupChallenge(dynamic challengeId) async {
    return await dio.delete(FitnessEndpoints.groupChallengeDetail(challengeId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> joinGroupChallenge(dynamic challengeId) async {
    return await dio.post(FitnessEndpoints.joinGroupChallenge(challengeId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> leaveGroupChallenge(dynamic challengeId) async {
    return await dio.delete(FitnessEndpoints.leaveGroupChallenge(challengeId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getGroupChallengeParticipants(dynamic challengeId) async {
    return await dio.get(FitnessEndpoints.groupChallengeParticipants(challengeId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getGroupChallengeMyParticipation(dynamic challengeId) async {
    return await dio.get(FitnessEndpoints.groupChallengeMyParticipation(challengeId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getMyParticipationAll() async {
    return await dio.get(FitnessEndpoints.myParticipation, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getParticipant(dynamic participantId) async {
    return await dio.get(FitnessEndpoints.participantDetail(participantId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getChallengeSocial(dynamic challengeId) async {
    return await dio.get(FitnessEndpoints.challengeSocial(challengeId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getMyWorkouts() async {
    return await dio.get(FitnessEndpoints.workouts, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getWorkoutHistory() async {
    return await dio.get(FitnessEndpoints.workoutHistory, options: Options(responseType: ResponseType.json));
  }

  Future<Response> searchWorkouts(Map<String, dynamic> searchCriteria) async {
    return await dio.post(FitnessEndpoints.searchWorkouts, data: searchCriteria, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getWorkoutSocialFeed() async {
    return await dio.get(FitnessEndpoints.workoutSocialFeed, options: Options(responseType: ResponseType.json));
  }

  Future<Response> startWorkout(Map<String, dynamic> data) async {
    return await dio.post(FitnessEndpoints.startWorkout, data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getWorkoutDetails(dynamic sessionId) async {
    return await dio.get(FitnessEndpoints.workoutDetail(sessionId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> deleteWorkout(dynamic sessionId) async {
    return await dio.delete(FitnessEndpoints.workoutDetail(sessionId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getWorkoutSummary(dynamic sessionId) async {
    return await dio.get(FitnessEndpoints.workoutSummary(sessionId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> pauseWorkout(dynamic sessionId) async {
    return await dio.patch(FitnessEndpoints.pauseWorkout(sessionId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> resumeWorkout(dynamic sessionId) async {
    return await dio.patch(FitnessEndpoints.resumeWorkout(sessionId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> updateWorkoutProgress(dynamic sessionId, Map<String, dynamic> data) async {
    return await dio.patch(FitnessEndpoints.updateWorkoutProgress(sessionId), data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> finishWorkout(dynamic sessionId, [dynamic data]) async {
    return await dio.post(
      FitnessEndpoints.finishWorkout(sessionId),
      data: data,
      options: Options(responseType: ResponseType.json),
    );
  }

  Future<Response> getWorkoutRoute(dynamic sessionId) async {
    return await dio.get(FitnessEndpoints.workoutRoute(sessionId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> addWorkoutRoutePoints(dynamic sessionId, List<Map<String, dynamic>> points) async {
    return await dio.post(FitnessEndpoints.workoutRoutePoints(sessionId), data: {'points': points}, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getWorkoutAnalysis(dynamic sessionId) async {
    return await dio.get(FitnessEndpoints.workoutAnalysis(sessionId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> saveWorkoutAnalysis(dynamic sessionId, Map<String, dynamic> analysisData) async {
    return await dio.post(FitnessEndpoints.workoutAnalysis(sessionId), data: analysisData, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getWorkoutAttachments(dynamic sessionId) async {
    return await dio.get(FitnessEndpoints.workoutAttachments(sessionId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> uploadWorkoutAttachment(dynamic sessionId, String filePath) async {
    final fileName = filePath.split('/').last;
    final ext = fileName.split('.').last.toLowerCase();
    DioMediaType? mediaType;
    if (ext == 'jpg' || ext == 'jpeg') {
      mediaType = DioMediaType('image', 'jpeg');
    } else if (ext == 'png') {
      mediaType = DioMediaType('image', 'png');
    } else if (ext == 'webp') {
      mediaType = DioMediaType('image', 'webp');
    }
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName, contentType: mediaType),
    });
    return await dio.post(FitnessEndpoints.workoutAttachments(sessionId), data: formData, options: Options(responseType: ResponseType.json));
  }

  Future<Response> shareWorkout(dynamic sessionId, {bool shared = true, String? description}) async {
    return await dio.patch(FitnessEndpoints.shareWorkout(sessionId), data: {'shared': shared, if (description != null) 'description': description}, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getSocialWorkout(dynamic sessionId) async {
    return await dio.get(FitnessEndpoints.socialWorkout(sessionId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> giveWorkoutKudos(dynamic sessionId) async {
    return await dio.post(FitnessEndpoints.workoutKudos(sessionId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> removeWorkoutKudos(dynamic sessionId) async {
    return await dio.delete(FitnessEndpoints.workoutKudos(sessionId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getWorkoutKudosCount(dynamic sessionId) async {
    return await dio.get(FitnessEndpoints.workoutKudosCount(sessionId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> hasGivenWorkoutKudos(dynamic sessionId) async {
    return await dio.get(FitnessEndpoints.hasGivenWorkoutKudos(sessionId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getWorkoutComments(dynamic sessionId) async {
    return await dio.get(FitnessEndpoints.workoutComments(sessionId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> createWorkoutComment(dynamic sessionId, String content) async {
    return await dio.post(FitnessEndpoints.workoutComments(sessionId), data: {'content': content}, options: Options(responseType: ResponseType.json));
  }
}
