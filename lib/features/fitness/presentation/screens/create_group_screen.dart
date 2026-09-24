import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/fitness_club_controller.dart';
import 'invite_people_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/top_tool_bar.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

typedef CreateClubScreen = CreateGroupScreen;

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _clubNameController = TextEditingController();
  final TextEditingController _clubDescriptionController = TextEditingController();
  String _privacy = 'PUBLIC';
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
    final l10n = AppLocalizations.of(context);
    if (name.isEmpty) {
      Get.snackbar(
        l10n?.requiredField ?? 'Required',
        l10n?.pleaseEnterClubName ?? 'Please enter a club name',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final selectedPrivacy = _privacy == 'PRIVATE' ? 'PRIVATE' : 'PUBLIC';
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    AppLocalizations.of(context)?.selectPrivacy ?? 'Select Privacy',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                ListTile(
                  leading: Icon(Icons.public, color: Colors.blueAccent),
                  title: Text(
                    AppLocalizations.of(context)?.publicLabel ?? 'Public',
                    style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(AppLocalizations.of(context)?.anyoneCanJoin ?? 'Anyone can find and join this club', style: TextStyle(color: AppColors.textCaption, fontSize: 12)),
                  trailing: _privacy == 'PUBLIC' ? Icon(Icons.check_circle, color: Colors.blueAccent) : null,
                  onTap: () {
                    setState(() => _privacy = 'PUBLIC');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.lock_outline, color: Colors.amber),
                  title: Text(
                    AppLocalizations.of(context)?.privateLabel ?? 'Private',
                    style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(AppLocalizations.of(context)?.requiresInvite ?? 'Requires invitation or request to join', style: TextStyle(color: AppColors.textCaption, fontSize: 12)),
                  trailing: _privacy == 'PRIVATE' ? Icon(Icons.check_circle, color: Colors.blueAccent) : null,
                  onTap: () {
                    setState(() => _privacy = 'PRIVATE');
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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            TopToolBar(title: l10n?.createClub ?? 'Create Club'),
            Expanded(
              child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n?.clubNameLabel ?? 'CLUB NAME',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 8),

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
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    border: InputBorder.none,
                    hintText: l10n?.clubNameHint ?? 'Enter club name',
                    hintStyle: TextStyle(color: AppColors.textCaption, fontSize: 14),
                  ),
                ),
              ),
              SizedBox(height: 20),

              Text(
                l10n?.clubDescriptionLabel ?? 'CLUB DESCRIPTION',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 8),

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
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    border: InputBorder.none,
                    counterStyle: TextStyle(color: AppColors.textCaption, fontSize: 11),
                    hintText: 'Describe your club and who should join...',
                    hintStyle: TextStyle(color: AppColors.textCaption, fontSize: 14),
                  ),
                ),
              ),
              SizedBox(height: 20),

              Text(
                l10n?.privacy ?? 'PRIVACY',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 8),

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
                        _privacy == 'PRIVATE'
                            ? (l10n?.privateLabel ?? 'Private')
                            : (l10n?.publicLabel ?? 'Public'),
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textSecondary,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MEMBERS ( ${_selectedMemberIds.length} )',
                    style: TextStyle(
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
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_add_outlined,
                            color: AppColors.textPrimary,
                            size: 15,
                          ),
                          SizedBox(width: 6),
                          Text(
                            AppLocalizations.of(context)?.invite ?? 'Invite',
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
              SizedBox(height: 28),

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
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n?.createClub ?? 'Create Club',
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
          ],
        ),
      ),
    );
  }
}
