import '../data_source/attendance_remote_data_source.dart';
import '../models/attendance_model.dart';

class AttendanceRepo {
  final AttendanceRemoteDataSource _dataSource;

  AttendanceRepo(this._dataSource);

  Future<List<AttendanceModel>> getAll({int limit = 200}) =>
      _dataSource.getAll(limit: limit);

  Future<List<AttendanceModel>> getByDate(String date) =>
      _dataSource.getByDate(date);

  Future<void> saveAttendance({
    required String studentId,
    required String date,
    required String status,
  }) =>
      _dataSource.saveAttendance(
        studentId: studentId,
        date: date,
        status: status,
      );
}
