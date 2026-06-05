import 'package:flutter/services.dart';

class HapticHelper {
  HapticHelper._();

  static Future<void> light() => HapticFeedback.lightImpact();
  static Future<void> medium() => HapticFeedback.mediumImpact();
  static Future<void> heavy() => HapticFeedback.heavyImpact();
  static Future<void> selection() => HapticFeedback.selectionClick();
  static Future<void> vibrate() => HapticFeedback.vibrate();
}
