import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

extension BuildContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  bool get isDark => theme.brightness == Brightness.dark;

  Color get cardBg =>
      isDark ? AppColors.darkCard.withValues(alpha: 0.8) : AppColors.lightCard;
  Color get cardBorder =>
      isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;
  Color get mutedFg => isDark ? AppColors.darkMutedFg : AppColors.lightMutedFg;
  Color get foreground =>
      isDark ? AppColors.darkForeground : AppColors.lightForeground;
  Color get mutedBg => isDark ? AppColors.darkMuted : AppColors.lightMuted;
}
