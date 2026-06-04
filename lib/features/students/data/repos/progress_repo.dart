import '../data_source/progress_remote_data_source.dart';
import '../models/progress_model.dart';

class ProgressRepo {
  final ProgressRemoteDataSource _dataSource;

  ProgressRepo(this._dataSource);

  Future<List<ProgressModel>> getAll() => _dataSource.getAll();

  Future<ProgressModel?> getByStudent(String studentId) =>
      _dataSource.getByStudent(studentId);

  Future<void> upsert(String studentId, Map<String, dynamic> data) =>
      _dataSource.upsert(studentId, data);
}
