import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/service_locator.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/presentation/cubit/app_preferences_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await setupServiceLocator();

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

class NurHifzApp extends StatelessWidget {
  const NurHifzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AppPreferencesCubit>(),
      child: BlocBuilder<AppPreferencesCubit, AppPreferencesState>(
        builder: (context, prefs) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'app_name'.tr(),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: prefs.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routerConfig: createRouter(),
          );
        },
      ),
    );
  }
}
