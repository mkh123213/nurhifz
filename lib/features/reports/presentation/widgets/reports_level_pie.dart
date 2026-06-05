import 'package:corereusablepackage/corereusablepackage.dart' hide AppColors, BuildContextExt;
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/localization/lang_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/reports_state.dart';

class ReportsLevelPie extends StatelessWidget {
  final ReportsState state;

  const ReportsLevelPie({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final levels = [
      (LangKeys.advanced.tr(), state.levelCount('advanced'), AppColors.green),
      (
        LangKeys.intermediate.tr(),
        state.levelCount('intermediate'),
        AppColors.primary
      ),
      (LangKeys.beginner.tr(), state.levelCount('beginner'), AppColors.yellow),
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LangKeys.levelDistribution.tr(),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 35,
                    sections: levels
                        .where((l) => l.$2 > 0)
                        .map((l) => PieChartSectionData(
                              value: l.$2.toDouble(),
                              color: l.$3,
                              radius: 20,
                              showTitle: false,
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: levels.map((l) {
                  final (label, count, color) = l;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(label, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 8),
                        Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

