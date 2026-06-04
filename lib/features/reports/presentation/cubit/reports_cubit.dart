import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../attendance/data/repos/attendance_repo.dart';
import '../../../students/data/repos/progress_repo.dart';
import '../../../students/data/repos/sessions_repo.dart';
import '../../../students/data/repos/students_repo.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final StudentsRepo _studentsRepo;
  final SessionsRepo _sessionsRepo;
  final ProgressRepo _progressRepo;
  final AttendanceRepo _attendanceRepo;

  ReportsCubit(
    this._studentsRepo,
    this._sessionsRepo,
    this._progressRepo,
    this._attendanceRepo,
  ) : super(const ReportsState());

  Future<void> load() async {
    emit(state.copyWith(status: ReportsStatus.loading));
    try {
      final results = await Future.wait([
        _studentsRepo.getAll(),
        _sessionsRepo.getAll(limit: 100),
        _progressRepo.getAll(),
        _attendanceRepo.getAll(limit: 100),
      ]);
      emit(state.copyWith(
        status: ReportsStatus.loaded,
        students: results[0] as dynamic,
        sessions: results[1] as dynamic,
        progress: results[2] as dynamic,
        attendance: results[3] as dynamic,
      ));
    } catch (_) {
      emit(state.copyWith(
          status: ReportsStatus.error, errorKey: 'error_unknown'));
    }
  }
}
