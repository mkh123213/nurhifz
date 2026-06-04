import 'package:equatable/equatable.dart';
import '../../data/models/student_model.dart';
import '../../data/models/progress_model.dart';

enum StudentsStatus { initial, loading, loaded, error }

class StudentsState extends Equatable {
  final StudentsStatus status;
  final List<StudentModel> students;
  final List<ProgressModel> progress;
  final String search;
  final bool isAdding;
  final String? errorKey;

  const StudentsState({
    this.status = StudentsStatus.initial,
    this.students = const [],
    this.progress = const [],
    this.search = '',
    this.isAdding = false,
    this.errorKey,
  });

  List<StudentModel> get filtered {
    if (search.isEmpty) return students;
    final q = search.toLowerCase();
    return students.where((s) =>
        s.name.toLowerCase().contains(q) || (s.phone ?? '').contains(q)).toList();
  }

  ProgressModel? progressFor(String studentId) =>
      progress.where((p) => p.studentId == studentId).firstOrNull;

  StudentsState copyWith({
    StudentsStatus? status,
    List<StudentModel>? students,
    List<ProgressModel>? progress,
    String? search,
    bool? isAdding,
    String? errorKey,
  }) =>
      StudentsState(
        status: status ?? this.status,
        students: students ?? this.students,
        progress: progress ?? this.progress,
        search: search ?? this.search,
        isAdding: isAdding ?? this.isAdding,
        errorKey: errorKey,
      );

  @override
  List<Object?> get props => [status, students, progress, search, isAdding, errorKey];
}
