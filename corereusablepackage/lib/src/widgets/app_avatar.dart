import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppAvatar extends StatelessWidget {
  final String name;
  final double size;
  final String fallbackChar;

  const AppAvatar({
    super.key,
    required this.name,
    this.size = 48,
    this.fallbackChar = '?',
  });

  @override
  Widget build(BuildContext context) {
    final letter = name.isNotEmpty ? name[0] : fallbackChar;
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.38,
        ),
      ),
    );
  }
}
