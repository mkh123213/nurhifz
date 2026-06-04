import 'package:nurhifz/core/localization/lang_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';

import '../cubit/dashboard_state.dart';

class DashboardStatsGrid extends StatelessWidget {
  final DashboardState state;

  const DashboardStatsGrid({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final stats = [
      (
        LangKeys.totalStudents.tr(),
        '${state.students.length}',
        Icons.people_outline,
        AppColors.primary
      ),
      (
        LangKeys.presentToday.tr(),
        '${state.presentToday}/${state.students.length}',
        Icons.calendar_today,
        AppColors.green
      ),
      (
        LangKeys.avgScores.tr(),
        '${state.avgScore}%',
        Icons.trending_up,
        AppColors.yellow
      ),
      (
        LangKeys.totalJuz.tr(),
        '${state.totalJuz}',
        Icons.menu_book_outlined,
        AppColors.purple
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.3,
      children: stats.map((s) {
        final (label, value, icon, color) = s;
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 11, color: context.mutedFg),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

