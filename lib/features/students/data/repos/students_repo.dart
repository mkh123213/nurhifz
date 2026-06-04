import '../data_source/students_remote_data_source.dart';
import '../models/student_model.dart';

class StudentsRepo {
  final StudentsRemoteDataSource _dataSource;

  StudentsRepo(this._dataSource);

  Future<List<StudentModel>> getAll() => _dataSource.getAll();

  Future<StudentModel> create(Map<String, dynamic> data) =>
      _dataSource.create(data);

  Future<void> update(String id, Map<String, dynamic> data) =>
      _dataSource.update(id, data);

  Future<void> delete(String id) => _dataSource.delete(id);
}
