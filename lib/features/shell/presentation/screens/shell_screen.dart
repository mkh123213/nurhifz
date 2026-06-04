import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';

class ShellScreen extends StatelessWidget {
  final Widget child;

  const ShellScreen({super.key, required this.child});

  static final _tabs = [
    (AppRoutes.dashboard, Icons.dashboard_outlined, 'home'),
    (AppRoutes.students, Icons.people_outline, 'students'),
    (AppRoutes.attendance, Icons.calendar_today_outlined, 'attendance_tab'),
    (AppRoutes.reports, Icons.bar_chart_outlined, 'reports_tab'),
    (AppRoutes.settings, Icons.settings_outlined, 'settings_tab'),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _tabs.indexWhere((t) => t.$1 == location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.cardBg.withValues(alpha: 0.92),
          border: Border(top: BorderSide(color: context.cardBorder)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_tabs.length, (i) {
                final (route, icon, labelKey) = _tabs[i];
                final active = i == currentIndex;
                return _NavItem(
                  icon: icon,
                  label: labelKey.tr(),
                  active: active,
                  onTap: () => context.go(route),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: active ? AppColors.gradient : null,
                borderRadius: BorderRadius.circular(12),
                boxShadow: active
                    ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.5), blurRadius: 16)]
                    : null,
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: 22,
                color: active ? Colors.white : context.mutedFg,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: active ? AppColors.primary : context.mutedFg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
