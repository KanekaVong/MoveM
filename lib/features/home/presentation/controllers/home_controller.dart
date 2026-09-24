import 'package:get/get.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/fcm_service.dart';
import '../../../../core/storage/user_manager.dart';
import '../../../../shared/base/base_controller.dart';
import '../../../auth/data/dto/response/user_response.dart';
import '../../../fitness/data/models/workout_model.dart';
import '../../../fitness/data/repositories/fitness_workout_repository.dart';
import '../../../fitness/presentation/screens/fitness_club_screen.dart';
import '../../../fitness/presentation/screens/solo_challenge_list_screen.dart';
import '../../../friends/presentation/bindings/friends_binding.dart';
import '../../../friends/presentation/screens/add_friends_screen.dart';
import '../../../main_nav/presentation/controllers/main_nav_controller.dart';
import '../../domain/models/home_feed_item.dart';

class HomeController extends BaseController {
  final FitnessWorkoutRepository workoutRepository = FitnessWorkoutRepository();

  final Rx<UserResponse?> currentUser = Rx<UserResponse?>(null);
  final RxList<HomeFeedItem> feedItems = <HomeFeedItem>[].obs;

  final RxString dailyQuote =
      '“Success is stumbling from failure to failure with no loss of enthusiasm” - Winston Churchill'.obs;
  final RxList<String> sloganWords = <String>['MOVE', 'EXPLORE', 'ACHIEVE'].obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    fetchSocialFeed();
  }

  @override
  void onReady() {
    super.onReady();
    if (UserManager().isLoggedIn) {
      FcmService().requestNotificationPermissions();
    }
  }

  void loadUserData() {
    currentUser.value = UserManager().getUser();
  }

  String get greetingName {
    final user = currentUser.value;
    final fullName = [user?.firstName, user?.lastName]
        .whereType<String>()
        .where((v) => v.trim().isNotEmpty)
        .join(' ')
        .trim();
    if (fullName.isNotEmpty) {
      return fullName;
    }
    if (user != null && user.username.trim().isNotEmpty) {
      return user.username.trim();
    }
    return 'MoveM User';
  }

  String get userInitial {
    final name = greetingName;
    return name.isNotEmpty ? name[0].toUpperCase() : 'M';
  }

  String? get profilePicUrl => currentUser.value?.profilePic;

  String get recentActivityMessage => 'Stay Active Today!';

  Future<void> fetchDashboard() => fetchSocialFeed();

  Future<void> fetchSocialFeed() async {
    final result = await workoutRepository.getWorkoutSocialFeed();
    if (result is ApiSuccess<List<SharedWorkoutPostResponse>>) {
      final posts = result.data;
      if (posts.isNotEmpty) {
        final socialItems = posts.map(_convertSocialPostToFeedItem).toList();
        feedItems.assignAll(socialItems);
        return;
      }
    }
    feedItems.clear();
  }

  HomeFeedItem _convertSocialPostToFeedItem(SharedWorkoutPostResponse post) {
    final workoutType = post.workoutType.toUpperCase();
    final isRunning = workoutType.contains('RUN');
    final durationStr = _formatFeedDuration(post.durationSeconds);

    String title;
    if (isRunning) {
      title = post.distance > 0
          ? 'Completed a ${_formatDistanceKm(post.distance)} Run! 🔥'
          : 'Completed a Run! 🔥';
    } else if (workoutType.contains('PUSH')) {
      title = 'Completed a PushUp Challenge 🔥';
    } else if (workoutType.contains('SQUAT')) {
      title = 'Completed a Squat Challenge 🔥';
    } else {
      title = 'Completed a ${post.workoutType} Challenge 🔥';
    }

    String? imageUrl;
    if (post.attachments.isNotEmpty) {
      imageUrl = post.attachments.first.url ?? post.attachments.first.filePath;
    }

    return HomeFeedItem(
      id: 'social_${post.sessionId}',
      sessionId: post.sessionId,
      userName: post.username.isNotEmpty ? post.username : 'MoveM Athlete',
      userAvatar: post.profilePicture,
      title: title,
      caption: post.shareDescription != null && post.shareDescription!.trim().isNotEmpty
          ? '“${post.shareDescription!.trim()}”'
          : null,
      imageUrl: imageUrl,
      duration: durationStr,
      calories: post.caloriesBurned > 0 ? '${post.caloriesBurned.round()}Cals' : null,
      steps: post.steps > 0 ? '${post.steps}Steps' : null,
      distanceKm: post.distance > 0 ? post.distance : null,
      workoutType: workoutType,
      hasGpsRoute: isRunning && post.distance > 0,
      createdAt: post.finishedAt,
      kudosCount: post.kudosCount,
      myKudos: post.myKudos,
      commentCount: post.commentCount,
      myPost: post.myPost,
      durationSeconds: post.durationSeconds,
      stepsCount: post.steps,
      caloriesCount: post.caloriesBurned.round(),
      averagePace: post.averagePace?.isNotEmpty == true
          ? post.averagePace
          : _formatAveragePace(post.durationSeconds, post.distance),
      challengeName: post.challengeName ?? _fallbackChallengeName(workoutType, post.distance),
    );
  }

  String _formatDistanceKm(double distance) {
    if (distance >= 1) {
      return '${distance.round()}KM';
    }
    return '${distance.toStringAsFixed(1)}KM';
  }

  String? _formatFeedDuration(int seconds) {
    if (seconds <= 0) return null;
    final hours = seconds ~/ 3600;
    final mins = ((seconds % 3600) / 60).round();
    if (hours > 0) {
      if (mins > 0) return '${hours}Hr ${mins}Mins';
      return '${hours}Hr';
    }
    if (mins > 0) return '${mins}Mins';
    return '${seconds}s';
  }

  String? _formatAveragePace(int durationSeconds, double distanceKm) {
    if (durationSeconds <= 0 || distanceKm <= 0) return null;
    final paceMin = (durationSeconds / 60) / distanceKm;
    if (paceMin.isNaN || paceMin.isInfinite) return null;
    final minutes = paceMin.floor();
    final seconds = ((paceMin - minutes) * 60).round();
    return '$minutes:$seconds / KM';
  }

  String? _fallbackChallengeName(String workoutType, double distanceKm) {
    if (workoutType.contains('RUN') && distanceKm > 0) {
      final km = distanceKm >= 1 ? distanceKm.round() : distanceKm;
      return '$km KILOMETERS SPRINT';
    }
    return null;
  }

  Future<void> toggleKudos(HomeFeedItem item) async {
    if (item.sessionId == null) return;
    final index = feedItems.indexWhere((f) => f.id == item.id);
    if (index == -1) return;

    final willLike = !item.myKudos;
    final updatedKudosCount = willLike ? item.kudosCount + 1 : (item.kudosCount > 0 ? item.kudosCount - 1 : 0);

    feedItems[index] = item.copyWith(
      myKudos: willLike,
      kudosCount: updatedKudosCount,
    );

    if (willLike) {
      final res = await workoutRepository.giveKudos(item.sessionId!);
      if (res is! ApiSuccess<bool>) {
        feedItems[index] = item;
      }
    } else {
      final res = await workoutRepository.removeKudos(item.sessionId!);
      if (res is! ApiSuccess<bool>) {
        feedItems[index] = item;
      }
    }
  }

  void onNotificationTap() {
    Get.toNamed(AppRoutes.notifications);
  }

  void onProfileTap() {
    Get.toNamed(AppRoutes.profile)?.then((_) {
      loadUserData();
    });
  }

  void onAddFriendsTap() {
    Get.to(() => const AddFriendsScreen(), binding: FriendsBinding());
  }

  void onChallengeTap() {
    Get.to(() => const SoloChallengeListScreen());
  }

  void onAddTaskTap() {
    if (Get.isRegistered<MainNavController>()) {
      Get.find<MainNavController>().changeTab(1);
    }
  }

  void onPlanTripsTap() {
    if (Get.isRegistered<MainNavController>()) {
      Get.find<MainNavController>().changeTab(3);
    }
  }

  void onFitnessClubTap() {
    Get.to(() => const FitnessClubScreen());
  }
}
