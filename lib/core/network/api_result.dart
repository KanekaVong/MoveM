import 'api_exceptions.dart';

sealed class ApiResult<T> {
  const ApiResult();

  bool get isSuccess => this is ApiSuccess<T>;
  bool get isError => this is ApiError<T>;
  bool get isLoading => this is ApiLoading<T>;

  T? get data => this is ApiSuccess<T> ? (this as ApiSuccess<T>).data : null;
  ApiException? get exception => this is ApiError<T> ? (this as ApiError<T>).exception : null;
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
