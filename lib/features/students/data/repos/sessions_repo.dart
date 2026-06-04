import '../data_source/sessions_remote_data_source.dart';
import '../models/session_model.dart';

class SessionsRepo {
  final SessionsRemoteDataSource _dataSource;

  SessionsRepo(this._dataSource);

  Future<List<SessionModel>> getAll({int limit = 100}) =>
      _dataSource.getAll(limit: limit);

  Future<List<SessionModel>> getByStudent(String studentId) =>
      _dataSource.getByStudent(studentId);

  Future<SessionModel> create(Map<String, dynamic> data) =>
      _dataSource.create(data);
}
