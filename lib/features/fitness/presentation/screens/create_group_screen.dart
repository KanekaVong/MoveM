import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/fitness_club_controller.dart';
import 'invite_people_screen.dart';
import '../../../../core/theme/app_colors.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

typedef CreateClubScreen = CreateGroupScreen;

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _clubNameController = TextEditingController();
  final TextEditingController _clubDescriptionController = TextEditingController();
  String _privacy = 'Privacy';
  bool _isSubmitting = false;
  final Set<int> _selectedMemberIds = {};

  late final FitnessClubController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<FitnessClubController>()
        ? Get.find<FitnessClubController>()
        : Get.put(FitnessClubController());
  }

  @override
  void dispose() {
    _clubNameController.dispose();
    _clubDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final name = _clubNameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter a club name',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final selectedPrivacy = _privacy == 'Privacy' ? 'PUBLIC' : _privacy.toUpperCase();
    final description = _clubDescriptionController.text.trim();

    final createdClub = await _controller.createClub(
      name: name,
      description: description.isNotEmpty ? description : 'MoveM Fitness Club',
      privacy: selectedPrivacy,
    );

    if (createdClub != null && _selectedMemberIds.isNotEmpty) {
      for (final userId in _selectedMemberIds) {
        await _controller.addMember(createdClub.id, userId);
      }
    }

    if (mounted) {
      setState(() => _isSubmitting = false);
    }
  }

  void _showPrivacyPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Select Privacy',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.public, color: Colors.blueAccent),
                  title: const Text('Public', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Anyone can find and join this club', style: TextStyle(color: AppColors.textCaption, fontSize: 12)),
                  trailing: _privacy == 'Public' ? const Icon(Icons.check_circle, color: Colors.blueAccent) : null,
                  onTap: () {
                    setState(() => _privacy = 'Public');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.lock_outline, color: Colors.amber),
                  title: const Text('Private', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Requires invitation or request to join', style: TextStyle(color: AppColors.textCaption, fontSize: 12)),
                  trailing: _privacy == 'Private' ? const Icon(Icons.check_circle, color: Colors.blueAccent) : null,
                  onTap: () {
                    setState(() => _privacy = 'Private');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.chipSurface.withValues(alpha: 0.5),
                          border: Border.all(
                            color: AppColors.textPrimary.withValues(alpha: 0.15),
                            width: 1.2,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.textPrimary,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Create Club',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),

              const Text(
                'CLUB NAME',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.borderLight,
                    width: 1.2,
                  ),
                ),
                child: TextField(
                  controller: _clubNameController,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    border: InputBorder.none,
                    hintText: 'Enter club name',
                    hintStyle: TextStyle(color: AppColors.textCaption, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'CLUB DESCRIPTION',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.borderLight,
                    width: 1.2,
                  ),
                ),
                child: TextField(
                  controller: _clubDescriptionController,
                  maxLines: 3,
                  maxLength: 1000,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    border: InputBorder.none,
                    counterStyle: TextStyle(color: AppColors.textCaption, fontSize: 11),
                    hintText: 'Describe your club and who should join...',
                    hintStyle: TextStyle(color: AppColors.textCaption, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'PRIVACY',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),

              GestureDetector(
                onTap: _showPrivacyPicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.cardSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.borderLight,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _privacy,
                        style: TextStyle(
                          color: _privacy == 'Privacy' ? AppColors.textSecondary : AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textSecondary,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MEMBERS ( ${_selectedMemberIds.length} )',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final result = await Get.to(() => InvitePeopleScreen(initialSelectedIds: _selectedMemberIds));
                      if (result is List<int>) {
                        setState(() {
                          _selectedMemberIds.clear();
                          _selectedMemberIds.addAll(result);
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.chipSurface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.textPrimary.withValues(alpha: 0.12),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.person_add_outlined,
                            color: AppColors.textPrimary,
                            size: 15,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Invite',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Create Club',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
