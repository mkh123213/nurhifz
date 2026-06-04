import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  FirebaseFirestore get instance => _db;

  CollectionReference<Map<String, dynamic>> collection(String path) =>
      _db.collection(path);

  DocumentReference<Map<String, dynamic>> doc(String path) => _db.doc(path);

  Future<DocumentSnapshot<Map<String, dynamic>>> getDoc(String path) =>
      _db.doc(path).get();

  Future<QuerySnapshot<Map<String, dynamic>>> getCollection(
    String path, {
    Query<Map<String, dynamic>> Function(CollectionReference<Map<String, dynamic>>)? queryBuilder,
    int? limit,
  }) {
    Query<Map<String, dynamic>> query = _db.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(_db.collection(path));
    }
    if (limit != null) query = query.limit(limit);
    return query.get();
  }

  Future<DocumentReference<Map<String, dynamic>>> addDoc(
    String collectionPath,
    Map<String, dynamic> data,
  ) {
    return _db.collection(collectionPath).add({
      ...data,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> setDoc(
    String docPath,
    Map<String, dynamic> data, {
    bool merge = false,
  }) {
    return _db.doc(docPath).set(data, SetOptions(merge: merge));
  }

  Future<void> updateDoc(
    String docPath,
    Map<String, dynamic> data,
  ) {
    return _db.doc(docPath).update({
      ...data,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteDoc(String docPath) => _db.doc(docPath).delete();

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDoc(String path) =>
      _db.doc(path).snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection(
    String path, {
    Query<Map<String, dynamic>> Function(CollectionReference<Map<String, dynamic>>)? queryBuilder,
  }) {
    if (queryBuilder != null) {
      return queryBuilder(_db.collection(path)).snapshots();
    }
    return _db.collection(path).snapshots();
  }

  Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) handler,
  ) {
    return _db.runTransaction(handler);
  }

  WriteBatch batch() => _db.batch();
}
