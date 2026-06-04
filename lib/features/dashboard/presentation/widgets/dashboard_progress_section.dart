import 'package:nurhifz/core/localization/lang_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../cubit/dashboard_state.dart';

class DashboardProgressSection extends StatelessWidget {
  final DashboardState state;

  const DashboardProgressSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final items = state.progress.take(4).toList();

    return AppCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LangKeys.studentsProgress.tr(),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              GestureDetector(
                onTap: () => context.go(AppRoutes.reports),
                child: Text(
                  LangKeys.viewAll.tr(),
                  style:
                      const TextStyle(fontSize: 12, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((p) {
            final student =
                state.students.where((s) => s.id == p.studentId).firstOrNull;
            final pct = ((p.juzCompleted / 30) * 100).round();
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        student?.name ?? '—',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        '${p.juzCompleted}/30 ${LangKeys.juzUnit.tr()}',
                        style: TextStyle(fontSize: 12, color: context.mutedFg),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct / 100,
                      minHeight: 6,
                      backgroundColor: context.mutedBg,
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
