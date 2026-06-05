import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../extensions/context_extensions.dart';

class AppProgressBar extends StatelessWidget {
  final double value;
  final String? label;
  final bool showPercent;
  final double height;
  final Color? color;

  const AppProgressBar({
    super.key,
    required this.value,
    this.label,
    this.showPercent = true,
    this.height = 8,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);
    final barColor = color ?? AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || showPercent)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: TextStyle(fontSize: 12, color: context.mutedFg),
                  ),
                const Spacer(),
                if (showPercent)
                  Text(
                    '${(clamped * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: barColor,
                    ),
                  ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: clamped,
            minHeight: height,
            backgroundColor: context.mutedBg,
            valueColor: AlwaysStoppedAnimation(barColor),
          ),
        ),
      ],
    );
  }
}
