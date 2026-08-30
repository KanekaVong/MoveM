import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/storage/user_manager.dart';
import '../../../../shared/base/base_controller.dart';
import '../../../auth/data/dto/response/user_response.dart';
import '../../data/dto/response/comment_response.dart';
import '../../data/dto/response/page_comment_response.dart';
import '../../data/repositories/comment_repository_impl.dart';
import '../../data/services/comment_service.dart';
import '../../domain/repositories/comment_repository.dart';

class CommentController extends BaseController {
  final String activityId;
  final CommentRepository repository;

  CommentController({
    required this.activityId,
    CommentRepository? repository,
  }) : repository = repository ?? CommentRepositoryImpl(CommentService());

  final RxList<CommentResponse> comments = <CommentResponse>[].obs;
  final RxBool isSending = false.obs;
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode inputFocusNode = FocusNode();
  final Rx<UserResponse?> currentUser = Rx<UserResponse?>(null);
  final Rx<CommentResponse?> editingComment = Rx<CommentResponse?>(null);

  bool get isEditing => editingComment.value != null;

  int _currentPage = 0;
  bool _hasMore = true;

  @override
  void onInit() {
    super.onInit();
    currentUser.value = UserManager().getUser();
    fetchComments();
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    inputFocusNode.dispose();
    super.onClose();
  }

  bool isOwnComment(CommentResponse comment) {
    final user = currentUser.value;
    if (user == null) return false;
    if (user.id.isNotEmpty && user.id == comment.userId.toString()) {
      return true;
    }
    if (user.username.isNotEmpty &&
        user.username.toLowerCase() == comment.username.toLowerCase()) {
      return true;
    }
    return false;
  }

  void startEditing(CommentResponse comment) {
    editingComment.value = comment;
    textController.text = comment.content;
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: textController.text.length),
    );
    inputFocusNode.requestFocus();
  }

  void cancelEditing() {
    editingComment.value = null;
    textController.clear();
    inputFocusNode.unfocus();
  }

  Future<void> submitComment() async {
    if (isEditing) {
      await _saveEditedComment();
    } else {
      await sendComment();
    }
  }

  Future<void> fetchComments({bool showLoading = true}) async {
    _currentPage = 0;
    if (showLoading) {
      state.value = ViewState.loading;
    }

    final result = await repository.getComments(activityId, page: 0, size: 50);

    if (result is ApiSuccess<PageCommentResponse>) {
      final pageData = result.data;
      // Sort oldest to newest (top to bottom like Telegram chat)
      final items = List<CommentResponse>.from(pageData.content);
      items.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      comments.assignAll(items);
      _hasMore = !pageData.last;
      state.value = ViewState.success;
      _scrollToBottom();
    } else if (result is ApiError<PageCommentResponse>) {
      state.value = ViewState.error;
      errorMessage.value = result.exception.message;
      Get.snackbar(
        'Error',
        result.exception.message,
        backgroundColor: Colors.red.withOpacity(0.85),
        colorText: Colors.white,
      );
    }
  }

  Future<void> sendComment() async {
    final text = textController.text.trim();
    if (text.isEmpty || isSending.value) return;

    isSending.value = true;
    textController.clear();

    final result = await repository.createComment(activityId, text);

    isSending.value = false;

    if (result is ApiSuccess<CommentResponse>) {
      comments.add(result.data);
      _scrollToBottom();
    } else if (result is ApiError<CommentResponse>) {
      textController.text = text; // Restore input on failure
      Get.snackbar(
        'Failed to Send',
        result.exception.message,
        backgroundColor: Colors.red.withOpacity(0.85),
        colorText: Colors.white,
      );
    }
  }

  Future<void> _saveEditedComment() async {
    final target = editingComment.value;
    if (target == null) return;

    final text = textController.text.trim();
    if (text.isEmpty || isSending.value) return;

    if (text == target.content) {
      cancelEditing();
      return;
    }

    isSending.value = true;
    final result = await repository.updateComment(target.id, text);
    isSending.value = false;

    if (result is ApiSuccess<CommentResponse>) {
      final index = comments.indexWhere((c) => c.id == target.id);
      if (index != -1) {
        comments[index] = result.data;
      }
      cancelEditing();
      Get.snackbar(
        'Updated',
        'Comment updated successfully',
        backgroundColor: Colors.green.withOpacity(0.85),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } else if (result is ApiError<CommentResponse>) {
      Get.snackbar(
        'Update Failed',
        result.exception.message,
        backgroundColor: Colors.red.withOpacity(0.85),
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteComment(int commentId) async {
    if (editingComment.value?.id == commentId) {
      cancelEditing();
    }

    final result = await repository.deleteComment(commentId);
    if (result is ApiSuccess<void>) {
      comments.removeWhere((c) => c.id == commentId);
      Get.snackbar(
        'Deleted',
        'Comment deleted successfully',
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } else if (result is ApiError<void>) {
      Get.snackbar(
        'Error',
        result.exception.message,
        backgroundColor: Colors.red.withOpacity(0.85),
        colorText: Colors.white,
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuad,
        );
      }
    });
  }

  bool shouldShowDateHeader(int index) {
    if (index == 0) return true;
    try {
      final prevDate = DateTime.parse(comments[index - 1].createdAt).toLocal();
      final currDate = DateTime.parse(comments[index].createdAt).toLocal();
      return prevDate.year != currDate.year ||
          prevDate.month != currDate.month ||
          prevDate.day != currDate.day;
    } catch (_) {
      return false;
    }
  }

  String formatDateHeader(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      final now = DateTime.now();
      if (date.year == now.year && date.month == now.month && date.day == now.day) {
        return 'Today';
      }
      final yesterday = now.subtract(const Duration(days: 1));
      if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
        return 'Yesterday';
      }
      return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
    } catch (_) {
      return dateStr;
    }
  }

  String formatTime(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      final hour = date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
      final minute = date.minute.toString().padLeft(2, '0');
      final period = date.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    } catch (_) {
      return dateStr;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return '';
  }
}
