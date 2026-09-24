import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/no_data_component.dart';
import '../../../../shared/widgets/top_tool_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/fitness_club_model.dart';
import '../controllers/fitness_club_controller.dart';

class ClubInvitationsScreen extends StatefulWidget {
  const ClubInvitationsScreen({super.key});

  @override
  State<ClubInvitationsScreen> createState() => _ClubInvitationsScreenState();
}

class _ClubInvitationsScreenState extends State<ClubInvitationsScreen> {
  late final FitnessClubController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<FitnessClubController>()
        ? Get.find<FitnessClubController>()
        : Get.put(FitnessClubController());
    _controller.loadInbox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            TopToolBar(title: AppLocalizations.of(context)?.clubInvitationsTitle ?? 'Club Invitations'),
            Expanded(
              child: Obx(() {
                if (_controller.isLoadingInbox.value &&
                    _controller.inboxInvitations.isEmpty &&
                    _controller.inboxJoinRequests.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.accentBlue),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.accentBlue,
                  backgroundColor: AppColors.chipSurface,
                  onRefresh: () => _controller.loadInbox(),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                    children: [
                      _sectionLabel(AppLocalizations.of(context)?.invitationsLabel ?? 'INVITATIONS'),
                      const SizedBox(height: 10),
                      if (_controller.inboxInvitations.isEmpty)
                        NoDataComponent(
                          compact: true,
                          title: AppLocalizations.of(context)?.noClubInvitations ?? 'No club invitations',
                          subtitle: AppLocalizations.of(context)?.noClubInvitationsSub ??
                              'Incoming club invitations will show up here.',
                        )
                      else
                        ..._controller.inboxInvitations.map(
                          (r) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _row(
                              request: r,
                              message:
                                  AppLocalizations.of(context)?.youRequestedJoin(r.clubName ?? AppLocalizations.of(context)?.aClub ?? 'a club') ??
                                  'You requested to join ${r.clubName ?? 'a club'}',
                              onReject: () => _controller.cancelMyJoinRequest(r),
                            ),
                          ),
                        ),
                      const SizedBox(height: 22),
                      _sectionLabel(AppLocalizations.of(context)?.requestsLabel ?? 'REQUESTS'),
                      const SizedBox(height: 10),
                      if (_controller.inboxJoinRequests.isEmpty)
                        NoDataComponent(
                          compact: true,
                          title: AppLocalizations.of(context)?.noJoinRequests ?? 'No join requests',
                          subtitle: AppLocalizations.of(context)?.noJoinRequestsSub ??
                              'When people ask to join your clubs, they appear here.',
                        )
                      else
                        ..._controller.inboxJoinRequests.map(
                          (r) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _row(
                              request: r,
                              message:
                                  '${r.requesterName ?? 'Someone'} has requested to join ${r.clubName ?? 'your club'}',
                              onReject: () => _controller.rejectJoinRequest(r),
                              onAccept: () => _controller.approveJoinRequest(r),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 13,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.7,
      ),
    );
  }

  Widget _row({
    required ClubJoinRequestModel request,
    required String message,
    required Future<bool> Function() onReject,
    Future<bool> Function()? onAccept,
  }) {
    final initial = (request.requesterName ?? request.clubName ?? 'C').trim();
    final letter = initial.isNotEmpty ? initial[0].toUpperCase() : 'C';
    final acting = _controller.actingRequestId.value == request.id;

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 8, 10),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          ClipPath(
            clipper: _MiniHexagonClipper(),
            child: Container(
              width: 36,
              height: 40,
              color: AppColors.chipSurface,
              alignment: Alignment.center,
              child: Text(
                letter,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12.5,
                height: 1.3,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (acting)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else ...[
            _circleAction(
              icon: Icons.close,
              color: AppColors.textSecondary,
              onTap: onReject,
            ),
            if (onAccept != null)
              _circleAction(
                icon: Icons.check,
                color: AppColors.textPrimary,
                onTap: onAccept,
              ),
          ],
        ],
      ),
    );
  }

  Widget _circleAction({
    required IconData icon,
    required Color color,
    required Future<bool> Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        margin: const EdgeInsets.only(left: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.borderMuted),
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}

class _MiniHexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    path.moveTo(w * 0.5, 0);
    path.lineTo(w, h * 0.25);
    path.lineTo(w, h * 0.75);
    path.lineTo(w * 0.5, h);
    path.lineTo(0, h * 0.75);
    path.lineTo(0, h * 0.25);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
