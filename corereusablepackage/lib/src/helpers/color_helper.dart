import 'package:flutter/material.dart';

class ColorHelper {
  ColorHelper._();

  static Color fromHex(String hex) {
    final buffer = StringBuffer();
    if (hex.startsWith('#')) hex = hex.substring(1);
    if (hex.length == 6) buffer.write('FF');
    buffer.write(hex);
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static String toHex(Color color, {bool withHash = true}) {
    final hex = color.toARGB32().toRadixString(16).padLeft(8, '0');
    return withHash ? '#$hex' : hex;
  }

  static Color darken(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  static Color lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  static Color withOpacity(Color color, double opacity) =>
      color.withValues(alpha: opacity);
}
