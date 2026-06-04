import 'package:equatable/equatable.dart';

enum AuthStatus { initial, loading, success, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorKey;
  final bool resetSent;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorKey,
    this.resetSent = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorKey,
    bool? resetSent,
  }) =>
      AuthState(
        status: status ?? this.status,
        errorKey: errorKey,
        resetSent: resetSent ?? this.resetSent,
      );

  @override
  List<Object?> get props => [status, errorKey, resetSent];
}
