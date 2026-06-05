import 'package:equatable/equatable.dart';

class BaseState<T> extends Equatable {
  final T? data;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;

  const BaseState({
    this.data,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
  });

  bool get hasData => data != null;
  bool get hasError => error != null;
  bool get isInitial => !isLoading && !hasData && !hasError;

  BaseState<T> copyWith({
    T? data,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool clearError = false,
    bool clearData = false,
  }) {
    return BaseState<T>(
      data: clearData ? null : (data ?? this.data),
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : (error ?? this.error),
    );
  }

  BaseState<T> toLoading() => copyWith(isLoading: true, clearError: true);
  BaseState<T> toLoadingMore() => copyWith(isLoadingMore: true);
  BaseState<T> toSuccess(T data) => BaseState<T>(data: data);
  BaseState<T> toError(String error) => BaseState<T>(data: data, error: error);

  @override
  List<Object?> get props => [data, isLoading, isLoadingMore, error];
}
