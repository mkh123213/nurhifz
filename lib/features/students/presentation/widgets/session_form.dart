import 'package:corereusablepackage/corereusablepackage.dart' hide AppColors, BuildContextExt;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/surah_data.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/lang_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/session_model.dart';
import '../cubit/student_detail_cubit.dart';
import '../cubit/student_detail_state.dart';

class SessionForm extends StatefulWidget {
  final String studentId;
  final bool isLoading;
  final SessionModel? session;
  final VoidCallback? onSaved;

  const SessionForm({
    super.key,
    required this.studentId,
    required this.isLoading,
    this.session,
    this.onSaved,
  });

  bool get isEditing => session != null;

  @override
  State<SessionForm> createState() => _SessionFormState();
}

class _SessionFormState extends State<SessionForm> {
  late String _type;
  late String _surah;
  final _ayahStartCtrl = TextEditingController();
  final _ayahEndCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  late int _score;
  bool _toLastAyah = false;

  @override
  void initState() {
    super.initState();
    final s = widget.session;
    if (s != null) {
      _type = s.type;
      _surah = surahs.contains(s.surahName) ? s.surahName : surahs.first;
      _ayahStartCtrl.text = '${s.ayahStart}';
      _ayahEndCtrl.text = '${s.ayahEnd}';
      _notesCtrl.text = s.notes ?? '';
      _score = _nearestScore(s.score);
      _toLastAyah = s.ayahEnd == (surahAyahs[_surah] ?? 1);
    } else {
      _type = 'hifz';
      _surah = surahs.first;
      _ayahStartCtrl.text = '1';
      _ayahEndCtrl.text = '10';
      _score = 75;
    }
  }

  static int _nearestScore(int value) {
    const options = [25, 50, 75, 100];
    return options.reduce(
        (a, b) => (value - a).abs() < (value - b).abs() ? a : b);
  }

  @override
  void dispose() {
    _ayahStartCtrl.dispose();
    _ayahEndCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentDetailCubit, StudentDetailState>(
      listenWhen: (prev, curr) =>
          prev.isAddingSession && !curr.isAddingSession,
      listener: (context, state) {
        if (state.errorKey == null) {
          showToast(widget.isEditing
              ? LangKeys.sessionUpdated.tr()
              : LangKeys.sessionAdded.tr());
          widget.onSaved?.call();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.cardBorder),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _typeDropdown(context)),
                const SizedBox(width: 8),
                Expanded(child: _scoreSelector(context)),
              ],
            ),
            const SizedBox(height: 12),
            _surahDropdown(context),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: LangKeys.fromAyah.tr(),
                    controller: _ayahStartCtrl,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppTextField(
                    label: LangKeys.toAyah.tr(),
                    controller: _ayahEndCtrl,
                    keyboardType: TextInputType.number,
                    enabled: !_toLastAyah,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: _toLastAyah,
                  onChanged: (v) {
                    setState(() {
                      _toLastAyah = v ?? false;
                      if (_toLastAyah) {
                        _ayahEndCtrl.text = '${surahAyahs[_surah] ?? 1}';
                      }
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    LangKeys.toLastAyah.tr(),
                    style: TextStyle(fontSize: 12, color: context.mutedFg),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AppTextField(
              label: LangKeys.notes.tr(),
              controller: _notesCtrl,
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: widget.isEditing
                  ? LangKeys.updateSession.tr()
                  : LangKeys.saveSession.tr(),
              isLoading: widget.isLoading,
              onPressed: () => _submit(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scoreSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LangKeys.scoreLabel.tr(),
          style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
        ),
        const SizedBox(height: 6),
        Row(
          children: [25, 50, 75, 100].map((s) {
            final active = _score == s;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _score = s),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    gradient: active ? AppColors.gradient : null,
                    color: active ? null : context.mutedBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: active ? AppColors.primary : context.cardBorder,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$s',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.white : context.mutedFg,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _typeDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LangKeys.typeLabel.tr(),
          style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: _type,
          onChanged: (v) => setState(() => _type = v ?? 'hifz'),
          decoration: const InputDecoration(),
          items: [
            DropdownMenuItem(value: 'hifz', child: Text(LangKeys.hifz.tr())),
            DropdownMenuItem(
                value: 'muraja', child: Text(LangKeys.muraja.tr())),
          ],
        ),
      ],
    );
  }

  Widget _surahDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LangKeys.surahLabel.tr(),
          style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: _surah,
          onChanged: (v) {
            setState(() {
              _surah = v ?? surahs.first;
              if (_toLastAyah) {
                _ayahEndCtrl.text = '${surahAyahs[_surah] ?? 1}';
              }
            });
          },
          isExpanded: true,
          decoration: const InputDecoration(),
          items: surahs
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
        ),
      ],
    );
  }

  void _submit(BuildContext context) {
    final today = DateTime.now();
    final dateStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final data = {
      'student_id': widget.studentId,
      'date': dateStr,
      'type': _type,
      'surah_name': _surah,
      'ayah_start': int.tryParse(_ayahStartCtrl.text) ?? 1,
      'ayah_end': int.tryParse(_ayahEndCtrl.text) ?? 1,
      'score': _score,
      'mistakes': <String>[],
      if (_notesCtrl.text.trim().isNotEmpty) 'notes': _notesCtrl.text.trim(),
    };

    if (widget.isEditing) {
      context
          .read<StudentDetailCubit>()
          .updateSession(widget.session!.id, widget.studentId, data);
    } else {
      context.read<StudentDetailCubit>().addSession(data);
    }
  }
}
