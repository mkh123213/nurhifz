import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_overlay.dart';
import '../cubit/students_cubit.dart';
import '../cubit/students_state.dart';
import '../widgets/add_student_sheet.dart';
import '../widgets/student_card.dart';
import '../widgets/student_detail_sheet.dart';

class StudentsBody extends StatelessWidget {
  const StudentsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentsCubit, StudentsState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'students'.tr(),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      GestureDetector(
                        onTap: () => _showAddSheet(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: AppColors.gradient,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 14,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.add, color: Colors.white, size: 22),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    onChanged: context.read<StudentsCubit>().updateSearch,
                    decoration: InputDecoration(
                      hintText: 'search_student'.tr(),
                      prefixIcon: const Icon(Icons.search, size: 20),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Text(
                    'student_count'.tr(namedArgs: {'count': '${state.filtered.length}'}),
                    style: TextStyle(fontSize: 12, color: context.mutedFg),
                  ),
                ),
                Expanded(
                  child: _buildList(context, state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildList(BuildContext context, StudentsState state) {
    if (state.status == StudentsStatus.loading) {
      return const AppLoadingOverlay();
    }
    if (state.status == StudentsStatus.error) {
      return AppErrorState(
        message: (state.errorKey ?? 'error_unknown').tr(),
        onRetry: () => context.read<StudentsCubit>().load(),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<StudentsCubit>().load(),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        itemCount: state.filtered.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final student = state.filtered[i];
          final prog = state.progressFor(student.id);
          return StudentCard(
            student: student,
            progress: prog,
            onTap: () => _showDetailSheet(context, student),
          );
        },
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<StudentsCubit>(),
        child: const AddStudentSheet(),
      ),
    );
  }

  void _showDetailSheet(BuildContext context, dynamic student) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StudentDetailSheet(student: student),
    );
  }
}
