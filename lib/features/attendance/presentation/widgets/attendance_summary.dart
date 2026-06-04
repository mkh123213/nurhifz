import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nurhifz/core/localization/lang_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/attendance_state.dart';

class AttendanceSummary extends StatelessWidget {
  final AttendanceState state;

  const AttendanceSummary({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final items = [
      (LangKeys.present.tr(), state.countByStatus('present'), AppColors.green),
      (LangKeys.absent.tr(), state.countByStatus('absent'), AppColors.red),
      (LangKeys.excused.tr(), state.countByStatus('excused'), AppColors.yellow),
    ];

    return Row(
      children: items.map((item) {
        final (label, count, color) = item;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: color),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
