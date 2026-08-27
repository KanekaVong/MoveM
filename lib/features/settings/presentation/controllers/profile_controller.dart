import 'package:get/get.dart';
import '../../../../core/storage/user_manager.dart';
import '../../../../shared/base/base_controller.dart';
import '../../../auth/data/dto/response/user_response.dart';
import '../screens/EditProfileScreen.dart';

class ProfileController extends BaseController {
  final Rx<UserResponse?> user = Rx<UserResponse?>(null);

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  void loadProfile() {
    user.value = UserManager().getUser();
  }

  String get displayName {
    final u = user.value;
    final fullName = [u?.firstName, u?.lastName]
        .where((v) => v != null && v.trim().isNotEmpty)
        .join(' ');
    if (fullName.isNotEmpty) return fullName;
    return u?.username.isNotEmpty == true ? u!.username : 'MoveM User';
  }

  String get username => user.value?.username ?? 'unknown';

  String get email => user.value?.email ?? 'Not Set Up';

  String get phone => user.value?.phone ?? 'Not Set Up';

  String get dateOfBirth => user.value?.dateOfBirth ?? 'Not Set Up';

  String get location => user.value?.cityProvince ?? 'Not Set Up';

  String? get profilePic => user.value?.profilePic;

  String get initial {
    final name = displayName;
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  void onBackTap() {
    Get.back();
  }

  void onEditProfileTap() {
    if (user.value != null) {
      Get.to(() => EditProfileScreen(user: user.value))?.then((_) {
        loadProfile();
      });
    }
  }
}
