import 'api_exceptions.dart';

sealed class ApiResult<T> {
  const ApiResult();
}

class ApiLoading<T> extends ApiResult<T> {
  const ApiLoading();
}

class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  const ApiSuccess(this.data);
}

class ApiError<T> extends ApiResult<T> {
  final ApiException exception;
  const ApiError(this.exception);
}
