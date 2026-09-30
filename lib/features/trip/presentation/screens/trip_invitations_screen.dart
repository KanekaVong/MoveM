import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/trip_invitation_controller.dart';
import '../../../groups/data/dto/response/group_invite_response.dart';

class TripInvitationsScreen extends StatefulWidget {
  const TripInvitationsScreen({super.key});

  @override
  State<TripInvitationsScreen> createState() =>
      _TripInvitationsScreenState();
}

class _TripInvitationsScreenState
    extends State<TripInvitationsScreen> {
  late final TripInvitationController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.find<TripInvitationController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadInvitations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF0B101D)
        : AppColors.lightBackground;

    final textColor = isDark
        ? AppColors.darkOnSurface
        : AppColors.lightOnSurface;

    final secondaryTextColor = isDark
        ? AppColors.slate400
        : AppColors.slate500;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: textColor,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          l10n?.tripInvitations ?? 'Trip Invitations',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: isDark
                  ? Colors.white
                  : AppColors.commentBarBg,
            ),
          );
        }

        if (controller.invitations.isEmpty) {
          return _buildEmptyState(
            l10n,
            secondaryTextColor,
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadInvitations,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.invitations.length,
            separatorBuilder: (_, __) =>
            const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final invitation =
              controller.invitations[index];

              return _buildInvitationCard(
                context,
                invitation,
                l10n,
                isDark,
                textColor,
                secondaryTextColor,
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState(
      AppLocalizations? l10n,
      Color secondaryTextColor,
      ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mail_outline_rounded,
              size: 56,
              color: secondaryTextColor,
            ),
            const SizedBox(height: 16),
            Text(
              l10n?.noTripInvitations ??
                  'No trip invitations',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvitationCard(
      BuildContext context,
      GroupInviteResponse invitation,
      AppLocalizations? l10n,
      bool isDark,
      Color textColor,
      Color secondaryTextColor,
      ) {
    final activityName =
    invitation.activityName?.trim().isNotEmpty == true
        ? invitation.activityName!
        : 'Trip';

    final inviter =
    invitation.inviterUsername?.trim().isNotEmpty == true
        ? '@${invitation.inviterUsername}'
        : 'Someone';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.slate800
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? AppColors.slate700
              : AppColors.slate300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: isDark
                    ? AppColors.slate700
                    : AppColors.slate100,
                child: Icon(
                  Icons.person_rounded,
                  color: isDark
                      ? AppColors.slate300
                      : AppColors.slate600,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      inviter,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n?.invitedYouToTrip ??
                          'invited you to a trip',
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.slate900
                  : AppColors.slate100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.luggage_rounded,
                  size: 22,
                  color: isDark
                      ? AppColors.slate300
                      : AppColors.slate600,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    activityName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.isResponding.value
                      ? null
                      : () => _rejectInvitation(
                    invitation,
                    l10n,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: secondaryTextColor,
                    side: BorderSide(
                      color: isDark
                          ? AppColors.slate600
                          : AppColors.slate300,
                    ),
                    minimumSize:
                    const Size.fromHeight(46),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n?.reject ?? 'Reject',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.isResponding.value
                      ? null
                      : () => _acceptInvitation(
                    invitation,
                    l10n,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? Colors.white
                        : AppColors.commentBarBg,
                    foregroundColor: isDark
                        ? Colors.black
                        : Colors.white,
                    minimumSize:
                    const Size.fromHeight(46),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n?.accept ?? 'Accept',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _acceptInvitation(
      GroupInviteResponse invitation,
      AppLocalizations? l10n,
      ) async {
    final inviteId = invitation.inviteId;

    if (inviteId == null) return;

    final success =
    await controller.acceptInvitation(inviteId);

    if (!mounted) return;

    if (success) {
      Get.snackbar(
        l10n?.invitationAccepted ?? 'Invitation accepted',
        l10n?.tripAddedToYourTrips ??
            'The trip has been added to your trips.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _rejectInvitation(
      GroupInviteResponse invitation,
      AppLocalizations? l10n,
      ) async {
    final inviteId = invitation.inviteId;

    if (inviteId == null) return;

    final success =
    await controller.rejectInvitation(inviteId);

    if (!mounted) return;

    if (success) {
      Get.snackbar(
        l10n?.invitationRejected ?? 'Invitation rejected',
        '',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}