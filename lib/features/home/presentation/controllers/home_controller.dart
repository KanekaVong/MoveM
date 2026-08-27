import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/fcm_service.dart';
import '../../../../core/storage/user_manager.dart';
import '../../../../shared/base/base_controller.dart';
import '../../../auth/data/dto/response/user_response.dart';
import '../../../friends/presentation/bindings/friends_binding.dart';
import '../../../friends/presentation/screens/add_friends_screen.dart';
import '../../../main_nav/presentation/controllers/main_nav_controller.dart';
import '../../data/dto/response/dashboard_response.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../data/services/home_service.dart';
import '../../domain/repositories/home_repository.dart';

class HomeController extends BaseController {
  final HomeRepository repository = HomeRepositoryImpl(HomeService());

  final Rx<DashboardResponse?> dashboardData = Rx<DashboardResponse?>(null);
  final Rx<UserResponse?> currentUser = Rx<UserResponse?>(null);

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    fetchDashboard();
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
    final firstName = user?.firstName?.trim();
    if (firstName != null && firstName.isNotEmpty) {
      return firstName;
    }
    if (user?.username != null && user!.username.isNotEmpty) {
      return user.username;
    }
    return 'MoveM User';
  }

  String get userInitial {
    final name = greetingName;
    return name.isNotEmpty ? name[0].toUpperCase() : 'M';
  }

  String? get profilePicUrl => currentUser.value?.profilePic;

  String get recentActivityMessage {
    final activities = dashboardData.value?.recentActivities;
    if (activities != null && activities.isNotEmpty) {
      return activities.first.message ?? 'Stay Active Today!';
    }
    return 'Stay Active Today!';
  }

  Future<void> fetchDashboard() async {
    await executeApi<DashboardResponse>(
      apiCall: () => repository.getDashboard(),
      onSuccess: (data) {
        dashboardData.value = data;
      },
      showLoading: false,
    );
  }

  void onNotificationTap() {
    Get.toNamed(AppRoutes.notifications);
  }

  void onProfileTap() {
    Get.toNamed(AppRoutes.profile)?.then((_) {
      loadUserData();
    });
  }

  void onAddTaskTap() {
    if (Get.isRegistered<MainNavController>()) {
      Get.find<MainNavController>().changeTab(1);
    }
  }

  void onLogWorkoutTap() {
    if (Get.isRegistered<MainNavController>()) {
      Get.find<MainNavController>().changeTab(2);
    }
  }

  void onPlanTripsTap() {
    if (Get.isRegistered<MainNavController>()) {
      Get.find<MainNavController>().changeTab(3);
    }
  }

  void onAddFriendsTap() {
    Get.to(() => const AddFriendsScreen(), binding: FriendsBinding());
  }
}
