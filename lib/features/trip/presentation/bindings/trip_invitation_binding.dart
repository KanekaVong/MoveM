import 'package:get/get.dart';

import '../../../groups/data/repositories/group_repository_impl.dart';
import '../../../groups/data/services/group_service.dart';
import '../../../groups/domain/repositories/group_repository.dart';
import '../controllers/trip_invitation_controller.dart';

class TripInvitationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupService>(
          () => GroupService(),
    );

    Get.lazyPut<GroupRepository>(
          () => GroupRepositoryImpl(
        groupService: Get.find<GroupService>(),
      ),
    );

    Get.lazyPut<TripInvitationController>(
          () => TripInvitationController(
        groupRepository: Get.find<GroupRepository>(),
      ),
    );
  }
}