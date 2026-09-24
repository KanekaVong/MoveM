import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../groups/data/dto/response/group_invite_response.dart';
import '../controllers/task_invitation_controller.dart';
import '../../../../shared/widgets/no_data_component.dart';
import '../../../../shared/widgets/top_tool_bar.dart';
import '../../../../l10n/app_localizations.dart';

class TaskInvitationScreen extends StatelessWidget {
  const TaskInvitationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TaskInvitationController());

    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopToolBar(title: l10n?.invitation ?? 'Invitation'),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                children: [
                  Text(
                    l10n?.invitationsLabel ?? 'INVITATIONS',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.mail_outline, color: AppColors.textPrimary, size: 16),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.invitations.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.taskBluePrimary),
                  );
                }
                if (controller.errorMessage.value.isNotEmpty && controller.invitations.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          SizedBox(height: 12),
                          TextButton(
                            onPressed: controller.fetchInvitations,
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (controller.invitations.isEmpty) {
                  return NoDataComponent(
                    title: l10n?.noInvitations ?? 'No invitations',
                    subtitle: l10n?.noInvitationsSub ??
                        'Task invitations you receive will appear here.',
                  );
                }
                return RefreshIndicator(
                  color: AppColors.taskBluePrimary,
                  onRefresh: controller.fetchInvitations,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: controller.invitations.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _InvitationCard(
                        invite: controller.invitations[index],
                        isActing: controller.actingInviteId.value == controller.invitations[index].inviteId,
                        onAccept: () => controller.accept(controller.invitations[index]),
                        onReject: () => controller.reject(controller.invitations[index]),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _InvitationCard extends StatelessWidget {
  final GroupInviteResponse invite;
  final bool isActing;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _InvitationCard({
    required this.invite,
    required this.isActing,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final name = invite.inviterUsername?.trim().isNotEmpty == true
        ? invite.inviterUsername!.trim()
        : 'Someone';
    final taskName = invite.activityName?.trim().isNotEmpty == true
        ? invite.activityName!.trim()
        : 'a task';
    final avatarUrl =
        'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=334155&color=fff';

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 46,
              height: 46,
              child: CachedNetworkImage(
                imageUrl: avatarUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => _avatarFallback(name),
                errorWidget: (_, __, ___) => _avatarFallback(name),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: name,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  TextSpan(
                    text: ' has invited you collaborate in ',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  TextSpan(
                    text: taskName,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isActing)
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.taskBluePrimary),
            )
          else ...[
            _circleAction(
              icon: Icons.close,
              onTap: onReject,
            ),
            SizedBox(width: 8),
            _circleAction(
              icon: Icons.check,
              onTap: onAccept,
              filled: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _avatarFallback(String name) {
    return Container(
      color: AppColors.chipSurface,
      alignment: Alignment.center,
      child: Text(
        name[0].toUpperCase(),
        style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _circleAction({
    required IconData icon,
    required VoidCallback onTap,
    bool filled = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? AppColors.accentBlue : Colors.transparent,
          border: Border.all(
            color: filled ? AppColors.accentBlue : AppColors.borderMuted,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: filled ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );
  }
}
