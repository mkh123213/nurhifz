import 'package:equatable/equatable.dart';
import '../../../attendance/data/models/attendance_model.dart';
import '../../../students/data/models/progress_model.dart';
import '../../../students/data/models/session_model.dart';
import '../../../students/data/models/student_model.dart';

enum ReportsStatus { initial, loading, loaded, error }

class StudentStat {
  final String name;
  final int avgScore;
  final int juzCompleted;
  final int presentPct;
  final int sessionCount;

  const StudentStat({
    required this.name,
    required this.avgScore,
    required this.juzCompleted,
    required this.presentPct,
    required this.sessionCount,
  });
}

class ReportsState extends Equatable {
  final ReportsStatus status;
  final List<StudentModel> students;
  final List<SessionModel> sessions;
  final List<ProgressModel> progress;
  final List<AttendanceModel> attendance;
  final String? errorKey;

  const ReportsState({
    this.status = ReportsStatus.initial,
    this.students = const [],
    this.sessions = const [],
    this.progress = const [],
    this.attendance = const [],
    this.errorKey,
  });

  int get overallAvg {
    if (sessions.isEmpty) return 0;
    return (sessions.fold<int>(0, (s, r) => s + r.score) / sessions.length).round();
  }

  String get bestStudentName {
    if (studentStats.isEmpty) return '—';
    final sorted = [...studentStats]..sort((a, b) => b.avgScore.compareTo(a.avgScore));
    return sorted.first.name;
  }

  List<StudentStat> get studentStats {
    return students.map((s) {
      final ss = sessions.where((r) => r.studentId == s.id).toList();
      final avg = ss.isEmpty
          ? 0
          : (ss.fold<int>(0, (a, r) => a + r.score) / ss.length).round();
      final prog = progress.where((p) => p.studentId == s.id).firstOrNull;
      final att = attendance.where((a) => a.studentId == s.id).toList();
      final presentPct = att.isEmpty
          ? 0
          : ((att.where((a) => a.status == 'present').length / att.length) * 100).round();
      return StudentStat(
        name: s.name.split(' ').first,
        avgScore: avg,
        juzCompleted: prog?.juzCompleted ?? 0,
        presentPct: presentPct,
        sessionCount: ss.length,
      );
    }).toList();
  }

  int levelCount(String level) =>
      students.where((s) => s.level == level).length;

  ReportsState copyWith({
    ReportsStatus? status,
    List<StudentModel>? students,
    List<SessionModel>? sessions,
    List<ProgressModel>? progress,
    List<AttendanceModel>? attendance,
    String? errorKey,
  }) =>
      ReportsState(
        status: status ?? this.status,
        students: students ?? this.students,
        sessions: sessions ?? this.sessions,
        progress: progress ?? this.progress,
        attendance: attendance ?? this.attendance,
        errorKey: errorKey,
      );

  @override
  List<Object?> get props => [status, students, sessions, progress, attendance, errorKey];
}
