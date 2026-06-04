$files = @(
    "lib/features/attendance/presentation/widgets/attendance_student_card.dart",
    "lib/features/attendance/presentation/widgets/attendance_summary.dart",
    "lib/features/auth/presentation/refactor/forgot_password_body.dart",
    "lib/features/auth/presentation/refactor/login_body.dart",
    "lib/features/auth/presentation/refactor/register_body.dart",
    "lib/features/dashboard/presentation/refactor/dashboard_body.dart",
    "lib/features/dashboard/presentation/widgets/dashboard_header.dart",
    "lib/features/dashboard/presentation/widgets/dashboard_progress_section.dart",
    "lib/features/dashboard/presentation/widgets/dashboard_quick_actions.dart",
    "lib/features/dashboard/presentation/widgets/dashboard_recent_sessions.dart",
    "lib/features/dashboard/presentation/widgets/dashboard_stats_grid.dart",
    "lib/features/reports/presentation/refactor/reports_body.dart",
    "lib/features/reports/presentation/widgets/reports_detail_table.dart",
    "lib/features/reports/presentation/widgets/reports_juz_chart.dart",
    "lib/features/reports/presentation/widgets/reports_level_pie.dart",
    "lib/features/reports/presentation/widgets/reports_scores_chart.dart",
    "lib/features/reports/presentation/widgets/reports_stats_grid.dart",
    "lib/features/settings/presentation/refactor/settings_body.dart",
    "lib/features/settings/presentation/widgets/setting_toggle.dart",
    "lib/features/shell/presentation/screens/shell_screen.dart",
    "lib/features/students/presentation/refactor/students_body.dart",
    "lib/features/students/presentation/widgets/add_student_sheet.dart",
    "lib/features/students/presentation/widgets/session_form.dart",
    "lib/features/students/presentation/widgets/session_tile.dart",
    "lib/features/students/presentation/widgets/student_card.dart",
    "lib/features/students/presentation/widgets/student_detail_sheet.dart",
    "lib/features/students/presentation/widgets/student_progress_view.dart"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        
        # Replace relative imports
        $content = $content -replace "import '\.\.\/\.\.\/\.\.\/\.\.\/core/(widgets|theme)/[^']+'\s*;", ""
        
        # Replace corereusablepackage import
        if ($content -match "context_extensions\.dart") {
            $content = $content -replace "import 'package:corereusablepackage/corereusablepackage.dart';", "import 'package:corereusablepackage/corereusablepackage.dart' hide BuildContextExt;`nimport 'package:nurhifz/core/extensions/context_extensions.dart';"
        }
        
        # Clean up
        $content = $content -replace "`r`n`r`n`r`n", "`r`n`r`n"
        
        Set-Content $file -Value $content
    }
}
