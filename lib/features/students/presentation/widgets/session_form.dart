import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/surah_data.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_toast.dart';
import '../cubit/student_detail_cubit.dart';
import '../cubit/student_detail_state.dart';

class SessionForm extends StatefulWidget {
  final String studentId;
  final bool isLoading;

  const SessionForm({
    super.key,
    required this.studentId,
    required this.isLoading,
  });

  @override
  State<SessionForm> createState() => _SessionFormState();
}

class _SessionFormState extends State<SessionForm> {
  String _type = 'hifz';
  String _surah = surahs.first;
  final _ayahStartCtrl = TextEditingController(text: '1');
  final _ayahEndCtrl = TextEditingController(text: '10');
  final _scoreCtrl = TextEditingController(text: '80');
  final _notesCtrl = TextEditingController();
  bool _toLastAyah = false;

  @override
  void dispose() {
    _ayahStartCtrl.dispose();
    _ayahEndCtrl.dispose();
    _scoreCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentDetailCubit, StudentDetailState>(
      listenWhen: (prev, curr) => prev.isAddingSession && !curr.isAddingSession,
      listener: (context, state) {
        if (state.errorKey == null) {
          showToast('session_added'.tr());
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
                Expanded(
                  child: AppTextField(
                    label: 'score_label'.tr(),
                    controller: _scoreCtrl,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _surahDropdown(context),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'from_ayah'.tr(),
                    controller: _ayahStartCtrl,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppTextField(
                    label: 'to_ayah'.tr(),
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
                    'to_last_ayah'.tr(),
                    style: TextStyle(fontSize: 12, color: context.mutedFg),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AppTextField(
              label: 'notes'.tr(),
              controller: _notesCtrl,
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'save_session'.tr(),
              isLoading: widget.isLoading,
              onPressed: () => _submit(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'type_label'.tr(),
          style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: _type,
          onChanged: (v) => setState(() => _type = v ?? 'hifz'),
          decoration: const InputDecoration(),
          items: [
            DropdownMenuItem(value: 'hifz', child: Text('hifz'.tr())),
            DropdownMenuItem(value: 'muraja', child: Text('muraja'.tr())),
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
          'surah_label'.tr(),
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
          items: surahs.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
        ),
      ],
    );
  }

  void _submit(BuildContext context) {
    final today = DateTime.now();
    final dateStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    context.read<StudentDetailCubit>().addSession({
      'student_id': widget.studentId,
      'date': dateStr,
      'type': _type,
      'surah_name': _surah,
      'ayah_start': int.tryParse(_ayahStartCtrl.text) ?? 1,
      'ayah_end': int.tryParse(_ayahEndCtrl.text) ?? 1,
      'score': int.tryParse(_scoreCtrl.text) ?? 0,
      'mistakes': <String>[],
      if (_notesCtrl.text.trim().isNotEmpty) 'notes': _notesCtrl.text.trim(),
    });
  }
}
