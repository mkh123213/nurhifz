import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../cubit/reports_state.dart';

class ReportsDetailTable extends StatelessWidget {
  final List<StudentStat> stats;

  const ReportsDetailTable({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'students_details'.tr(),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Divider(height: 1, color: context.cardBorder),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 40,
              dataRowMinHeight: 44,
              dataRowMaxHeight: 44,
              columnSpacing: 24,
              columns: [
                DataColumn(label: Text('student_col'.tr(), style: TextStyle(fontSize: 12, color: context.mutedFg))),
                DataColumn(label: Text('score_col'.tr(), style: TextStyle(fontSize: 12, color: context.mutedFg))),
                DataColumn(label: Text('juz_col'.tr(), style: TextStyle(fontSize: 12, color: context.mutedFg))),
                DataColumn(label: Text('attendance_col'.tr(), style: TextStyle(fontSize: 12, color: context.mutedFg))),
              ],
              rows: stats.map((s) {
                return DataRow(cells: [
                  DataCell(Text(s.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                  DataCell(Text(
                    '${s.avgScore}%',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.scoreColor(s.avgScore),
                    ),
                  )),
                  DataCell(Text('${s.juzCompleted}/30')),
                  DataCell(Text('${s.presentPct}%')),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
