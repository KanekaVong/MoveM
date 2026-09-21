import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network/api_result.dart';
import '../../../../shared/base/base_controller.dart';
import '../../data/dto/response/activity_feed_item_response.dart';
import '../../data/dto/response/page_activity_feed_response.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../data/services/task_service.dart';
import '../../domain/repositories/task_repository.dart';

class TaskActivityFeedController extends BaseController {
  final String activityId;
  final TaskRepository repository;

  TaskActivityFeedController({
    required this.activityId,
    TaskRepository? repository,
  }) : repository = repository ?? TaskRepositoryImpl(TaskService());

  final items = <ActivityFeedItemResponse>[].obs;
  final isRefreshing = false.obs;
  final isLoadingMore = false.obs;

  final ScrollController scrollController = ScrollController();

  int _page = 0;
  static const int _pageSize = 20;
  bool _lastPage = true;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    fetchFeed();
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (!scrollController.hasClients || _lastPage || isLoadingMore.value || isLoading) {
      return;
    }
    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 120) {
      fetchFeed(loadMore: true);
    }
  }

  Future<void> fetchFeed({bool loadMore = false}) async {
    if (loadMore) {
      if (_lastPage || isLoadingMore.value) return;
      isLoadingMore.value = true;
    } else {
      _page = 0;
      state.value = ViewState.loading;
    }

    final result = await repository.getActivityFeed(
      activityId,
      page: loadMore ? _page + 1 : 0,
      size: _pageSize,
    );

    if (result is ApiSuccess<PageActivityFeedResponse>) {
      final page = result.data;
      _page = page.number;
      _lastPage = page.last || page.content.isEmpty;
      if (loadMore) {
        items.addAll(page.content);
      } else {
        items.assignAll(page.content);
      }
      state.value = ViewState.success;
      errorMessage.value = '';
    } else {
      errorMessage.value = result.exception?.message ?? 'Failed to load history';
      if (!loadMore && items.isEmpty) {
        state.value = ViewState.error;
      } else {
        state.value = ViewState.success;
      }
    }

    isLoadingMore.value = false;
    isRefreshing.value = false;
  }

  Future<void> refreshFeed() async {
    isRefreshing.value = true;
    await fetchFeed();
  }
}
