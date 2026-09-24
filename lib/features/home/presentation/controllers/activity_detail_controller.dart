import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network/api_result.dart';
import '../../../../shared/base/base_controller.dart';
import '../../../fitness/data/repositories/fitness_workout_repository.dart';
import '../../../task/data/dto/response/comment_response.dart';
import '../../../task/data/dto/response/page_comment_response.dart';
import '../../../task/data/repositories/comment_repository_impl.dart';
import '../../../task/data/services/comment_service.dart';
import '../../../task/domain/repositories/comment_repository.dart';
import '../../domain/models/home_feed_item.dart';
import 'home_controller.dart';
import '../../../../l10n/app_localizations.dart';

class ActivityDetailController extends BaseController {
  AppLocalizations? get _l10n {
    final ctx = Get.context;
    return ctx == null ? null : AppLocalizations.of(ctx);
  }

  final HomeFeedItem initialItem;
  final FitnessWorkoutRepository workoutRepository;
  final CommentRepository commentRepository;

  ActivityDetailController({
    required this.initialItem,
    FitnessWorkoutRepository? workoutRepository,
    CommentRepository? commentRepository,
  })  : workoutRepository = workoutRepository ?? FitnessWorkoutRepository(),
        commentRepository = commentRepository ?? CommentRepositoryImpl(CommentService());

  late final Rx<HomeFeedItem> item = initialItem.obs;
  final RxList<CommentResponse> comments = <CommentResponse>[].obs;
  final RxBool isSending = false.obs;
  final TextEditingController textController = TextEditingController();
  final FocusNode inputFocusNode = FocusNode();

  String get commentsActivityId => 'workouts/${item.value.sessionId}';

  @override
  void onInit() {
    super.onInit();
    loadComments();
  }

  @override
  void onClose() {
    textController.dispose();
    inputFocusNode.dispose();
    super.onClose();
  }

  Future<void> loadComments() async {
    if (item.value.sessionId == null) return;
    final result = await commentRepository.getComments(commentsActivityId, page: 0, size: 50);
    if (result is ApiSuccess<PageCommentResponse>) {
      comments.assignAll(result.data.content);
      _syncCommentCount();
    }
  }

  Future<void> toggleKudos() async {
    final current = item.value;
    if (current.sessionId == null) return;

    final willLike = !current.myKudos;
    final updatedCount = willLike
        ? current.kudosCount + 1
        : (current.kudosCount > 0 ? current.kudosCount - 1 : 0);
    item.value = current.copyWith(myKudos: willLike, kudosCount: updatedCount);
    _syncHomeFeed(item.value);

    final res = willLike
        ? await workoutRepository.giveKudos(current.sessionId!)
        : await workoutRepository.removeKudos(current.sessionId!);
    if (res is! ApiSuccess<bool>) {
      item.value = current;
      _syncHomeFeed(current);
    }
  }

  Future<void> sendComment() async {
    final text = textController.text.trim();
    if (text.isEmpty || isSending.value || item.value.sessionId == null) return;

    isSending.value = true;
    textController.clear();
    final result = await commentRepository.createComment(commentsActivityId, text);
    isSending.value = false;

    if (result is ApiSuccess<CommentResponse>) {
      comments.add(result.data);
      _syncCommentCount();
    } else {
      textController.text = text;
      Get.snackbar(_l10n?.errorTitle ?? 'Failed to Send', _l10n?.failedToSendComment ?? 'Unable to post comment right now');
    }
  }

  void _syncCommentCount() {
    item.value = item.value.copyWith(commentCount: comments.length);
    _syncHomeFeed(item.value);
  }

  void _syncHomeFeed(HomeFeedItem updated) {
    if (!Get.isRegistered<HomeController>()) return;
    final home = Get.find<HomeController>();
    final index = home.feedItems.indexWhere((feed) => feed.id == updated.id);
    if (index != -1) {
      home.feedItems[index] = updated;
    }
  }
}
