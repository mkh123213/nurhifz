import 'package:equatable/equatable.dart';
import '../../data/models/session_model.dart';
import '../../data/models/progress_model.dart';

enum DetailStatus { initial, loading, loaded, error }

class StudentDetailState extends Equatable {
  final DetailStatus status;
  final List<SessionModel> sessions;
  final ProgressModel? progress;
  final bool isAddingSession;
  final String? errorKey;

  const StudentDetailState({
    this.status = DetailStatus.initial,
    this.sessions = const [],
    this.progress,
    this.isAddingSession = false,
    this.errorKey,
  });

  StudentDetailState copyWith({
    DetailStatus? status,
    List<SessionModel>? sessions,
    ProgressModel? progress,
    bool? isAddingSession,
    String? errorKey,
  }) =>
      StudentDetailState(
        status: status ?? this.status,
        sessions: sessions ?? this.sessions,
        progress: progress ?? this.progress,
        isAddingSession: isAddingSession ?? this.isAddingSession,
        errorKey: errorKey,
      );

  @override
  List<Object?> get props => [status, sessions, progress, isAddingSession, errorKey];
}
