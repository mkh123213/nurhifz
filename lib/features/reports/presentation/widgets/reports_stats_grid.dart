import 'package:nurhifz/core/localization/lang_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';

import '../cubit/reports_state.dart';

class ReportsStatsGrid extends StatelessWidget {
  final ReportsState state;

  const ReportsStatsGrid({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        LangKeys.totalSessions.tr(),
        '${state.sessions.length}',
        Icons.menu_book_outlined,
        AppColors.primary
      ),
      (
        LangKeys.avgScores.tr(),
        '${state.overallAvg}%',
        Icons.trending_up,
        AppColors.green
      ),
      (
        LangKeys.bestStudent.tr(),
        state.bestStudentName,
        Icons.emoji_events_outlined,
        AppColors.yellow
      ),
      (
        LangKeys.numStudents.tr(),
        '${state.students.length}',
        Icons.track_changes,
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
      children: items.map((item) {
        final (label, value, icon, color) = item;
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w800, color: color),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(label,
                  style: TextStyle(fontSize: 11, color: context.mutedFg)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

