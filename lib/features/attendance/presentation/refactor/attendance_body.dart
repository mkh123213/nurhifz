import 'package:nurhifz/core/localization/lang_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:corereusablepackage/corereusablepackage.dart';
import '../cubit/attendance_cubit.dart';
import '../cubit/attendance_state.dart';
import '../widgets/attendance_date_picker.dart';
import '../widgets/attendance_student_card.dart';
import '../widgets/attendance_summary.dart';

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
                AttendanceSummary(state: state),
                const SizedBox(height: 12),
                ...state.students.map((student) => Padding(
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
}
