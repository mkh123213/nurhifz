import 'package:nurhifz/core/localization/lang_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/app_routes.dart';


import '../cubit/app_preferences_cubit.dart';
import '../widgets/setting_row.dart';
import '../widgets/setting_toggle.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppPreferencesCubit, AppPreferencesState>(
      builder: (context, prefs) {
        final cubit = context.read<AppPreferencesCubit>();
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              _profileCard(context),
              const SizedBox(height: 16),
              _appearanceSection(context, prefs, cubit),
              const SizedBox(height: 16),
              _notificationsSection(context, prefs, cubit),
              const SizedBox(height: 16),
              _languageSection(context, prefs, cubit),
              const SizedBox(height: 16),
              _quickLinksSection(context),
              const SizedBox(height: 16),
              _aboutSection(context),
            ],
          ),
        );
      },
    );
  }

  Widget _profileCard(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const AppAvatar(name: 'م', size: 56),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LangKeys.teacher.tr(),
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              Text(
                LangKeys.circleTeacher.tr(),
                style: TextStyle(fontSize: 12, color: context.mutedFg),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  LangKeys.teacherBadge.tr(),
                  style:
                      const TextStyle(fontSize: 12, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _appearanceSection(
    BuildContext context,
    AppPreferencesState prefs,
    AppPreferencesCubit cubit,
  ) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LangKeys.appearance.tr(),
            style: TextStyle(
                fontSize: 11, color: context.mutedFg, letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          SettingRow(
            icon: prefs.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            iconColor: prefs.isDarkMode ? AppColors.primary : AppColors.yellow,
            label: LangKeys.darkMode.tr(),
            sublabel: prefs.isDarkMode
                ? LangKeys.enabled.tr()
                : LangKeys.disabled.tr(),
            trailing: SettingToggle(
              value: prefs.isDarkMode,
              onChanged: cubit.toggleDarkMode,
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationsSection(
    BuildContext context,
    AppPreferencesState prefs,
    AppPreferencesCubit cubit,
  ) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LangKeys.notifications.tr(),
            style: TextStyle(
                fontSize: 11, color: context.mutedFg, letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          SettingRow(
            icon: Icons.notifications_outlined,
            iconColor: AppColors.purple,
            label: LangKeys.notifications.tr(),
            sublabel: LangKeys.receiveSessionAlerts.tr(),
            trailing: SettingToggle(
              value: prefs.notifications,
              onChanged: cubit.toggleNotifications,
            ),
          ),
        ],
      ),
    );
  }

  Widget _languageSection(
    BuildContext context,
    AppPreferencesState prefs,
    AppPreferencesCubit cubit,
  ) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LangKeys.language.tr(),
            style: TextStyle(
                fontSize: 11, color: context.mutedFg, letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          SettingRow(
            icon: Icons.language,
            iconColor: AppColors.green,
            label: LangKeys.appLanguage.tr(),
            sublabel: prefs.locale == 'ar'
                ? LangKeys.arabic.tr()
                : LangKeys.english.tr(),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final l in ['ar', 'en'])
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 4),
                    child: GestureDetector(
                      onTap: () {
                        cubit.setLocale(l);
                        context.setLocale(Locale(l));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient:
                              prefs.locale == l ? AppColors.gradient : null,
                          color: prefs.locale == l ? null : context.mutedBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          l == 'ar' ? 'عربي' : 'EN',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: prefs.locale == l
                                ? Colors.white
                                : context.mutedFg,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickLinksSection(BuildContext context) {
    final links = [
      (
        AppRoutes.students,
        Icons.person_outline,
        AppColors.primary,
        LangKeys.manageStudents.tr()
      ),
      (
        AppRoutes.attendance,
        Icons.calendar_today_outlined,
        AppColors.green,
        LangKeys.attendanceRecord.tr()
      ),
      (
        AppRoutes.reports,
        Icons.info_outline,
        AppColors.yellow,
        LangKeys.detailedReports.tr()
      ),
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LangKeys.quickLinks.tr(),
            style: TextStyle(
                fontSize: 11, color: context.mutedFg, letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          for (final (route, icon, color, label) in links)
            InkWell(
              onTap: () => context.go(route),
              borderRadius: BorderRadius.circular(12),
              child: SettingRow(
                icon: icon,
                iconColor: color,
                label: label,
                trailing:
                    Icon(Icons.chevron_left, size: 18, color: context.mutedFg),
              ),
            ),
        ],
      ),
    );
  }

  Widget _aboutSection(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: AppColors.gradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 16,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              'ح',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            LangKeys.appName.tr(),
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            LangKeys.quranSystemDesc.tr(),
            style: TextStyle(fontSize: 12, color: context.mutedFg),
          ),
          const SizedBox(height: 4),
          Text(
            'version'.tr(namedArgs: {'v': '1.0.0'}),
            style: TextStyle(fontSize: 12, color: context.mutedFg),
          ),
        ],
      ),
    );
  }
}

