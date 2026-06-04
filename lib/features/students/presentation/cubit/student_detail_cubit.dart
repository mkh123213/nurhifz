import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/progress_repo.dart';
import '../../data/repos/sessions_repo.dart';
import 'student_detail_state.dart';

class StudentDetailCubit extends Cubit<StudentDetailState> {
  final SessionsRepo _sessionsRepo;
  final ProgressRepo _progressRepo;

  StudentDetailCubit(this._sessionsRepo, this._progressRepo)
      : super(const StudentDetailState());

  Future<void> load(String studentId) async {
    emit(state.copyWith(status: DetailStatus.loading));
    try {
      final results = await Future.wait([
        _sessionsRepo.getByStudent(studentId),
        _progressRepo.getByStudent(studentId),
      ]);
      emit(state.copyWith(
        status: DetailStatus.loaded,
        sessions: results[0] as dynamic,
        progress: results[1] as dynamic,
      ));
    } catch (_) {
      emit(state.copyWith(status: DetailStatus.error, errorKey: 'error_unknown'));
    }
  }

  Future<void> addSession(Map<String, dynamic> data) async {
    emit(state.copyWith(isAddingSession: true));
    try {
      final session = await _sessionsRepo.create(data);
      emit(state.copyWith(
        isAddingSession: false,
        sessions: [session, ...state.sessions],
      ));
    } catch (_) {
      emit(state.copyWith(isAddingSession: false, errorKey: 'error_unknown'));
    }
  }
}
