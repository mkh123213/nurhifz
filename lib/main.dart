import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/di/service_locator.dart';
import 'features/settings/presentation/cubit/app_preferences_cubit.dart';
import 'nur_hifz_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await setupServiceLocator();
//
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: Locale(getIt<AppPreferencesCubit>().state.locale),
      child: const NurHifzApp(),
    ),
  );
}
