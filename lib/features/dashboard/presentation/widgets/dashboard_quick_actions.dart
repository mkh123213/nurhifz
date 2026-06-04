import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

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
                const Icon(Icons.calendar_today, size: 24, color: AppColors.green),
                const SizedBox(height: 8),
                Text(
                  'record_attendance'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  'record_students_attendance'.tr(),
                  style: const TextStyle(fontSize: 12, color: AppColors.darkMutedFg),
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
                const Icon(Icons.star_outline, size: 24, color: AppColors.yellow),
                const SizedBox(height: 8),
                Text(
                  'evaluate_students'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  'add_recitation_session'.tr(),
                  style: const TextStyle(fontSize: 12, color: AppColors.darkMutedFg),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
