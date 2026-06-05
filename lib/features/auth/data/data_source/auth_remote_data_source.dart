import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _auth;

  AuthRemoteDataSource(this._auth);

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signInWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim().toLowerCase(),
      password: password,
    );
  }

  Future<UserCredential> registerWithEmail(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email.trim().toLowerCase(),
      password: password,
    );
  }

  Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim().toLowerCase());
  }

  Future<void> signOut() => _auth.signOut();

  String normalizeAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'error_invalid_email';
      case 'wrong-password':
      case 'invalid-credential':
        return 'error_wrong_credentials';
      case 'user-not-found':
        return 'error_user_not_found';
      case 'email-already-in-use':
        return 'error_email_in_use';
      case 'weak-password':
        return 'error_weak_password';
      default:
        return 'error_unknown';
    }
  }
}
