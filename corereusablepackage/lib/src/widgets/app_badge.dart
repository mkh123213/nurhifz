import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppBadge extends StatelessWidget {
  final Widget child;
  final int count;
  final Color color;
  final bool show;

  const AppBadge({
    super.key,
    required this.child,
    this.count = 0,
    this.color = AppColors.red,
    this.show = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!show || count <= 0) return child;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: -6,
          right: -6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              count > 99 ? '99+' : '$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
