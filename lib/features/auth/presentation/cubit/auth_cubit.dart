import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/auth_repo.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _repo;

  AuthCubit(this._repo) : super(const AuthState());

  Future<void> signIn(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _repo.signIn(email, password);
      emit(state.copyWith(status: AuthStatus.success));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorKey: _repo.normalizeError(e),
      ));
    }
  }

  Future<void> register(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _repo.register(email, password);
      emit(state.copyWith(status: AuthStatus.success));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorKey: _repo.normalizeError(e),
      ));
    }
  }

  Future<void> sendPasswordReset(String email) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _repo.sendPasswordReset(email);
      emit(state.copyWith(status: AuthStatus.success, resetSent: true));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorKey: _repo.normalizeError(e),
      ));
    }
  }

  Future<void> signOut() async {
    await _repo.signOut();
    emit(const AuthState());
  }
}
