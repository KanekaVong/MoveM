import 'package:get/get.dart';
import '../../../../core/storage/user_manager.dart';
import '../../../../shared/base/base_controller.dart';
import '../../data/dto/response/public_user_profile_response.dart';
import '../../domain/repositories/friends_repository.dart';

class PublicUserProfileController extends BaseController {
  final FriendsRepository repository;
  final String userId;

  PublicUserProfileController({
    required this.repository,
    required this.userId,
    PublicUserProfileResponse? initialProfile,
  }) {
    if (initialProfile != null) {
      profile.value = initialProfile;
    }
  }

  final Rxn<PublicUserProfileResponse> profile = Rxn<PublicUserProfileResponse>();

  bool get isOwnProfile {
    final currentId = UserManager().getUser()?.id ?? UserManager().userId;
    if (currentId == null || currentId.isEmpty) return false;
    return currentId == userId || currentId == profile.value?.id;
  }

  @override
  void onInit() {
    super.onInit();
    if (profile.value == null) {
      loadProfile();
    }
  }

  Future<void> loadProfile() async {
    await executeApi(
      apiCall: () => repository.getUserById(userId),
      onSuccess: (data) {
        profile.value = data;
      },
    );
  }

  Future<void> sendFriendRequest() async {
    final username = profile.value?.username ?? '';
    if (username.isEmpty || isOwnProfile || profile.value?.isRequestPending == true) {
      return;
    }

    await executeApi(
      apiCall: () => repository.sendFriendRequest(username),
      onSuccess: (_) {
        profile.value = profile.value?.copyWith(friendStatus: 'PENDING_REQUEST');
      },
    );
  }
}
