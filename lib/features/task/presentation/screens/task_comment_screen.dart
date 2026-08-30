import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/comment_controller.dart';
import '../../data/dto/response/comment_response.dart';

class TaskCommentScreen extends StatelessWidget {
  final String activityId;
  final String taskTitle;

  const TaskCommentScreen({
    super.key,
    required this.activityId,
    required this.taskTitle,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommentController(activityId: activityId));
    final l10n = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: AppColors.taskDarkBackground,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                AppImages.taskDetailBackground,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.4),
                      AppColors.taskDarkBackground.withOpacity(0.75),
                      AppColors.taskDarkBackground.withOpacity(0.95),
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildTopBar(context, controller),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading && controller.comments.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(color: AppColors.taskBluePrimary),
                        );
                      }

                      if (controller.comments.isEmpty) {
                        return _buildEmptyState(controller, l10n);
                      }

                      return RefreshIndicator(
                        onRefresh: () => controller.fetchComments(showLoading: false),
                        color: AppColors.taskBluePrimary,
                        child: ListView.builder(
                          controller: controller.scrollController,
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          itemCount: controller.comments.length,
                          itemBuilder: (context, index) {
                            final comment = controller.comments[index];
                            final isOwn = controller.isOwnComment(comment);
                            final showDateHeader = controller.shouldShowDateHeader(index);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (showDateHeader) _buildDateHeader(comment.createdAt, controller, l10n),
                                const SizedBox(height: 6),
                                _buildCommentBubble(context, comment, isOwn, controller, l10n),
                                const SizedBox(height: 6),
                              ],
                            );
                          },
                        ),
                      );
                    }),
                  ),
                  _buildBottomInputBar(controller, l10n),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, CommentController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: AppColors.taskDarkBackground.withOpacity(0.5),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.08), width: 0.8),
        ),
      ),
      child: Row(
        children: [
          _buildCircleButton(
            icon: Icons.chevron_left,
            iconSize: 24,
            onTap: () => Get.back(),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              taskTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    double iconSize = 18,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0x33000000),
          border: Border.all(color: Colors.white.withOpacity(0.24), width: 1),
        ),
        child: Center(
          child: Icon(icon, color: Colors.white, size: iconSize),
        ),
      ),
    );
  }

  Widget _buildEmptyState(CommentController controller, AppLocalizations? l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.taskBluePrimary.withOpacity(0.15),
                border: Border.all(color: AppColors.taskBluePrimary.withOpacity(0.3)),
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: AppColors.taskBluePrimary,
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n?.noCommentsYet ?? 'No Comments Yet',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n?.beTheFirstToComment ??
                  'Be the first to leave a comment or ask a question about this task.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.taskTextMuted,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader(String createdAt, CommentController controller, AppLocalizations? l10n) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.5),
        ),
        child: Text(
          controller.formatDateHeader(createdAt),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCommentBubble(
    BuildContext context,
    CommentResponse comment,
    bool isOwn,
    CommentController controller,
    AppLocalizations? l10n,
  ) {
    if (isOwn) {
      // Telegram-style Own Comment (Right Side)
      return Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onLongPress: () => _showCommentOptions(context, comment, isOwn, controller, l10n),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.76,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.commentBlueStart,
                  AppColors.commentBlueEnd,
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.commentBlueStart.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    comment.content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (comment.edited) ...[
                          Text(
                            '${l10n?.edited ?? 'edited'} ',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                        Text(
                          controller.formatTime(comment.createdAt),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.done_all,
                          size: 14,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      // Telegram-style Other's Comment (Left Side with Avatar)
      return Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onLongPress: () => _showCommentOptions(context, comment, isOwn, controller, l10n),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAvatar(comment),
              const SizedBox(width: 8),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.70,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: AppColors.slate800.withValues(alpha: 0.85),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                    width: 0.8,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                    bottomLeft: Radius.circular(4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        comment.displayName,
                        style: const TextStyle(
                          color: AppColors.skyBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        comment.content,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (comment.edited) ...[
                              Text(
                                '${l10n?.edited ?? 'edited'} ',
                                style: const TextStyle(
                                  color: AppColors.taskTextMuted,
                                  fontSize: 10,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                            Text(
                              controller.formatTime(comment.createdAt),
                              style: const TextStyle(
                                color: AppColors.taskTextMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
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

  Widget _buildAvatar(CommentResponse comment) {
    final initial = comment.displayName.isNotEmpty
        ? comment.displayName[0].toUpperCase()
        : 'U';
    final profilePic = comment.profilePic;

    if (profilePic != null && profilePic.isNotEmpty) {
      final fullUrl = profilePic.startsWith('http')
          ? profilePic
          : '${AppConfig.baseUrl}/uploads/$profilePic';
      return CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage(fullUrl),
        backgroundColor: AppColors.slate700,
      );
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.skyBlue, AppColors.skyBlueDark],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBottomInputBar(CommentController controller, AppLocalizations? l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: AppColors.slate900.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 0.8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            final editing = controller.editingComment.value;
            if (editing == null) return const SizedBox.shrink();
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              margin: const EdgeInsets.only(bottom: 8.0),
              decoration: BoxDecoration(
                color: AppColors.slate800,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.taskBluePrimary.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 3,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.taskBluePrimary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.edit_outlined, size: 16, color: AppColors.taskBluePrimary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n?.editingComment ?? 'Editing Comment',
                          style: const TextStyle(
                            color: AppColors.taskBluePrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          editing.content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.cancelEditing(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                      ),
                      child: const Icon(Icons.close, size: 16, color: Colors.white70),
                    ),
                  ),
                ],
              ),
            );
          }),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  decoration: BoxDecoration(
                    color: AppColors.slate800,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                      width: 1,
                    ),
                  ),
                  child: Obx(() => TextField(
                    controller: controller.textController,
                    focusNode: controller.inputFocusNode,
                    minLines: 1,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: controller.isEditing
                          ? (l10n?.editYourComment ?? 'Edit your comment...')
                          : (l10n?.writeComment ?? 'Write a comment...'),
                      hintStyle: const TextStyle(
                        color: AppColors.taskTextMuted,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                    ),
                  )),
                ),
              ),
              const SizedBox(width: 10),
              Obx(() {
                final isEditing = controller.isEditing;
                return GestureDetector(
                  onTap: controller.isSending.value ? null : () => controller.submitComment(),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isEditing
                            ? [AppColors.commentGreenStart, AppColors.commentGreenEnd]
                            : [AppColors.commentBlueStart, AppColors.commentBlueEnd],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isEditing ? AppColors.commentGreenStart : AppColors.commentBlueStart).withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: controller.isSending.value
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(
                              isEditing ? Icons.check_rounded : Icons.send_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  void _showCommentOptions(
    BuildContext context,
    CommentResponse comment,
    bool isOwn,
    CommentController controller,
    AppLocalizations? l10n,
  ) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.slate800,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.12), width: 1),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 54, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isOwn) ...[
                _buildDialogOption(
                  icon: Icons.edit_outlined,
                  iconColor: AppColors.skyBlue,
                  title: l10n?.edit ?? 'Edit',
                  onTap: () {
                    Get.back();
                    controller.startEditing(comment);
                  },
                ),
                Divider(color: Colors.white.withOpacity(0.08), height: 1),
              ],
              _buildDialogOption(
                icon: Icons.copy_rounded,
                iconColor: Colors.white70,
                title: l10n?.copyText ?? 'Copy Text',
                onTap: () {
                  Clipboard.setData(ClipboardData(text: comment.content));
                  Get.back();
                  Get.snackbar(
                    l10n?.copied ?? 'Copied',
                    l10n?.commentCopiedToast ?? 'Comment copied to clipboard',
                    backgroundColor: Colors.black87,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 2),
                  );
                },
              ),
              if (isOwn) ...[
                Divider(color: Colors.white.withOpacity(0.08), height: 1),
                _buildDialogOption(
                  icon: Icons.delete_outline,
                  iconColor: Colors.redAccent,
                  title: l10n?.delete ?? 'Delete',
                  textColor: Colors.redAccent,
                  onTap: () {
                    Get.back();
                    _confirmDeleteComment(context, comment.id, controller, l10n);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogOption({
    required IconData icon,
    required Color iconColor,
    required String title,
    Color textColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 14),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteComment(
    BuildContext context,
    int commentId,
    CommentController controller,
    AppLocalizations? l10n,
  ) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.slate800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n?.deleteComment ?? 'Delete Comment', style: const TextStyle(color: Colors.white)),
        content: Text(
          l10n?.deleteCommentConfirm ?? 'Are you sure you want to delete this comment? This action cannot be undone.',
          style: const TextStyle(color: AppColors.taskTextMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(l10n?.cancel ?? 'Cancel', style: const TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteComment(commentId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(l10n?.delete ?? 'Delete', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
