import 'package:nurhifz/core/localization/lang_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:corereusablepackage/corereusablepackage.dart' hide BuildContextExt;
import 'package:nurhifz/core/extensions/context_extensions.dart';
import '../../../students/data/models/student_model.dart';
import '../cubit/attendance_cubit.dart';

class AttendanceStudentCard extends StatelessWidget {
  final StudentModel student;
  final String? currentStatus;

  const AttendanceStudentCard({
    super.key,
    required this.student,
    this.currentStatus,
  });

  static const _statuses = [
    ('present', Icons.check, AppColors.green),
    ('absent', Icons.close, AppColors.red),
    ('excused', Icons.access_time, AppColors.yellow),
  ];

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              AppAvatar(name: student.name, size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  student.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
              if (currentStatus != null) _statusChip(context),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: _statuses.map((s) {
              final (key, icon, color) = s;
              final active = currentStatus == key;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: GestureDetector(
                    onTap: () {
                      context
                          .read<AttendanceCubit>()
                          .saveAttendance(student.id, key);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: active
                            ? color.withValues(alpha: 0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: active ? color : context.cardBorder,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon,
                              size: 14,
                              color: active ? color : context.mutedFg),
                          const SizedBox(width: 4),
                          Text(
                            key == 'present'
                                ? LangKeys.present.tr()
                                : key == 'absent'
                                    ? LangKeys.absent.tr()
                                    : LangKeys.excused.tr(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: active ? color : context.mutedFg,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(BuildContext context) {
    final entry = _statuses.where((s) => s.$1 == currentStatus).firstOrNull;
    if (entry == null) return const SizedBox.shrink();
    final (key, _, color) = entry;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        key == 'present'
            ? LangKeys.present.tr()
            : key == 'absent'
                ? LangKeys.absent.tr()
                : LangKeys.excused.tr(),
        style: TextStyle(fontSize: 11, color: color),
      ),
    );
  }
}

