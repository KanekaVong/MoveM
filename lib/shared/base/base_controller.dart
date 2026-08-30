import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../core/network/api_exceptions.dart';
import '../../core/network/api_result.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/app_dialogs.dart';
import 'dart:async';

enum ViewState { idle, loading, success, error }

abstract class BaseController extends GetxController {

  final Rx<ViewState> state = ViewState.idle.obs;
  final RxString errorMessage = ''.obs;
  final RxInt errorStatusCode = 0.obs;

  bool get isLoading => state.value == ViewState.loading;
  bool get hasError => state.value == ViewState.error;

  final _logger = Logger();

  Future<void> executeApi<T>({
    required Future<ApiResult<T>> Function() apiCall,
    required FutureOr<void> Function(T data) onSuccess,
    void Function(ApiException exception)? onError,
    void Function()? onLoading,
    bool showLoading = true,
    bool showErrorDialog = true,
  }) async {
    onLoading?.call();
    state.value = ViewState.loading;

    if (showLoading) {
      AppDialogs.showLoading();
    }

    try {
      final result = await apiCall();

      if (showLoading) {
        AppDialogs.hideLoading();
      }

      switch (result) {
        case ApiSuccess(data: final data):
          state.value = ViewState.success;
          await onSuccess(data);
        case ApiError(exception: final e):
          _handleApiException(e, showErrorDialog: showErrorDialog);
          onError?.call(e);
        case ApiLoading():
          break;
      }
    } catch (e, stack) {
      if (showLoading) {
        AppDialogs.hideLoading();
      }
      state.value = ViewState.error;
      _logger.e('Unexpected API execution error', error: e, stackTrace: stack);
      if (showErrorDialog) {
        AppDialogs.showError('An unexpected error occurred.');
      }
    }
  }

  void _handleApiException(
    ApiException exception, {
    bool showErrorDialog = true,
  }) {
    _logger.e('API error [${exception.statusCode}]: ${exception.message}');
    errorMessage.value = exception.message;
    errorStatusCode.value = exception.statusCode ?? 0;
    state.value = ViewState.error;

    if (exception.statusCode == 401) {
      _handleUnauthorized(exception.message);
      return;
    }

    if (showErrorDialog) {
      AppDialogs.showError(exception.message);
    }
  }

  static bool _isUnauthorizedHandling = false;

  void _handleUnauthorized(String message) {
    if (_isUnauthorizedHandling) return;
    _isUnauthorizedHandling = true;

    AppDialogs.showError(message, onConfirm: () {
      _isUnauthorizedHandling = false;
      if (Get.currentRoute != AppRoutes.login) {
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }
}
