import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/student_model.dart';

class StudentsRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  StudentsRemoteDataSource(this._firestore, this._auth);

  CollectionReference get _collection => _firestore.collection('students');
  String get _currentUserId => _auth.currentUser!.uid;

  Future<List<StudentModel>> getAll() async {
    final snap = await _collection
        .where('teacher_id', isEqualTo: _currentUserId)
        .orderBy('created_at', descending: true)
        .get();
    return snap.docs.map(StudentModel.fromFirestore).toList();
  }

  Future<StudentModel> create(Map<String, dynamic> data) async {
    final doc = await _collection.add({
      ...data,
      'teacher_id': _currentUserId,
      'created_at': FieldValue.serverTimestamp(),
    });
    final snap = await doc.get();
    return StudentModel.fromFirestore(snap);
  }

  Future<void> update(String id, Map<String, dynamic> data) {
    return _collection.doc(id).update(data);
  }

  Future<void> delete(String id) => _collection.doc(id).delete();
}
