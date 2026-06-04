import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../students/data/repos/students_repo.dart';
import '../../data/repos/attendance_repo.dart';
import 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final AttendanceRepo _attendanceRepo;
  final StudentsRepo _studentsRepo;

  AttendanceCubit(this._attendanceRepo, this._studentsRepo)
      : super(AttendanceState(selectedDate: _todayStr()));

  static String _todayStr() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> load() async {
    emit(state.copyWith(status: AttendanceStatus.loading));
    try {
      final students = await _studentsRepo.getAll();
      final records = await _attendanceRepo.getAll(limit: 200);
      emit(state.copyWith(
        status: AttendanceStatus.loaded,
        students: students,
        records: records,
      ));
    } catch (_) {
      emit(state.copyWith(
          status: AttendanceStatus.error, errorKey: 'error_unknown'));
    }
  }

  void changeDate(int delta) {
    final current = DateTime.parse(state.selectedDate);
    final next = current.add(Duration(days: delta));
    final dateStr =
        '${next.year}-${next.month.toString().padLeft(2, '0')}-${next.day.toString().padLeft(2, '0')}';
    emit(state.copyWith(selectedDate: dateStr));
  }

  void setDate(String date) {
    emit(state.copyWith(selectedDate: date));
  }

  Future<void> saveAttendance(String studentId, String status) async {
    emit(state.copyWith(isSaving: true));
    try {
      await _attendanceRepo.saveAttendance(
        studentId: studentId,
        date: state.selectedDate,
        status: status,
      );
      final records = await _attendanceRepo.getAll(limit: 200);
      emit(state.copyWith(isSaving: false, records: records));
    } catch (_) {
      emit(state.copyWith(isSaving: false, errorKey: 'error_unknown'));
    }
  }
}
