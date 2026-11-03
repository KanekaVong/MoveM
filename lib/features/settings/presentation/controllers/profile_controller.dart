import 'package:get/get.dart';
import '../../../../core/storage/user_manager.dart';
import '../../../../shared/base/base_controller.dart';
import '../../../auth/data/dto/response/user_response.dart';
import '../../../../core/routes/app_routes.dart';
import 'package:movem/core/utils/l10n.dart';

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
    return u?.username.isNotEmpty == true ? u!.username : tr.homeMovemUser;
  }

  String get username => user.value?.username ?? 'unknown';

  String get email => user.value?.email ?? tr.notSetUp;

  String get phone => user.value?.phone ?? tr.notSetUp;

  String get dateOfBirth => user.value?.dateOfBirth ?? tr.notSetUp;

  String get location => user.value?.cityProvince ?? tr.notSetUp;

  String? get profilePic => user.value?.profilePic;

  String get initial {
    final name = displayName;
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  void onBackTap() {
    Get.back();
  }

  void onEditProfileTap() {
    Get.toNamed(AppRoutes.editProfile)?.then((_) {
      loadProfile();
    });
  }
}
