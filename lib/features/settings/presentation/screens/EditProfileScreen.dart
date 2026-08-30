import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/custom_glass_button.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../../auth/data/dto/response/user_response.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  final UserResponse? user;

  const EditProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController())..init(user);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomGlassButton(
                    label: l10n?.cancel ?? 'Cancel',
                    width: 90,
                    height: 38,
                    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    onPressed: controller.onCancel,
                  ),
                  CustomGlassButton(
                    label: l10n?.done ?? 'Done',
                    width: 90,
                    height: 38,
                    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    onPressed: controller.onSave,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Center(
                child: Stack(
                  children: [
                    Obx(() {
                      final pic = controller.profilePic.value;
                      final initial = controller.firstNameController.text.isNotEmpty
                          ? controller.firstNameController.text[0].toUpperCase()
                          : (controller.usernameController.text.isNotEmpty
                              ? controller.usernameController.text[0].toUpperCase()
                              : 'U');

                      return Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
                        ),
                        child: ClipOval(
                          child: pic.isNotEmpty
                              ? (pic.startsWith('http')
                                  ? Image.network(
                                      pic,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Center(
                                        child: Text(
                                          initial,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Image.file(
                                      File(pic),
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Center(
                                        child: Text(
                                          initial,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ))
                              : Center(
                                  child: Text(
                                    initial,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                      );
                    }),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: controller.onPickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B499B),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
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

              GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                opacity: 0.08,
                blur: 20,
                child: Column(
                  children: [
                    TextField(
                      controller: controller.firstNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'First Name',
                        hintStyle: TextStyle(color: Colors.white54, fontSize: 15),
                        border: InputBorder.none,
                      ),
                    ),
                    Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
                    TextField(
                      controller: controller.lastNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Last Name',
                        hintStyle: TextStyle(color: Colors.white54, fontSize: 15),
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                opacity: 0.08,
                blur: 20,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.bioController,
                        maxLength: 90,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Bio',
                          hintStyle: TextStyle(color: Colors.white54, fontSize: 15),
                          border: InputBorder.none,
                          counterText: '',
                        ),
                      ),
                    ),
                    const Text(
                      '90',
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                opacity: 0.08,
                blur: 20,
                child: TextField(
                  controller: controller.usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Username',
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 15),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                opacity: 0.08,
                blur: 20,
                child: Obx(() {
                  final currentGender = controller.selectedGender.value;

                  return DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: currentGender == 'Select Gender' ? null : currentGender,
                      hint: const Text(
                        'Gender',
                        style: TextStyle(color: Colors.white54, fontSize: 15),
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
                      dropdownColor: const Color(0xFF131D38),
                      isExpanded: true,
                      items: ['Male', 'Female', 'Other'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          controller.onGenderSelected(newValue);
                        }
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
