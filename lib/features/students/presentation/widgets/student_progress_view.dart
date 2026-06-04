import 'package:nurhifz/core/localization/lang_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';


import '../../data/models/progress_model.dart';

class StudentProgressView extends StatelessWidget {
  final ProgressModel? progress;

  const StudentProgressView({super.key, this.progress});

  @override
  Widget build(BuildContext context) {
    if (progress == null) {
      return AppEmptyState(message: LangKeys.noProgressRecorded.tr());
    }

    final p = progress!;
    final pct = (p.juzCompleted / 30 * 100).round();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LangKeys.totalProgress.tr(),
                  style: TextStyle(fontSize: 12, color: context.mutedFg),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 36),
                    children: [
                      TextSpan(
                        text: '${p.juzCompleted}',
                        style: const TextStyle(color: AppColors.primary),
                      ),
                      TextSpan(
                        text: '/30 ${LangKeys.juzUnit.tr()}',
                        style: TextStyle(fontSize: 16, color: context.mutedFg),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: pct / 100,
                    minHeight: 10,
                    backgroundColor: context.mutedBg,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${LangKeys.lastSession.tr()}: ${p.lastSessionDate ?? '—'}',
                  style: TextStyle(fontSize: 12, color: context.mutedFg),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppCard(
                  child: Column(
                    children: [
                      Text(
                        '${p.pagesCompleted}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.green,
                        ),
                      ),
                      Text(
                        LangKeys.pagesMemorized.tr(),
                        style: TextStyle(fontSize: 12, color: context.mutedFg),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppCard(
                  child: Column(
                    children: [
                      Text(
                        '${p.targetJuz}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.yellow,
                        ),
                      ),
                      Text(
                        LangKeys.targetJuz.tr(),
                        style: TextStyle(fontSize: 12, color: context.mutedFg),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

