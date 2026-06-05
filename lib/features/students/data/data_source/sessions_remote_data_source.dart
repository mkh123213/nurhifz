import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/session_model.dart';

class SessionsRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  SessionsRemoteDataSource(this._firestore, this._auth);

  CollectionReference get _collection => _firestore.collection('sessions');
  String get _currentUserId => _auth.currentUser!.uid;

  Future<List<SessionModel>> getAll({int limit = 100}) async {
    final snap = await _collection
        .where('teacher_id', isEqualTo: _currentUserId)
        .orderBy('date', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map(SessionModel.fromFirestore).toList();
  }

  Future<List<SessionModel>> getByStudent(String studentId) async {
    final snap = await _collection
        .where('teacher_id', isEqualTo: _currentUserId)
        .where('student_id', isEqualTo: studentId)
        .orderBy('date', descending: true)
        .get();
    return snap.docs.map(SessionModel.fromFirestore).toList();
  }

  Future<SessionModel> create(Map<String, dynamic> data) async {
    final doc = await _collection.add({
      ...data,
      'teacher_id': _currentUserId,
    });
    final snap = await doc.get();
    return SessionModel.fromFirestore(snap);
  }

  Future<void> update(String id, Map<String, dynamic> data) {
    return _collection.doc(id).update(data);
  }
}
