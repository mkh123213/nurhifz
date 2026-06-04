import 'package:equatable/equatable.dart';
import '../../../students/data/models/student_model.dart';
import '../../data/models/attendance_model.dart';

enum AttendanceStatus { initial, loading, loaded, error }

class AttendanceState extends Equatable {
  final AttendanceStatus status;
  final List<StudentModel> students;
  final List<AttendanceModel> records;
  final String selectedDate;
  final bool isSaving;
  final String? errorKey;

  const AttendanceState({
    this.status = AttendanceStatus.initial,
    this.students = const [],
    this.records = const [],
    required this.selectedDate,
    this.isSaving = false,
    this.errorKey,
  });

  List<AttendanceModel> get todayRecords =>
      records.where((r) => r.sessionDate == selectedDate).toList();

  String? statusFor(String studentId) =>
      todayRecords.where((r) => r.studentId == studentId).firstOrNull?.status;

  int countByStatus(String status) =>
      todayRecords.where((r) => r.status == status).length;

  AttendanceState copyWith({
    AttendanceStatus? status,
    List<StudentModel>? students,
    List<AttendanceModel>? records,
    String? selectedDate,
    bool? isSaving,
    String? errorKey,
  }) =>
      AttendanceState(
        status: status ?? this.status,
        students: students ?? this.students,
        records: records ?? this.records,
        selectedDate: selectedDate ?? this.selectedDate,
        isSaving: isSaving ?? this.isSaving,
        errorKey: errorKey,
      );

  @override
  List<Object?> get props => [status, students, records, selectedDate, isSaving, errorKey];
}
