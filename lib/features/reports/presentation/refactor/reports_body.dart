import 'package:nurhifz/core/localization/lang_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_overlay.dart';
import '../cubit/reports_cubit.dart';
import '../cubit/reports_state.dart';
import '../widgets/reports_detail_table.dart';
import '../widgets/reports_juz_chart.dart';
import '../widgets/reports_level_pie.dart';
import '../widgets/reports_scores_chart.dart';
import '../widgets/reports_stats_grid.dart';

class ReportsBody extends StatelessWidget {
  const ReportsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        if (state.status == ReportsStatus.loading) {
          return const AppLoadingOverlay();
        }
        if (state.status == ReportsStatus.error) {
          return AppErrorState(
            message: (state.errorKey ?? 'error_unknown').tr(),
            onRetry: () => context.read<ReportsCubit>().load(),
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<ReportsCubit>().load(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LangKeys.reportsTitle.tr(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                ReportsStatsGrid(state: state),
                const SizedBox(height: 16),
                ReportsScoresChart(stats: state.studentStats),
                const SizedBox(height: 16),
                ReportsJuzChart(stats: state.studentStats),
                const SizedBox(height: 16),
                ReportsLevelPie(state: state),
                const SizedBox(height: 16),
                ReportsDetailTable(stats: state.studentStats),
              ],
            ),
          ),
        );
      },
    );
  }
}
