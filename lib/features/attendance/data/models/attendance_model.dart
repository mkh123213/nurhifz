import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  final String id;
  final String studentId;
  final String? teacherId;
  final String sessionDate;
  final String status;

  const AttendanceModel({
    required this.id,
    required this.studentId,
    this.teacherId,
    required this.sessionDate,
    required this.status,
  });

  factory AttendanceModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>? ?? {};
    return AttendanceModel(
      id: doc.id,
      studentId: d['student_id'] as String? ?? '',
      teacherId: d['teacher_id'] as String?,
      sessionDate: d['session_date'] as String? ?? '',
      status: d['status'] as String? ?? 'absent',
    );
  }

  Map<String, dynamic> toFirestore() => {
        'student_id': studentId,
        if (teacherId != null) 'teacher_id': teacherId,
        'session_date': sessionDate,
        'status': status,
        'created_at': FieldValue.serverTimestamp(),
      };
}
