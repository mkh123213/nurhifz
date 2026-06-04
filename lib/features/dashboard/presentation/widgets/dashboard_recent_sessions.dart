import 'package:nurhifz/core/localization/lang_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../cubit/dashboard_state.dart';

class DashboardRecentSessions extends StatelessWidget {
  final DashboardState state;

  const DashboardRecentSessions({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final recent = state.recentSessions;

    return AppCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LangKeys.recentSessions.tr(),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              GestureDetector(
                onTap: () => context.go(AppRoutes.students),
                child: Text(
                  LangKeys.addSession.tr(),
                  style:
                      const TextStyle(fontSize: 12, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (recent.isEmpty)
            AppEmptyState(message: LangKeys.noSessionsYet.tr())
          else
            ...recent.map((s) {
              final student = state.students
                  .where((st) => st.id == s.studentId)
                  .firstOrNull;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.mutedBg.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      AppAvatar(name: student?.name ?? '؟', size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student?.name ?? '—',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${s.surahName} · ${s.type == 'hifz' ? LangKeys.hifz.tr() : LangKeys.muraja.tr()}',
                              style: TextStyle(
                                  fontSize: 12, color: context.mutedFg),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${s.score}%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.scoreColor(s.score),
                            ),
                          ),
                          Text(
                            s.date,
                            style:
                                TextStyle(fontSize: 11, color: context.mutedFg),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
