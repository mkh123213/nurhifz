import 'package:flutter_bloc/flutter_bloc.dart';
import 'base_state.dart';

abstract class BaseCubit<T> extends Cubit<BaseState<T>> {
  BaseCubit() : super(const BaseState());

  Future<T> fetchData();

  Future<void> load() async {
    emit(state.toLoading());
    try {
      final data = await fetchData();
      emit(state.toSuccess(data));
    } catch (e) {
      emit(state.toError(e.toString()));
    }
  }

  Future<void> refresh() async {
    try {
      final data = await fetchData();
      emit(state.toSuccess(data));
    } catch (e) {
      emit(state.toError(e.toString()));
    }
  }

  void clearError() => emit(state.copyWith(clearError: true));
}
