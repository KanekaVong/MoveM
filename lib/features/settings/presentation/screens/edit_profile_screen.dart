import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:movem/core/config/app_config.dart';
import 'package:movem/core/storage/profile_image_store.dart';
import 'package:movem/core/theme/app_colors.dart';
import 'package:movem/core/storage/user_manager.dart';

import 'package:movem/features/settings/data/dto/request/update_profile_picture_request.dart';
import 'package:movem/features/auth/data/dto/response/user_response.dart';
import 'package:movem/features/settings/data/dto/request/update_profile_request.dart';

import 'package:movem/shared/widgets/auth_image.dart';
import 'package:movem/shared/widgets/top_tool_bar.dart';
import '../controllers/setting_controller.dart';
import '../../data/services/setting_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  UserResponse? _user;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _bioController;
  late final TextEditingController _usernameController;
  late final SettingController _settingController;

  // Image Selection State Members
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedProfileImage;
  bool _removeProfileImage = false;

  String? _selectedGender;

  // Allowed Gender values
  static const List<String> _genderOptions = [
    'MALE',
    'FEMALE',
    'OTHER',
    'PREFER_NOT_TO_SAY',
  ];

  @override
  void initState() {
    super.initState();
    _user = UserManager().getUser();

    _firstNameController = TextEditingController(text: _user?.firstName ?? '');
    _lastNameController = TextEditingController(text: _user?.lastName ?? '');
    _bioController = TextEditingController(text: _user?.bio ?? '');
    _usernameController = TextEditingController(text: _user?.username ?? '');

    // Safely assign initial gender (convert to uppercase & check if it exists in options)
    final rawGender = _user?.gender?.toUpperCase();
    if (rawGender != null && _genderOptions.contains(rawGender)) {
      _selectedGender = rawGender;
    } else {
      _selectedGender = null;
    }

    _settingController = Get.find<SettingController>();
  }

  Future<void> _showProfileImageOptions() async {
    final hasCurrentImage =
        (_user?.profilePic != null && _user!.profilePic!.isNotEmpty) ||
            _selectedProfileImage != null;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.isDark ? const Color(0xFF131D38) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderMuted,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Change Profile Photo',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildImageOption(
                  icon: Icons.photo_library_outlined,
                  title: 'Choose from Library',
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _pickProfileImage(ImageSource.gallery);
                  },
                ),
                _buildImageOption(
                  icon: Icons.camera_alt_outlined,
                  title: 'Take Photo',
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _pickProfileImage(ImageSource.camera);
                  },
                ),
                if (hasCurrentImage)
                  _buildImageOption(
                    icon: Icons.delete_outline,
                    title: 'Remove Current Profile',
                    isDestructive: true,
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _selectedProfileImage = null;
                        _removeProfileImage = true;
                      });
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickProfileImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (pickedFile == null) return;

      setState(() {
        _selectedProfileImage = File(pickedFile.path);
        _removeProfileImage = false;
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not select image.',
      );
    }
  }

  Future<String?> _uploadProfileImage(File imageFile) async {
    try {
      final url = await Get.find<SettingService>().uploadProfilePicFile(imageFile.path);
      if (url != null && url.isNotEmpty) {
        await ProfileImageStore.remember(url, imageFile.path);
      }
      return url;
    } catch (_) {
      Get.snackbar('Upload failed', 'Could not upload profile picture.');
      return null;
    }
  }

  Widget _buildProfileImage() {
    if (_removeProfileImage) {
      return Container(
        color: const Color(0xFF162341),
        child: const Icon(
          Icons.person_outline,
          color: Colors.white54,
          size: 50,
        ),
      );
    }

    if (_selectedProfileImage != null) {
      return Image.file(
        _selectedProfileImage!,
        fit: BoxFit.cover,
      );
    }

    final profilePic = _user?.profilePic;

    if (profilePic != null && profilePic.isNotEmpty) {
      return AuthImage(
        url: AppConfig.resolveMediaUrl(profilePic),
        fallback: Container(
          color: const Color(0xFF162341),
          child: const Icon(Icons.person_outline, color: Colors.white54, size: 50),
        ),
      );
    }

    return Container(
      color: const Color(0xFF162341),
      child: const Icon(
        Icons.person_outline,
        color: Colors.white54,
        size: 50,
      ),
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 4,
      ),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isDestructive
              ? Colors.redAccent.withValues(alpha: 0.12)
              : const Color(0xFF1B499B).withValues(alpha: 0.25),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.redAccent : AppColors.accentBlue,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.redAccent : AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  Future<void> _saveProfile() async {
    final firstname = _firstNameController.text.trim();
    final lastname = _lastNameController.text.trim();
    final username = _usernameController.text.trim();
    final bio = _bioController.text.trim();

    final firstnameChanged =
        firstname != (_user?.firstName ?? '');

    final lastnameChanged =
        lastname != (_user?.lastName ?? '');

    final usernameChanged =
        username != (_user?.username ?? '');

    final bioChanged =
        bio != (_user?.bio ?? '');

    final genderChanged =
        _selectedGender != _user?.gender;

    final profilePictureChanged =
        _selectedProfileImage != null ||
            _removeProfileImage;

    if (!firstnameChanged &&
        !lastnameChanged &&
        !usernameChanged &&
        !bioChanged &&
        !genderChanged &&
        !profilePictureChanged) {
      Navigator.of(context).pop();
      return;
    }

    // --------------------------------------------------
    // 1. Update normal profile fields
    // --------------------------------------------------

    if (firstnameChanged ||
        lastnameChanged ||
        usernameChanged ||
        bioChanged ||
        genderChanged) {
      final request = UpdateProfileRequest(
        firstname: firstnameChanged ? firstname : null,
        lastname: lastnameChanged ? lastname : null,
        username: usernameChanged ? username : null,
        bio: bioChanged ? bio : null,
        gender: genderChanged ? _selectedGender : null,
      );

      final updatedProfile =
      await _settingController.updateProfile(request);

      if (updatedProfile == null) {
        return;
      }

      _user = updatedProfile;
    }

    // --------------------------------------------------
    // 2. Update profile picture
    // --------------------------------------------------

    if (profilePictureChanged) {
      String? profilePicUrl;

      if (_removeProfileImage) {
        profilePicUrl = null;
      } else if (_selectedProfileImage != null) {
        profilePicUrl =
        await _uploadProfileImage(
          _selectedProfileImage!,
        );

        if (profilePicUrl == null) {
          return;
        }
      }

      final updatedUser =
      await _settingController.updateProfilePicture(
        UpdateProfilePictureRequest(
          profilePic: profilePicUrl,
        ),
      );

      if (updatedUser == null) {
        return;
      }

      _user = updatedUser;
    }

    // --------------------------------------------------
    // 3. Get the newest stored user
    // --------------------------------------------------

    final latestUser = UserManager().getUser();

    if (latestUser != null && mounted) {
      setState(() {
        _user = latestUser;
      });

      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageColor = AppColors.pageBackground;
    final onPage = AppColors.textPrimary;
    final dark = AppColors.isDark;
    return Scaffold(
      backgroundColor: pageColor,
      appBar: TopToolBar(
        title: 'Edit Profile',
        backgroundColor: pageColor,
        foregroundColor: onPage,
        onBack: () => Navigator.of(context).pop(),
        actions: [
          TopToolBarAction(
            icon: Icons.check_rounded,
            onTap: _saveProfile,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              // Dynamic Profile Avatar
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: dark ? Colors.white.withValues(alpha: 0.2) : AppColors.borderMuted,
                          width: 1.5,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _buildProfileImage(),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showProfileImageOptions,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B499B),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // First Name
              CustomMuiTextField(
                label: 'First Name',
                controller: _firstNameController,
              ),
              const SizedBox(height: 20),

              // Last Name
              CustomMuiTextField(
                label: 'Last Name',
                controller: _lastNameController,
              ),
              const SizedBox(height: 20),

              // Bio
              CustomMuiTextField(
                label: 'Bio',
                controller: _bioController,
                maxLength: 90,
                showRemainingCount: true,
              ),
              const SizedBox(height: 20),

              // Username
              CustomMuiTextField(
                label: 'Username',
                controller: _usernameController,
              ),
              const SizedBox(height: 20),

              // Working Gender Dropdown Menu
              DropdownMenu<String>(
                initialSelection: _selectedGender,
                expandedInsets: EdgeInsets.zero,
                label: const Text('Gender'),
                textStyle: TextStyle(color: onPage, fontSize: 15),
                trailingIcon: Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                selectedTrailingIcon: Icon(Icons.keyboard_arrow_up, color: AppColors.textSecondary),
                menuStyle: MenuStyle(
                  backgroundColor: WidgetStateProperty.all(dark ? const Color(0xFF131D38) : Colors.white),
                  maximumSize: WidgetStateProperty.all(const Size.fromHeight(250)),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelStyle: TextStyle(color: AppColors.textSecondary, fontSize: 15),
                  floatingLabelStyle: TextStyle(
                    color: onPage,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: dark ? Colors.white.withValues(alpha: 0.2) : AppColors.borderMuted,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: dark ? Colors.white : AppColors.accentBlue,
                      width: 1.5,
                    ),
                  ),
                ),
                dropdownMenuEntries: [
                  DropdownMenuEntry<String>(
                    value: 'MALE',
                    label: 'Male',
                    style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(AppColors.textPrimary),
                    ),
                  ),
                  DropdownMenuEntry<String>(
                    value: 'FEMALE',
                    label: 'Female',
                    style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(AppColors.textPrimary),
                    ),
                  ),
                  DropdownMenuEntry<String>(
                    value: 'OTHER',
                    label: 'Other',
                    style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(AppColors.textPrimary),
                    ),
                  ),
                  DropdownMenuEntry<String>(
                    value: 'PREFER_NOT_TO_SAY',
                    label: 'Prefer not to say',
                    style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(AppColors.textPrimary),
                    ),
                  ),
                ],
                onSelected: (newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomMuiTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;
  final int? maxLength;
  final bool showRemainingCount;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const CustomMuiTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
    this.maxLength,
    this.showRemainingCount = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white54,
        fontSize: 15,
      ),
      floatingLabelStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.white,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.5,
        ),
      ),
      counterText: showRemainingCount ? '' : null,
      suffixIcon: suffixIcon,
    );

    final textField = TextFormField(
      controller: controller,
      initialValue: initialValue,
      onChanged: onChanged,
      readOnly: readOnly,
      onTap: onTap,
      maxLength: maxLength,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: decoration,
    );

    if (maxLength != null && showRemainingCount && controller != null) {
      return Stack(
        alignment: Alignment.centerRight,
        children: [
          textField,
          Positioned(
            right: 12,
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller!,
              builder: (context, value, child) {
                final remaining = maxLength! - value.text.length;
                return Text(
                  '$remaining',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    return textField;
  }
}