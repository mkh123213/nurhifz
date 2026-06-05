import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../attendance/data/repos/attendance_repo.dart';
import '../../../students/data/repos/progress_repo.dart';
import '../../../students/data/repos/sessions_repo.dart';
import '../../../students/data/repos/students_repo.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final StudentsRepo _studentsRepo;
  final SessionsRepo _sessionsRepo;
  final AttendanceRepo _attendanceRepo;
  final ProgressRepo _progressRepo;

  DashboardCubit(
    this._studentsRepo,
    this._sessionsRepo,
    this._attendanceRepo,
    this._progressRepo,
  ) : super(const DashboardState());

  Future<void> load() async {
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      final students = await _studentsRepo.getAll();
      final sessions = await _sessionsRepo.getAll(limit: 20);
      final progress = await _progressRepo.getAll();
      final attendance = await _attendanceRepo.getAll(limit: 30);
      emit(state.copyWith(
        status: DashboardStatus.loaded,
        students: students,
        sessions: sessions,
        progress: progress,
        attendance: attendance,
      ));
    } catch (_) {
      emit(state.copyWith(
          status: DashboardStatus.error, errorKey: 'error_unknown'));
    }
  }
}
