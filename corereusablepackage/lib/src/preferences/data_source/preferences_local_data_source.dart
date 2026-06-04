import 'package:shared_preferences/shared_preferences.dart';

class PreferencesLocalDataSource {
  final SharedPreferences _prefs;

  PreferencesLocalDataSource(this._prefs);

  static const _darkModeKey = 'dark_mode';
  static const _notificationsKey = 'notifications';
  static const _localeKey = 'locale';

  bool get isDarkMode => _prefs.getBool(_darkModeKey) ?? true;
  Future<void> setDarkMode(bool value) => _prefs.setBool(_darkModeKey, value);

  bool get notifications => _prefs.getBool(_notificationsKey) ?? true;
  Future<void> setNotifications(bool v) =>
      _prefs.setBool(_notificationsKey, v);

  String get locale => _prefs.getString(_localeKey) ?? 'ar';
  Future<void> setLocale(String v) => _prefs.setString(_localeKey, v);
}
