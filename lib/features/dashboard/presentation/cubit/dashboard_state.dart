import 'package:equatable/equatable.dart';
import '../../../students/data/models/student_model.dart';
import '../../../students/data/models/session_model.dart';
import '../../../students/data/models/progress_model.dart';
import '../../../attendance/data/models/attendance_model.dart';

enum DashboardStatus { initial, loading, loaded, error }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final List<StudentModel> students;
  final List<SessionModel> sessions;
  final List<ProgressModel> progress;
  final List<AttendanceModel> attendance;
  final String? errorKey;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.students = const [],
    this.sessions = const [],
    this.progress = const [],
    this.attendance = const [],
    this.errorKey,
  });

  int get presentToday {
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return attendance
        .where((a) => a.sessionDate == todayStr && a.status == 'present')
        .length;
  }

  int get avgScore {
    if (sessions.isEmpty) return 0;
    return (sessions.fold<int>(0, (s, r) => s + r.score) / sessions.length)
        .round();
  }

  int get totalJuz => progress.fold<int>(0, (s, p) => s + p.juzCompleted);

  List<SessionModel> get recentSessions => sessions.take(5).toList();

  DashboardState copyWith({
    DashboardStatus? status,
    List<StudentModel>? students,
    List<SessionModel>? sessions,
    List<ProgressModel>? progress,
    List<AttendanceModel>? attendance,
    String? errorKey,
  }) =>
      DashboardState(
        status: status ?? this.status,
        students: students ?? this.students,
        sessions: sessions ?? this.sessions,
        progress: progress ?? this.progress,
        attendance: attendance ?? this.attendance,
        errorKey: errorKey,
      );

  @override
  List<Object?> get props =>
      [status, students, sessions, progress, attendance, errorKey];
}
