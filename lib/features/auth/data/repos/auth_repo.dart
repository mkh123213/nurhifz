import 'package:firebase_auth/firebase_auth.dart';
import '../data_source/auth_remote_data_source.dart';

class AuthRepo {
  final AuthRemoteDataSource _dataSource;

  AuthRepo(this._dataSource);

  User? get currentUser => _dataSource.currentUser;

  Stream<User?> get authStateChanges => _dataSource.authStateChanges;

  Future<UserCredential> signIn(String email, String password) =>
      _dataSource.signInWithEmail(email, password);

  Future<UserCredential> register(String email, String password) =>
      _dataSource.registerWithEmail(email, password);

  Future<void> sendPasswordReset(String email) =>
      _dataSource.sendPasswordReset(email);

  Future<void> signOut() => _dataSource.signOut();

  String normalizeError(FirebaseAuthException e) =>
      _dataSource.normalizeAuthError(e);
}
