import 'dart:developer' as dev;

class AppLogger {
  AppLogger._();

  static void info(String message, {String tag = 'APP'}) {
    dev.log('ℹ️ $message', name: tag);
  }

  static void success(String message, {String tag = 'APP'}) {
    dev.log('✅ $message', name: tag);
  }

  static void warning(String message, {String tag = 'APP'}) {
    dev.log('⚠️ $message', name: tag);
  }

  static void error(String message, {String tag = 'APP', Object? error, StackTrace? stackTrace}) {
    dev.log('❌ $message', name: tag, error: error, stackTrace: stackTrace);
  }

  static void debug(String message, {String tag = 'DEBUG'}) {
    assert(() {
      dev.log('🐛 $message', name: tag);
      return true;
    }());
  }

  static void network(String method, String url, {int? statusCode, String tag = 'HTTP'}) {
    final status = statusCode != null ? ' → $statusCode' : '';
    dev.log('🌐 $method $url$status', name: tag);
  }
}
