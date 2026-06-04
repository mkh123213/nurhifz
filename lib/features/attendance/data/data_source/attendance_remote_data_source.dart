import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/attendance_model.dart';

class AttendanceRemoteDataSource {
  final FirebaseFirestore _firestore;

  AttendanceRemoteDataSource(this._firestore);

  CollectionReference get _collection => _firestore.collection('attendance');

  Future<List<AttendanceModel>> getAll({int limit = 200}) async {
    final snap = await _collection
        .orderBy('session_date', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map(AttendanceModel.fromFirestore).toList();
  }

  Future<List<AttendanceModel>> getByDate(String date) async {
    final snap = await _collection
        .where('session_date', isEqualTo: date)
        .get();
    return snap.docs.map(AttendanceModel.fromFirestore).toList();
  }

  Future<void> saveAttendance({
    required String studentId,
    required String date,
    required String status,
  }) async {
    final snap = await _collection
        .where('student_id', isEqualTo: studentId)
        .where('session_date', isEqualTo: date)
        .limit(1)
        .get();

    final data = <String, dynamic>{
      'student_id': studentId,
      'session_date': date,
      'status': status,
    };

    if (snap.docs.isEmpty) {
      data['created_at'] = FieldValue.serverTimestamp();
      await _collection.add(data);
    } else {
      await snap.docs.first.reference.update({'status': status});
    }
  }
}
