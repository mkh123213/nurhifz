import '../data_source/settings_local_data_source.dart';

class SettingsRepo {
  final SettingsLocalDataSource _dataSource;

  SettingsRepo(this._dataSource);

  bool get isDarkMode => _dataSource.isDarkMode;
  Future<void> setDarkMode(bool v) => _dataSource.setDarkMode(v);

  bool get notifications => _dataSource.notifications;
  Future<void> setNotifications(bool v) => _dataSource.setNotifications(v);

  String get locale => _dataSource.locale;
  Future<void> setLocale(String v) => _dataSource.setLocale(v);
}
