import 'package:corereusablepackage/corereusablepackage.dart' hide AppColors, BuildContextExt;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/lang_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/progress_model.dart';
import '../../data/models/student_model.dart';

class StudentCard extends StatelessWidget {
  final StudentModel student;
  final ProgressModel? progress;
  final VoidCallback onTap;

  const StudentCard({
    super.key,
    required this.student,
    this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pct =
        progress != null ? ((progress!.juzCompleted / 30) * 100).round() : 0;

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          AppAvatar(name: student.name, size: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        student.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _levelChip(context),
                  ],
                ),
                if (student.phone != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 12, color: context.mutedFg),
                      const SizedBox(width: 4),
                      Text(
                        student.phone!,
                        style: TextStyle(fontSize: 12, color: context.mutedFg),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: pct / 100,
                          minHeight: 5,
                          backgroundColor: context.mutedBg,
                          valueColor:
                              const AlwaysStoppedAnimation(AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${progress?.juzCompleted ?? 0}/30',
                      style: TextStyle(fontSize: 12, color: context.mutedFg),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_left, size: 18, color: context.mutedFg),
        ],
      ),
    );
  }

  Widget _levelChip(BuildContext context) {
    final color = AppColors.levelColor(student.level);
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        student.level == 'advanced'
            ? LangKeys.advanced.tr()
            : student.level == 'intermediate'
                ? LangKeys.intermediate.tr()
                : LangKeys.beginner.tr(),
        style: TextStyle(fontSize: 11, color: color),
      ),
    );
  }
}

