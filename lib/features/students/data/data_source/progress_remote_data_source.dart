import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/progress_model.dart';

class ProgressRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProgressRemoteDataSource(this._firestore);

  CollectionReference get _collection => _firestore.collection('progress');

  Future<List<ProgressModel>> getAll() async {
    final snap = await _collection.get();
    return snap.docs.map(ProgressModel.fromFirestore).toList();
  }

  Future<ProgressModel?> getByStudent(String studentId) async {
    final snap = await _collection
        .where('student_id', isEqualTo: studentId)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return ProgressModel.fromFirestore(snap.docs.first);
  }

  Future<void> upsert(String studentId, Map<String, dynamic> data) async {
    final snap = await _collection
        .where('student_id', isEqualTo: studentId)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) {
      await _collection.add(data);
    } else {
      await snap.docs.first.reference.update(data);
    }
  }
}
