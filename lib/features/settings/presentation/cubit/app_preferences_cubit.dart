import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/settings_repo.dart';

class AppPreferencesState extends Equatable {
  final bool isDarkMode;
  final bool notifications;
  final String locale;

  const AppPreferencesState({
    required this.isDarkMode,
    required this.notifications,
    required this.locale,
  });

  AppPreferencesState copyWith({
    bool? isDarkMode,
    bool? notifications,
    String? locale,
  }) =>
      AppPreferencesState(
        isDarkMode: isDarkMode ?? this.isDarkMode,
        notifications: notifications ?? this.notifications,
        locale: locale ?? this.locale,
      );

  @override
  List<Object?> get props => [isDarkMode, notifications, locale];
}

class AppPreferencesCubit extends Cubit<AppPreferencesState> {
  final SettingsRepo _repo;

  AppPreferencesCubit(this._repo)
      : super(AppPreferencesState(
          isDarkMode: _repo.isDarkMode,
          notifications: _repo.notifications,
          locale: _repo.locale,
        ));

  Future<void> toggleDarkMode(bool value) async {
    await _repo.setDarkMode(value);
    emit(state.copyWith(isDarkMode: value));
  }

  Future<void> toggleNotifications(bool value) async {
    await _repo.setNotifications(value);
    emit(state.copyWith(notifications: value));
  }

  Future<void> setLocale(String value) async {
    await _repo.setLocale(value);
    emit(state.copyWith(locale: value));
  }
}
