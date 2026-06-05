import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primary = Color(0xFF4D7CFE);
  static const primaryLight = Color(0xFF7B61FF);
  static const gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );
  static const horizontalGradient = LinearGradient(
    colors: [primary, primaryLight],
  );

  static const green = Color(0xFF4ADE80);
  static const red = Color(0xFFF87171);
  static const yellow = Color(0xFFFBBF24);
  static const purple = Color(0xFFA78BFA);

  // Dark theme
  static const darkBg = Color(0xFF0A0E1E);
  static const darkCard = Color(0xFF11172E);
  static const darkCardBorder = Color(0x99282E42);
  static const darkMuted = Color(0xFF1E2438);
  static const darkMutedFg = Color(0xFF8B92A8);
  static const darkForeground = Color(0xFFE8ECF4);

  // Light theme
  static const lightBg = Color(0xFFF8F9FC);
  static const lightCard = Colors.white;
  static const lightCardBorder = Color(0xFFE2E8F0);
  static const lightMuted = Color(0xFFF1F5F9);
  static const lightMutedFg = Color(0xFF64748B);
  static const lightForeground = Color(0xFF0F172A);

  static Color scoreColor(int score) {
    if (score >= 90) return green;
    if (score >= 75) return primary;
    if (score >= 60) return yellow;
    return red;
  }

  static Color levelColor(String level) {
    switch (level) {
      case 'advanced':
        return green;
      case 'intermediate':
        return primary;
      default:
        return yellow;
    }
  }
}
