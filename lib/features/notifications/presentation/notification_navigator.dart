import 'package:get/get.dart';
import '../../../core/network/api_result.dart';
import '../../../core/routes/app_routes.dart';
import '../../friends/presentation/bindings/friends_binding.dart';
import '../../friends/presentation/screens/add_friends_screen.dart';
import '../../main_nav/presentation/controllers/main_nav_controller.dart';
import '../../settings/presentation/screens/ProfileScreen.dart';
import '../../task/presentation/screens/task_comment_screen.dart';
import '../../task/presentation/screens/task_detail_screen.dart';
import '../../task/presentation/screens/task_invitation_screen.dart';
import '../../trip/data/repositories/trip_repository_impl.dart';
import '../../trip/data/services/trip_service.dart';
import '../../trip/presentation/controllers/edit_trip_controller.dart';
import '../../trip/presentation/controllers/trip_controller.dart';
import '../../trip/presentation/screens/trip_detail_screen.dart';
import 'package:movem/core/utils/l10n.dart';

/// Opens the screen a notification points at. Shared by the notification list
/// and push-notification taps so both route the same way.
///
/// Types and reference types follow `NotificationResponse` in the API docs.
/// `GROUP` references are activity groups (tasks and trips), never fitness
/// clubs, so they open the task or trip the group belongs to.
class NotificationNavigator {
  NotificationNavigator._();

  static const _taskTab = 1;
  static const _fitnessTab = 2;
  static const _tripTab = 3;

  static Future<void> open({
    String? notificationType,
    String? referenceType,
    String? referenceId,
    String? title,
  }) async {
    final notifType = notificationType?.toUpperCase() ?? '';
    final refType = referenceType?.toUpperCase() ?? '';
    final refId = referenceId?.trim() ?? '';

    // Task comments
    if (notifType == 'COMMENT_CREATED' || refType == 'COMMENT') {
      if (refId.isNotEmpty) {
        Get.to(() => TaskCommentScreen(
              activityId: refId,
              taskTitle: title ?? tr.taskDetails,
            ));
      } else {
        _switchToTab(_taskTab);
      }
      return;
    }

    // Tasks: TASK_ASSIGNED, TASK_COMPLETED, TASK_DEADLINE, TASK_REMINDER
    if (notifType.startsWith('TASK_') || refType == 'TASK') {
      _openTask(refId);
      return;
    }

    // Trips: TRIP_UPDATED, TRIP_EXPENSE_LOGGED, TRIP_REMINDER
    if (notifType == 'TRIP_INVITE') {
      Get.toNamed(AppRoutes.tripInvitations);
      return;
    }
    if (notifType.startsWith('TRIP_') || refType == 'TRIP') {
      _openTrip(refId);
      return;
    }

    // Activity groups (tasks and trips)
    if (notifType.startsWith('GROUP_') ||
        notifType == 'MEMBER_INVITED' ||
        refType == 'GROUP') {
      switch (notifType) {
        // The receiver has not joined yet, so show their pending invitations.
        case 'MEMBER_INVITED':
        case 'GROUP_INVITE':
          Get.to(() => const TaskInvitationScreen());
          return;
        // The receiver is not (or no longer) a member, so there is no detail
        // screen they can open.
        case 'GROUP_MEMBER_REMOVED':
        case 'GROUP_JOIN_REQUEST_REJECTED':
          _switchToTab(_taskTab);
          return;
        // GROUP_INVITE_ACCEPTED, GROUP_INVITE_REJECTED, GROUP_JOIN_REQUEST,
        // GROUP_JOIN_REQUEST_APPROVED, GROUP_MEMBER_LEFT
        default:
          await _openActivity(refId);
          return;
      }
    }

    // Friends
    if (notifType == 'FRIEND_REQUEST' ||
        notifType == 'FRIEND_ACCEPTED' ||
        refType == 'USER') {
      Get.to(() => const AddFriendsScreen(), binding: FriendsBinding());
      return;
    }

    // Fitness: FITNESS_REMINDER, WORKOUT_KUDOED, WORKOUT_COMPLETED
    if (notifType.startsWith('FITNESS_') ||
        notifType.startsWith('WORKOUT_') ||
        refType == 'FITNESS') {
      _switchToTab(_fitnessTab);
      return;
    }

    // Achievements
    if (notifType == 'ACHIEVEMENT_UNLOCKED' || refType == 'ACHIEVEMENT') {
      Get.to(() => const ProfileScreen());
      return;
    }

    // SYSTEM and unknown types have no destination.
  }

  static void _openTask(String activityId) {
    if (activityId.isEmpty) {
      _switchToTab(_taskTab);
      return;
    }
    Get.to(() => TaskDetailScreen(activityId: activityId));
  }

  static void _openTrip(String activityId) {
    if (activityId.isEmpty) {
      _switchToTab(_tripTab);
      return;
    }
    final repository = TripRepositoryImpl(tripService: TripService());
    Get.to(() => TripDetailScreen(
          activityId: activityId,
          editTripController: EditTripController(
            tripRepository: repository,
            tripController: TripController(repository: repository),
            activityId: activityId,
          ),
        ));
  }

  /// A group reference only carries the activity id, so check whether it is
  /// a trip before falling back to the task detail screen.
  static Future<void> _openActivity(String activityId) async {
    if (activityId.isEmpty) {
      _switchToTab(_taskTab);
      return;
    }
    final trip = await TripRepositoryImpl(tripService: TripService())
        .getTripDetail(activityId);
    if (trip is ApiSuccess) {
      _openTrip(activityId);
    } else {
      _openTask(activityId);
    }
  }

  static void _switchToTab(int tabIndex) {
    if (Get.isRegistered<MainNavController>()) {
      Get.find<MainNavController>().changeTab(tabIndex);
      Get.until((route) => route.isFirst);
    } else {
      Get.toNamed(AppRoutes.main, arguments: {'tab': tabIndex});
    }
  }
}
