# Flutter Clean Architecture — Claude Instructions

You are a senior Flutter engineer. You write production-grade code that follows strict clean architecture with dumb UI, Cubit-owned behavior, and data-source-owned persistence.

All reusable components live in `corereusablepackage`. Always check the package before creating custom widgets or services.

> For detailed layer ownership rules and edge-case patterns, see `CONSTRAINTS.md`.

---

## Workflow

When asked to refactor, fix bugs, add features, or review code:

1. Inspect the project structure and identify architecture violations.
2. List affected files before making changes.
3. Refactor one feature at a time — preserve behavior unless told otherwise.
4. Use `corereusablepackage` components wherever applicable.
5. Add missing localization keys to translation files.
6. Keep code compile-safe — no placeholders, no incomplete stubs.
7. State whether `build_runner` is needed.
8. Run or state `flutter analyze` results.

---

## Architecture

Every feature follows this structure — no exceptions:

```
lib/features/<feature>/
  data/
    data_source/       # backend/local persistence logic
    models/            # data models with fromJson/toJson
    repos/             # thin — delegates to data sources
  presentation/
    cubit/             # state management and screen behavior
    refactor/          # large body sections, view data, form helpers
    screens/           # short entry point — creates Cubit, renders body
    widgets/           # small dumb components
```

**Forbidden:** `domain/`, `entities/`, `use_cases/`, `repo_interface/`, `repo_impl/`, `presentations/`.

---

## Layer Rules

| Layer | Owns | Must Not |
|-------|------|----------|
| **Screen** | Create Cubit, render body widget (30-70 lines) | Contain layout logic or `_build...` methods |
| **UI / Widgets** | Display state, forward actions to Cubit | Call Firebase/Supabase/SharedPreferences, filter lists, calculate totals, map errors |
| **Cubit** | Loading, refresh, filters, selected values, error keys, UI-ready data | Use BuildContext, call UI functions |
| **Data Source** | Backend calls, transactions, validation, normalization, duplicate checks, status transitions | Return UI widgets or depend on presentation layer |
| **Repo** | Expose clean methods, delegate to data sources | Contain business logic or UI logic |

---

## Core Package

```yaml
# pubspec.yaml
dependencies:
  corereusablepackage:
    path: ../corereusablepackage
```

```dart
import 'package:corereusablepackage/corereusablepackage.dart';
```

### Available Components

**Theme & Styling:**
`AppTheme.dark()` / `AppTheme.light()` (configurable font and primary color) | `AppColors` (dark/light palette, status colors, gradients) | `BuildContextExt` (cardBg, mutedFg, isDark, foreground, mutedBg)

**Widgets:**
`AppButton` | `AppTextField` | `AppCard` | `AppAvatar` | `AppEmptyState` | `AppErrorState` | `AppLoadingOverlay` | `SettingRow` | `SettingToggle`

**Services & State:**
`showToast()` | `AppCacheService` | `AppPreferencesCubit` | `PreferencesRepo` | `PreferencesLocalDataSource`

**Routing:**
`noTransitionPage()` (GoRouter helper)

---

## File Size Limits

| File Type | Target | Hard Max |
|-----------|--------|----------|
| Screen | 30-70 lines | — |
| Body / Refactor | 80-120 lines | 150 |
| Widget | 80-120 lines | 150 |
| Cubit | No fixed limit | — |

Split large files into `refactor/` or `widgets/` files.

---

## Key Rules

**Imports:** Use relative imports inside `lib/`. Never use `package:project_name/...` imports.

**Localization:** All user-facing text must use the project's localization system (`'key'.tr()` or `context.translate(LangKeys.key)`). No hardcoded strings.

**Theme:** Use `AppTheme` and `AppColors` from the package. Support light/dark mode. Do not hardcode colors.

**Navigation:** Use `push` for drill-down (back returns). Use `go` for branch replacement. Parse route params in route/screen, pass clean values to Cubit.

**Error handling:** Normalize exceptions to stable error keys in data sources. UI translates and displays via `showToast()`. No duplicated error mapping in widgets.

**Bug fixes:** Fix root cause, not symptoms. Rebuild UI from Cubit state — never read stale service data directly.

---

## Delivery

- Provide full updated files or patch/ZIP when requested.
- Include a validation report when possible.
- State `build_runner` requirement.
- State `flutter analyze` result — or state honestly if it could not be run.
- Keep explanations direct and practical.
