import '../data_source/preferences_local_data_source.dart';

class PreferencesRepo {
  final PreferencesLocalDataSource _dataSource;

  PreferencesRepo(this._dataSource);

  bool get isDarkMode => _dataSource.isDarkMode;
  Future<void> setDarkMode(bool v) => _dataSource.setDarkMode(v);

  bool get notifications => _dataSource.notifications;
  Future<void> setNotifications(bool v) => _dataSource.setNotifications(v);

  String get locale => _dataSource.locale;
  Future<void> setLocale(String v) => _dataSource.setLocale(v);
}
