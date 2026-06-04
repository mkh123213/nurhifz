import 'package:firebase_auth/firebase_auth.dart';

class ErrorMapper {
  ErrorMapper._();

  static String fromException(Object error) {
    if (error is FirebaseAuthException) return _mapFirebaseAuth(error.code);
    if (error is FirebaseException) return _mapFirebase(error.code);
    return 'error_unknown';
  }

  static String _mapFirebaseAuth(String code) {
    switch (code) {
      case 'user-not-found':
        return 'error_user_not_found';
      case 'wrong-password':
        return 'error_wrong_password';
      case 'invalid-credential':
        return 'error_invalid_credential';
      case 'email-already-in-use':
        return 'error_email_in_use';
      case 'weak-password':
        return 'error_weak_password';
      case 'invalid-email':
        return 'error_invalid_email';
      case 'user-disabled':
        return 'error_user_disabled';
      case 'too-many-requests':
        return 'error_too_many_requests';
      case 'network-request-failed':
        return 'error_network';
      case 'requires-recent-login':
        return 'error_requires_recent_login';
      default:
        return 'error_auth_unknown';
    }
  }

  static String _mapFirebase(String code) {
    switch (code) {
      case 'permission-denied':
        return 'error_permission_denied';
      case 'not-found':
        return 'error_not_found';
      case 'unavailable':
        return 'error_service_unavailable';
      case 'cancelled':
        return 'error_cancelled';
      default:
        return 'error_unknown';
    }
  }
}
