import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/progress_repo.dart';
import '../../data/repos/students_repo.dart';
import 'students_state.dart';

class StudentsCubit extends Cubit<StudentsState> {
  final StudentsRepo _studentsRepo;
  final ProgressRepo _progressRepo;

  StudentsCubit(this._studentsRepo, this._progressRepo)
      : super(const StudentsState());

  Future<void> load() async {
    emit(state.copyWith(status: StudentsStatus.loading));
    try {
      final results = await Future.wait([
        _studentsRepo.getAll(),
        _progressRepo.getAll(),
      ]);
      emit(state.copyWith(
        status: StudentsStatus.loaded,
        students: results[0] as dynamic,
        progress: results[1] as dynamic,
      ));
    } catch (_) {
      emit(state.copyWith(status: StudentsStatus.error, errorKey: 'error_unknown'));
    }
  }

  void updateSearch(String query) {
    emit(state.copyWith(search: query));
  }

  Future<void> addStudent(Map<String, dynamic> data) async {
    emit(state.copyWith(isAdding: true));
    try {
      final student = await _studentsRepo.create(data);
      emit(state.copyWith(
        isAdding: false,
        students: [student, ...state.students],
      ));
    } catch (_) {
      emit(state.copyWith(isAdding: false, errorKey: 'error_unknown'));
    }
  }
}
