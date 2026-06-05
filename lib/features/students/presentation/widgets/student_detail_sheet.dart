import 'package:corereusablepackage/corereusablepackage.dart' hide AppColors, BuildContextExt;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/lang_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/session_model.dart';
import '../../data/models/student_model.dart';
import '../cubit/student_detail_cubit.dart';
import '../cubit/student_detail_state.dart';
import '../cubit/students_cubit.dart';
import 'session_form.dart';
import 'session_tile.dart';
import 'student_progress_view.dart';

class StudentDetailSheet extends StatelessWidget {
  final StudentModel student;

  const StudentDetailSheet({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StudentDetailCubit>()..load(student.id),
      child: _SheetContent(student: student),
    );
  }
}

class _SheetContent extends StatefulWidget {
  final StudentModel student;

  const _SheetContent({required this.student});

  @override
  State<_SheetContent> createState() => _SheetContentState();
}

class _SheetContentState extends State<_SheetContent> {
  int _tab = 0;
  bool _showForm = false;
  SessionModel? _editingSession;
  late String _currentLevel;

  @override
  void initState() {
    super.initState();
    _currentLevel = widget.student.level;
  }

  void _onSessionSaved() {
    setState(() {
      _showForm = false;
      _editingSession = null;
    });
  }

  void _editSession(SessionModel session) {
    setState(() {
      _editingSession = session;
      _showForm = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: context.isDark ? const Color(0xFF0B1024) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: context.cardBorder)),
      ),
      child: Column(
        children: [
          _handle(context),
          _header(context),
          _tabs(context),
          Expanded(child: _content(context)),
        ],
      ),
    );
  }

  Widget _handle(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      decoration: BoxDecoration(
        color: context.cardBorder,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        children: [
          AppAvatar(name: widget.student.name, size: 48),
          const SizedBox(width: 12),
          Expanded(
            child: BlocBuilder<StudentDetailCubit, StudentDetailState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.student.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _levelChip(context),
                        const SizedBox(width: 8),
                        Text(
                          state.progress != null
                              ? 'juz_of_30'.tr(namedArgs: {
                                  'count': '${state.progress!.juzCompleted}'
                                })
                              : LangKeys.noProgressRecorded.tr(),
                          style:
                              TextStyle(fontSize: 12, color: context.mutedFg),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 32,
              height: 32,
              decoration:
                  BoxDecoration(color: context.mutedBg, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(Icons.close, size: 16, color: context.mutedFg),
            ),
          ),
        ],
      ),
    );
  }

  Widget _levelChip(BuildContext context) {
    final levelLabels = {
      'beginner': LangKeys.beginner.tr(),
      'intermediate': LangKeys.intermediate.tr(),
      'advanced': LangKeys.advanced.tr(),
    };

    return PopupMenuButton<String>(
      onSelected: (level) {
        setState(() => _currentLevel = level);
        context
            .read<StudentsCubit>()
            .updateStudentLevel(widget.student.id, level);
      },
      itemBuilder: (_) => levelLabels.entries
          .map((e) => PopupMenuItem(value: e.key, child: Text(e.value)))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.levelColor(_currentLevel).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              levelLabels[_currentLevel] ?? _currentLevel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.levelColor(_currentLevel),
              ),
            ),
            const SizedBox(width: 2),
            Icon(Icons.arrow_drop_down,
                size: 14, color: AppColors.levelColor(_currentLevel)),
          ],
        ),
      ),
    );
  }

  Widget _tabs(BuildContext context) {
    final labels = [LangKeys.sessionsTab.tr(), LangKeys.progressTab.tr()];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(labels.length, (i) {
          final active = i == _tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _tab = i),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  gradient: active ? AppColors.gradient : null,
                  color: active ? null : context.mutedBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: active ? Colors.white : context.mutedFg,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _content(BuildContext context) {
    return BlocBuilder<StudentDetailCubit, StudentDetailState>(
      builder: (context, state) {
        if (state.status == DetailStatus.loading) {
          return const AppLoadingOverlay();
        }

        if (_tab == 0) {
          return _sessionsTab(context, state);
        }
        return StudentProgressView(progress: state.progress);
      },
    );
  }

  Widget _sessionsTab(BuildContext context, StudentDetailState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _addSessionButton(context),
          if (_showForm)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SessionForm(
                key: ValueKey(_editingSession?.id ?? 'new'),
                studentId: widget.student.id,
                isLoading: state.isAddingSession,
                session: _editingSession,
                onSaved: _onSessionSaved,
              ),
            ),
          const SizedBox(height: 12),
          if (state.sessions.isEmpty)
            AppEmptyState(message: LangKeys.noRecordedSessions.tr())
          else
            ...state.sessions.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SessionTile(
                    session: s,
                    onTap: () => _editSession(s),
                  ),
                )),
        ],
      ),
    );
  }

  Widget _addSessionButton(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        _editingSession = null;
        _showForm = !_showForm;
      }),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: AppColors.gradient,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              LangKeys.addSession.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
