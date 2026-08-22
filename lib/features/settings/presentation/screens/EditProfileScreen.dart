import 'package:flutter/material.dart';
import 'package:movem/shared/widgets/custom_glass_button.dart';
import 'package:movem/shared/widgets/glass_container.dart';
import 'package:movem/features/auth/data/dto/response/user_response.dart';
// import 'package:movem/core/storage/user_manager.dart'; // Uncomment if needed

class EditProfileScreen extends StatefulWidget {
  final UserResponse? user; // Fixed: removed the default assignment here

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _bioController;
  late final TextEditingController _usernameController;

  String _selectedGender = 'Select Gender';

  @override
  void initState() {
    super.initState();
    // Safe handling in case user is null
    final user = widget.user;
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _bioController = TextEditingController(text: '');
    _usernameController = TextEditingController(text: user?.username ?? '');
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
    final profilePic = widget.user?.profilePic;

    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              // Top Bar (Cancel & Done buttons)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomGlassButton(
                    label: 'Cancel',
                    width: 90,
                    height: 38,
                    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CustomGlassButton(
                    label: 'Done',
                    width: 90,
                    height: 38,
                    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    onPressed: () {
                      // Handle profile update logic here
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Dynamic Profile Avatar
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                        image: DecorationImage(
                          image: profilePic != null && profilePic.isNotEmpty
                              ? NetworkImage(profilePic)
                              : const NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          // Handle image picker update
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B499B),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
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

              // First & Last Name Container
              GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                opacity: 0.08,
                blur: 20,
                child: Column(
                  children: [
                    TextField(
                      controller: _firstNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'First Name',
                        hintStyle: TextStyle(color: Colors.white54, fontSize: 15),
                        border: InputBorder.none,
                      ),
                    ),
                    Divider(color: Colors.white.withOpacity(0.1), height: 1),
                    TextField(
                      controller: _lastNameController,
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

              // Bio Container
              GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                opacity: 0.08,
                blur: 20,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _bioController,
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

              // Username Container
              GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                opacity: 0.08,
                blur: 20,
                child: TextField(
                  controller: _usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Username',
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 15),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Gender Selector Container
              GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                opacity: 0.08,
                blur: 20,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedGender == 'Select Gender' ? null : _selectedGender,
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
                      setState(() {
                        _selectedGender = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}