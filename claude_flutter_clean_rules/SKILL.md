---
name: flutter-clean-refactor
summary: Enforce clean Flutter architecture — dumb UI, Cubit-owned behavior, data-source-owned persistence, corereusablepackage components, small files, strict layer boundaries.
---

# Flutter Clean Refactor Skill

Enforce clean architecture in Flutter projects. All reusable components live in the `corereusablepackage` Flutter package.

## Architecture

```
lib/features/<feature>/
  data/
    data_source/
    models/
    repos/
  presentation/
    cubit/
    refactor/
    screens/
    widgets/
```

**Forbidden:** `domain/`, `entities/`, `use_cases/`, `repo_interface/`, `repo_impl/`.

## Core Package

```yaml
dependencies:
  corereusablepackage:
    path: ../corereusablepackage
```

```dart
import 'package:corereusablepackage/corereusablepackage.dart';
```

**Theme:** `AppTheme.dark()` / `.light()` | `AppColors` | `BuildContextExt`
**Widgets:** `AppButton` | `AppTextField` | `AppCard` | `AppAvatar` | `AppEmptyState` | `AppErrorState` | `AppLoadingOverlay` | `SettingRow` | `SettingToggle`
**Services:** `showToast()` | `AppCacheService` | `AppPreferencesCubit` | `PreferencesRepo` | `PreferencesLocalDataSource`
**Routing:** `noTransitionPage()`

## Layer Rules

| Layer | Owns | Must Not |
|-------|------|----------|
| **UI** | Display state, forward actions | Backend calls, calculations, filtering, error mapping, status logic |
| **Cubit** | Load/refresh, filters, selected values, error keys, UI-ready data | Use BuildContext, call UI functions |
| **Data Source** | Backend/local calls, validation, normalization, transactions, duplicates, status transitions | Depend on presentation layer |
| **Repo** | Delegate to data sources | Contain logic |

## File Size

| Type | Target | Max |
|------|--------|-----|
| Screen | 30-70 | — |
| Refactor / Widget | 80-120 | 150 |
| Cubit | — | No fixed limit |

## Rules

- **Imports:** Relative inside `lib/`. No `package:project_name/...` imports.
- **Localization:** All user-facing text via `'key'.tr()` or `context.translate(LangKeys.key)`. No hardcoded strings.
- **Theme:** Use package theme and colors. Support light/dark mode.
- **Navigation:** `push` for drill-down, `go` for branch replacement.
- **Errors:** Normalize to stable keys in data source. Cubit emits key. UI translates and shows toast.
- **Bug fixes:** Fix root cause. Rebuild UI from Cubit state, never from stale data.

## Pre-Delivery Checks

- [ ] No package imports for project-internal files
- [ ] No backend calls in UI / common widgets
- [ ] No missing localization keys
- [ ] No UI file over 150 lines without justification
- [ ] JSON translation files valid
- [ ] `build_runner` requirement stated
- [ ] `flutter analyze` result stated
