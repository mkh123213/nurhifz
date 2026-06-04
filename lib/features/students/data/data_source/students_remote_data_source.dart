import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student_model.dart';

class StudentsRemoteDataSource {
  final FirebaseFirestore _firestore;

  StudentsRemoteDataSource(this._firestore);

  CollectionReference get _collection => _firestore.collection('students');

  Future<List<StudentModel>> getAll() async {
    final snap = await _collection.orderBy('created_at', descending: true).get();
    return snap.docs.map(StudentModel.fromFirestore).toList();
  }

  Future<StudentModel> create(Map<String, dynamic> data) async {
    final doc = await _collection.add({
      ...data,
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
