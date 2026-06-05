import 'package:corereusablepackage/corereusablepackage.dart' hide AppColors, BuildContextExt;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/lang_keys.dart';
import '../cubit/students_cubit.dart';
import '../cubit/students_state.dart';

class AddStudentSheet extends StatefulWidget {
  const AddStudentSheet({super.key});

  @override
  State<AddStudentSheet> createState() => _AddStudentSheetState();
}

class _AddStudentSheetState extends State<AddStudentSheet> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _level = 'beginner';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _ageCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentsCubit, StudentsState>(
      listenWhen: (prev, curr) => prev.isAdding && !curr.isAdding,
      listener: (context, state) {
        if (state.errorKey == null) {
          showToast(LangKeys.studentAdded.tr());
          Navigator.pop(context);
        } else {
          showToast(state.errorKey!.tr(), isError: true);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.isDark ? const Color(0xFF0B1024) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: context.cardBorder)),
        ),
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.cardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LangKeys.addNewStudent.tr(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: context.mutedBg,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child:
                          Icon(Icons.close, size: 16, color: context.mutedFg),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: '${LangKeys.studentName.tr()} *',
                hint: LangKeys.enterFullName.tr(),
                controller: _nameCtrl,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: LangKeys.phoneNumber.tr(),
                      hint: '05xxxxxxxx',
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      label: LangKeys.age.tr(),
                      hint: '12',
                      controller: _ageCtrl,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _levelDropdown(context),
              const SizedBox(height: 12),
              AppTextField(
                label: LangKeys.notes.tr(),
                controller: _notesCtrl,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              BlocBuilder<StudentsCubit, StudentsState>(
                builder: (context, state) {
                  return AppButton(
                    label: LangKeys.addStudent.tr(),
                    isLoading: state.isAdding,
                    onPressed: _nameCtrl.text.trim().isEmpty
                        ? null
                        : () => _submit(context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _levelDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LangKeys.level.tr(),
          style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: _level,
          onChanged: (v) => setState(() => _level = v ?? 'beginner'),
          decoration: const InputDecoration(),
          items: [
            DropdownMenuItem(
                value: 'beginner', child: Text(LangKeys.beginner.tr())),
            DropdownMenuItem(
                value: 'intermediate', child: Text(LangKeys.intermediate.tr())),
            DropdownMenuItem(
                value: 'advanced', child: Text(LangKeys.advanced.tr())),
          ],
        ),
      ],
    );
  }

  void _submit(BuildContext context) {
    final age = int.tryParse(_ageCtrl.text);
    context.read<StudentsCubit>().addStudent({
      'name': _nameCtrl.text.trim(),
      if (_phoneCtrl.text.trim().isNotEmpty) 'phone': _phoneCtrl.text.trim(),
      if (age != null) 'age': age,
      'level': _level,
      if (_notesCtrl.text.trim().isNotEmpty) 'notes': _notesCtrl.text.trim(),
      'is_active': true,
    });
  }
}

