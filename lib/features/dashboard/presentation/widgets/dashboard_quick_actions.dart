import 'package:nurhifz/core/localization/lang_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/app_routes.dart';


class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppCard(
            onTap: () => context.go(AppRoutes.attendance),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.calendar_today,
                    size: 24, color: AppColors.green),
                const SizedBox(height: 8),
                Text(
                  LangKeys.recordAttendance.tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  LangKeys.recordStudentsAttendance.tr(),
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.darkMutedFg),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppCard(
            onTap: () => context.go(AppRoutes.students),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.star_outline,
                    size: 24, color: AppColors.yellow),
                const SizedBox(height: 8),
                Text(
                  LangKeys.evaluateStudents.tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  LangKeys.addRecitationSession.tr(),
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.darkMutedFg),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

