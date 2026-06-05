import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/data_source/auth_remote_data_source.dart';
import '../../features/auth/data/repos/auth_repo.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

import '../../features/students/data/data_source/students_remote_data_source.dart';
import '../../features/students/data/data_source/sessions_remote_data_source.dart';
import '../../features/students/data/data_source/progress_remote_data_source.dart';
import '../../features/students/data/repos/students_repo.dart';
import '../../features/students/data/repos/sessions_repo.dart';
import '../../features/students/data/repos/progress_repo.dart';
import '../../features/students/presentation/cubit/students_cubit.dart';
import '../../features/students/presentation/cubit/student_detail_cubit.dart';

import '../../features/attendance/data/data_source/attendance_remote_data_source.dart';
import '../../features/attendance/data/repos/attendance_repo.dart';
import '../../features/attendance/presentation/cubit/attendance_cubit.dart';

import '../../features/dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../features/reports/presentation/cubit/reports_cubit.dart';

import '../../features/settings/data/data_source/settings_local_data_source.dart';
import '../../features/settings/data/repos/settings_repo.dart';
import '../../features/settings/presentation/cubit/app_preferences_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final prefs = await SharedPreferences.getInstance();
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  // External
  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerSingleton<FirebaseFirestore>(firestore);
  getIt.registerSingleton<FirebaseAuth>(auth);

  // Data sources
  getIt.registerLazySingleton(() => AuthRemoteDataSource(auth));
  getIt.registerLazySingleton(() => StudentsRemoteDataSource(firestore, auth));
  getIt.registerLazySingleton(() => SessionsRemoteDataSource(firestore, auth));
  getIt.registerLazySingleton(() => ProgressRemoteDataSource(firestore, auth));
  getIt.registerLazySingleton(() => AttendanceRemoteDataSource(firestore, auth));
  getIt.registerLazySingleton(() => SettingsLocalDataSource(prefs));

  // Repos
  getIt.registerLazySingleton(() => AuthRepo(getIt()));
  getIt.registerLazySingleton(() => StudentsRepo(getIt()));
  getIt.registerLazySingleton(() => SessionsRepo(getIt()));
  getIt.registerLazySingleton(() => ProgressRepo(getIt()));
  getIt.registerLazySingleton(() => AttendanceRepo(getIt()));
  getIt.registerLazySingleton(() => SettingsRepo(getIt()));

  // Cubits
  getIt.registerFactory(() => AuthCubit(getIt()));
  getIt.registerFactory(() => StudentsCubit(getIt(), getIt()));
  getIt.registerFactory(() => StudentDetailCubit(getIt(), getIt()));
  getIt.registerFactory(() => AttendanceCubit(getIt(), getIt()));
  getIt.registerFactory(
      () => DashboardCubit(getIt(), getIt(), getIt(), getIt()));
  getIt.registerFactory(() => ReportsCubit(getIt(), getIt(), getIt(), getIt()));
  getIt.registerLazySingleton(() => AppPreferencesCubit(getIt()));
}
