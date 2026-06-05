import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/progress_model.dart';

class ProgressRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ProgressRemoteDataSource(this._firestore, this._auth);

  CollectionReference get _collection => _firestore.collection('progress');
  String get _currentUserId => _auth.currentUser!.uid;

  Future<List<ProgressModel>> getAll() async {
    final snap = await _collection
        .where('teacher_id', isEqualTo: _currentUserId)
        .get();
    return snap.docs.map(ProgressModel.fromFirestore).toList();
  }

  Future<ProgressModel?> getByStudent(String studentId) async {
    final snap = await _collection
        .where('teacher_id', isEqualTo: _currentUserId)
        .where('student_id', isEqualTo: studentId)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return ProgressModel.fromFirestore(snap.docs.first);
  }

  Future<void> upsert(String studentId, Map<String, dynamic> data) async {
    final snap = await _collection
        .where('teacher_id', isEqualTo: _currentUserId)
        .where('student_id', isEqualTo: studentId)
        .limit(1)
        .get();
    
    final updatedData = {
      ...data,
      'teacher_id': _currentUserId,
    };

    if (snap.docs.isEmpty) {
      await _collection.add(updatedData);
    } else {
      await snap.docs.first.reference.update(updatedData);
    }
  }
}
