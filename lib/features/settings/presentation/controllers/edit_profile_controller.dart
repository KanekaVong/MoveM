import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/storage/user_manager.dart';
import '../../../../shared/base/base_controller.dart';
import '../../../auth/data/dto/response/user_response.dart';

class EditProfileController extends BaseController {
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController usernameController;
  late final TextEditingController bioController;

  final RxString selectedGender = 'Select Gender'.obs;
  final RxString profilePic = ''.obs;
  final Rx<UserResponse?> initialUser = Rx<UserResponse?>(null);
  final ImagePicker _picker = ImagePicker();

  void init(UserResponse? user) {
    initialUser.value = user;
    firstNameController = TextEditingController(text: user?.firstName ?? '');
    lastNameController = TextEditingController(text: user?.lastName ?? '');
    usernameController = TextEditingController(text: user?.username ?? '');
    bioController = TextEditingController(text: '');
    profilePic.value = user?.profilePic ?? '';
    selectedGender.value = user?.gender ?? 'Select Gender';
  }

  void onGenderSelected(String gender) {
    selectedGender.value = gender;
  }

  Future<void> onPickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        profilePic.value = pickedFile.path;
      }
    } catch (_) {}
  }

  Future<void> onSave() async {
    final current = initialUser.value;
    final updatedUser = UserResponse(
      id: current?.id ?? '',
      username: usernameController.text.trim().isNotEmpty
          ? usernameController.text.trim()
          : (current?.username ?? ''),
      email: current?.email ?? '',
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      phone: current?.phone,
      cityProvince: current?.cityProvince,
      dateOfBirth: current?.dateOfBirth,
      jointDate: current?.jointDate,
      languagePreference: current?.languagePreference,
      themePreference: current?.themePreference,
      profilePic: profilePic.value.isNotEmpty ? profilePic.value : current?.profilePic,
      gender: selectedGender.value != 'Select Gender' ? selectedGender.value : current?.gender,
      isActive: current?.isActive ?? true,
    );

    await UserManager().saveUser(updatedUser);
    Get.back(result: true);
  }

  void onCancel() {
    Get.back();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    bioController.dispose();
    super.onClose();
  }
}
