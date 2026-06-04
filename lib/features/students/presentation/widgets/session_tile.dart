import 'package:nurhifz/core/localization/lang_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/session_model.dart';

class SessionTile extends StatelessWidget {
  final SessionModel session;

  const SessionTile({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.cardBg.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.surahName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  '${session.date} · ${session.type == 'hifz' ? LangKeys.hifz.tr() : LangKeys.muraja.tr()} · ${LangKeys.fromAyah.tr()} ${session.ayahStart}-${session.ayahEnd}',
                  style: TextStyle(fontSize: 11, color: context.mutedFg),
                ),
                if (session.notes != null && session.notes!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      session.notes!,
                      style: TextStyle(fontSize: 11, color: context.mutedFg),
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '${session.score}%',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.scoreColor(session.score),
            ),
          ),
        ],
      ),
    );
  }
}
