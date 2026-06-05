import 'package:corereusablepackage/corereusablepackage.dart' hide AppColors, BuildContextExt;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/lang_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/attendance_cubit.dart';
import '../cubit/attendance_state.dart';
import '../widgets/attendance_date_picker.dart';
import '../widgets/attendance_student_card.dart';

class AttendanceBody extends StatelessWidget {
  const AttendanceBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AttendanceCubit, AttendanceState>(
      listenWhen: (prev, curr) =>
          prev.isSaving && !curr.isSaving && curr.errorKey == null,
      listener: (context, state) {
        showToast(LangKeys.saved.tr());
      },
      builder: (context, state) {
        if (state.status == AttendanceStatus.loading) {
          return const AppLoadingOverlay();
        }
        if (state.status == AttendanceStatus.error) {
          return AppErrorState(
            message: (state.errorKey ?? 'error_unknown').tr(),
            onRetry: () => context.read<AttendanceCubit>().load(),
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<AttendanceCubit>().load(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LangKeys.attendanceTitle.tr(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                const AttendanceDatePicker(),
                const SizedBox(height: 12),
                _tabBar(context, state),
                const SizedBox(height: 12),
                if (state.filteredByTab.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: AppEmptyState(message: LangKeys.noData.tr()),
                  )
                else
                  ...state.filteredByTab.map((student) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: AttendanceStudentCard(
                          student: student,
                          currentStatus: state.statusFor(student.id),
                        ),
                      )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _tabBar(BuildContext context, AttendanceState state) {
    final tabs = [
      (LangKeys.allTab.tr(), state.unmarkedStudents.length, context.mutedFg),
      (LangKeys.present.tr(), state.presentStudents.length, AppColors.green),
      (LangKeys.absent.tr(), state.absentStudents.length, AppColors.red),
      (LangKeys.excused.tr(), state.excusedStudents.length, AppColors.yellow),
    ];

    return Row(
      children: List.generate(tabs.length, (i) {
        final active = i == state.selectedTab;
        final (label, count, color) = tabs[i];
        return Expanded(
          child: GestureDetector(
            onTap: () => context.read<AttendanceCubit>().setTab(i),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: active ? AppColors.gradient : null,
                color: active ? null : context.mutedBg,
                borderRadius: BorderRadius.circular(12),
                border: active
                    ? null
                    : Border.all(color: context.cardBorder),
              ),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: active ? Colors.white : color,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.white : context.mutedFg,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
