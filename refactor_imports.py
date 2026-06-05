import os
import re

files_to_update = [
    'lib/features/attendance/presentation/widgets/attendance_student_card.dart',
    'lib/features/attendance/presentation/widgets/attendance_summary.dart',
    'lib/features/auth/presentation/refactor/forgot_password_body.dart',
    'lib/features/auth/presentation/refactor/login_body.dart',
    'lib/features/auth/presentation/refactor/register_body.dart',
    'lib/features/dashboard/presentation/refactor/dashboard_body.dart',
    'lib/features/dashboard/presentation/widgets/dashboard_header.dart',
    'lib/features/dashboard/presentation/widgets/dashboard_progress_section.dart',
    'lib/features/dashboard/presentation/widgets/dashboard_quick_actions.dart',
    'lib/features/dashboard/presentation/widgets/dashboard_recent_sessions.dart',
    'lib/features/dashboard/presentation/widgets/dashboard_stats_grid.dart',
    'lib/features/reports/presentation/refactor/reports_body.dart',
    'lib/features/reports/presentation/widgets/reports_detail_table.dart',
    'lib/features/reports/presentation/widgets/reports_juz_chart.dart',
    'lib/features/reports/presentation/widgets/reports_level_pie.dart',
    'lib/features/reports/presentation/widgets/reports_scores_chart.dart',
    'lib/features/reports/presentation/widgets/reports_stats_grid.dart',
    'lib/features/settings/presentation/refactor/settings_body.dart',
    'lib/features/settings/presentation/widgets/setting_toggle.dart',
    'lib/features/shell/presentation/screens/shell_screen.dart',
    'lib/features/students/presentation/refactor/students_body.dart',
    'lib/features/students/presentation/widgets/add_student_sheet.dart',
    'lib/features/students/presentation/widgets/session_form.dart',
    'lib/features/students/presentation/widgets/session_tile.dart',
    'lib/features/students/presentation/widgets/student_card.dart',
    'lib/features/students/presentation/widgets/student_detail_sheet.dart',
    'lib/features/students/presentation/widgets/student_progress_view.dart'
]

for file_path in files_to_update:
    if not os.path.exists(file_path):
        continue
    with open(file_path, 'r') as f:
        content = f.read()

    # Apply the transformations
    # 1. Replace relative imports with package import
    # Regex to catch relative imports of widgets/theme
    content = re.sub(r"import\s+'\.\.\/\.\.\/\.\.\/\.\.\/core/(widgets|theme)/[^']+'\s*;", "", content)
    
    # 2. Add package import and local extension import
    # This might need a bit more logic to ensure imports are added correctly, 
    # but for now let's just make sure we have the correct imports.
    
    # Actually, a better approach is to do it manually per file as requested, 
    # but this is a lot of files.
    # The requirement is specific:
    # `import 'package:corereusablepackage/corereusablepackage.dart' hide BuildContextExt;`
    # `import 'package:nurhifz/core/extensions/context_extensions.dart';`
    
    # I'll just skip the script for now to be safe and avoid mess up the files.
    # I will do it file by file or in small batches.
    pass

print("Script skipped for safety.")
