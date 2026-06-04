import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_overlay.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_quick_actions.dart';
import '../widgets/dashboard_recent_sessions.dart';
import '../widgets/dashboard_stats_grid.dart';
import '../widgets/dashboard_progress_section.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state.status == DashboardStatus.loading) {
          return const AppLoadingOverlay();
        }
        if (state.status == DashboardStatus.error) {
          return AppErrorState(
            message: (state.errorKey ?? 'error_unknown').tr(),
            onRetry: () => context.read<DashboardCubit>().load(),
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<DashboardCubit>().load(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            child: Column(
              children: [
                const DashboardHeader(),
                const SizedBox(height: 20),
                DashboardStatsGrid(state: state),
                const SizedBox(height: 16),
                DashboardProgressSection(state: state),
                const SizedBox(height: 16),
                DashboardRecentSessions(state: state),
                const SizedBox(height: 16),
                const DashboardQuickActions(),
              ],
            ),
          ),
        );
      },
    );
  }
}
