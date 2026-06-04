import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/session_model.dart';

class SessionsRemoteDataSource {
  final FirebaseFirestore _firestore;

  SessionsRemoteDataSource(this._firestore);

  CollectionReference get _collection => _firestore.collection('sessions');

  Future<List<SessionModel>> getAll({int limit = 100}) async {
    final snap =
        await _collection.orderBy('date', descending: true).limit(limit).get();
    return snap.docs.map(SessionModel.fromFirestore).toList();
  }

  Future<List<SessionModel>> getByStudent(String studentId) async {
    final snap = await _collection
        .where('student_id', isEqualTo: studentId)
        .orderBy('date', descending: true)
        .get();
    return snap.docs.map(SessionModel.fromFirestore).toList();
  }

  Future<SessionModel> create(Map<String, dynamic> data) async {
    final doc = await _collection.add(data);
    final snap = await doc.get();
    return SessionModel.fromFirestore(snap);
  }
}
