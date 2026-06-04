import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/service_locator.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/lang_keys.dart';
import 'features/settings/presentation/cubit/app_preferences_cubit.dart';

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
            title: LangKeys.appName.tr(),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: prefs.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
