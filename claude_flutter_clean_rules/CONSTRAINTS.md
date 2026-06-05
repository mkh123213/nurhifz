# Flutter Clean Architecture — Detailed Constraints

> This file supplements `CLAUDE.md` with comprehensive layer ownership rules, edge-case patterns, and validation requirements.

---

## 1. Feature Structure

Every feature uses exactly this layout:

```
lib/features/<feature>/
  data/
    data_source/       # remote or local persistence
    models/            # data models
    repos/             # thin delegation layer
  presentation/
    cubit/             # state management
    refactor/          # body sections, view data, form helpers, constants
    screens/           # entry point widgets
    widgets/           # small dumb components
```

**Never create:** `domain/`, `entities/`, `use_cases/`, abstract repository interfaces, `repo_interface/`, `repo_impl/`, `presentations/`, or `core/cubits/` for feature cubits.

---

## 2. Layer Ownership

### 2.1 UI Layer (Screens + Widgets)

**Allowed:**
- Build and compose widgets
- Display Cubit state directly
- Call Cubit methods on user interaction
- Show dialogs, bottom sheets, and toasts from state listeners
- Use LayoutBuilder for responsive decisions
- Own TextEditingControllers in form widgets

**Forbidden:**
- Call Firebase, Firestore, Auth, Supabase, SharedPreferences, or any API directly
- Calculate totals, stock changes, or derived values
- Filter or sort lists
- Map backend errors to user messages
- Decide business status transitions
- Build backend models with complex logic
- Parse dates/times (except simple display formatting)
- Contain long switch/case for business behavior
- Contain repeated validation logic
- Accumulate many private `_build...` methods in a single file

### 2.2 Cubit Layer

**Owns:**
- Initial data loading and pull-to-refresh
- Filter state and search query
- Selected values (tabs, dropdowns, toggles)
- Submit and loading flags
- Optimistic UI updates where appropriate
- Error normalization — catch exceptions, emit stable error keys
- Preparing UI-ready display data (formatted strings, computed flags)
- Exposing state that the UI renders without transformation
- Preserving old data when refresh fails

**Must not:** Use `BuildContext`, call navigation, or trigger UI side effects directly.

### 2.3 Data Layer (Data Sources)

**Owns:**
- All Firebase / Firestore / Auth / Supabase / SharedPreferences calls
- Firestore transactions and batch writes
- Deterministic document IDs and timestamps
- Duplicate checks before writes
- Backend validation (e.g., "status X cannot transition to Y")
- Status transition enforcement
- Stock movements and inventory adjustments
- Data normalization and trimming before persistence
- Local persistence for favorites, theme, language, and cart

### 2.4 Repos

Thin delegation layer. Expose clean method signatures to Cubit, delegate all work to data sources. No business logic, no UI logic.

### 2.5 Models

- Represent backend or local data structures
- Include `fromJson` / `toJson` (or Firestore equivalents) as needed
- Strip `id`, `created_at`, `updated_at` before writes when the backend manages them
- Handle `Timestamp` safely (null checks, type conversion)
- Use `json_serializable` / `freezed` only if the project already uses them
- Include `copyWith` only when there is a real use case

---

## 3. Folder Purposes

### `presentation/refactor/`
- Large body sections extracted from screens
- View data classes (UI-specific DTOs)
- Display mappers (model-to-UI transformations)
- Form controllers and form helper classes
- Feature-specific constants
- Status label/action helpers (presentation-only logic)

### `presentation/widgets/`
- Small, stateless, dumb components
- Cards, rows, chips, badges
- Table and list item widgets
- Bottom sheets and dialogs
- Form field wrappers
- Empty state, loading state, error state views

---

## 4. File Size Limits

```
Screen file:           30-70 lines
Body / Refactor file:  80-120 lines
Widget file:           80-120 lines
Hard max (UI/common):  150 lines (only if justified)
Cubit files:           may exceed 150 when state behavior requires it
```

When a file exceeds the target range, split into `refactor/` or `widgets/` files.

---

## 5. Imports

Use relative imports inside `lib/`:

```dart
// correct
import '../../../core/widgets/app_button.dart';

// wrong — never use package imports for project-internal files
import 'package:my_app/core/widgets/app_button.dart';
```

Package imports are fine for external dependencies like `corereusablepackage`.

---

## 6. Localization

All user-facing text must use the project's localization system.

```dart
// EasyLocalization
'dashboard_title'.tr()

// Custom LangKeys
context.translate(LangKeys.dashboardTitle)
```

Never hardcode strings like `'Save'`, `'Error'`, `'No data found'`, or `'Dashboard'`. Add missing keys to the appropriate translation files.

---

## 7. Theme and Core Package

Always use `corereusablepackage` before building custom theme components:

```yaml
dependencies:
  corereusablepackage:
    path: ../corereusablepackage
```

```dart
import 'package:corereusablepackage/corereusablepackage.dart';
```

Maintain light/dark mode consistency using the package's `BuildContextExt` extensions and `AppColors`.

---

## 8. Responsive Layout

Prevent overflow with these patterns:

- `SingleChildScrollView` for scrollable content
- `RefreshIndicator` for pull-to-refresh
- `LayoutBuilder` for responsive breakpoints
- `Wrap` instead of `Row` when children may overflow
- `Flexible` / `Expanded` only inside constrained `Row` / `Column`
- `shrinkWrap: true` for nested lists and grids
- `NeverScrollableScrollPhysics` for inner lists inside a scrollable parent
- `FittedBox` only for compact values or chips that may overflow
- `maxLines` + `overflow: TextOverflow.ellipsis` on text widgets
- `SafeArea` at screen edges

**Never** use `Expanded` inside an unconstrained scrollable parent.

---

## 9. Forms

- Use reusable field widgets (`AppTextField`, etc.)
- UI validation covers immediate field checks only: required, email format, phone format, date format
- Complex model creation, trimming, and empty-to-null conversion belong in helper/controller classes
- Backend/data validation belongs in the data source

---

## 10. Navigation

- Use `context.push` for drill-down navigation (card tap, list item) — back button returns to previous screen
- Use `context.go` only for branch replacement (tab switch, logout redirect)
- Parse route query parameters in the route definition or screen — pass clean values to Cubit
- Cards and list items receive route paths or callbacks, not route-building logic

---

## 11. Error Handling

- Use `showToast()` from the package instead of scattered SnackBars
- Data sources catch backend exceptions and throw normalized error keys
- Cubit catches data-layer exceptions and emits error state with the key
- UI translates the error key and displays it
- No duplicated error mapping in widget files

---

## 12. Common Patterns

### Favorites
- Dedicated `FavoritesCubit` or feature-specific cubit
- Favorite icon rebuilds from cubit state (never from a static field)
- Persist locally or remotely via data source and repo
- Favorites screen uses the same theme as the rest of the app

### Cart
- Cart screen rebuilds from `CartCubit` state, not stale GetIt/static data
- Include empty cart state widget
- Invalid images use fallback via a network image widget

### Profile Image Upload
- Use image picker / storage service
- Upload through data source
- Wait for backend confirmation
- Update cached/local user data
- Cubit emits success or error state
- UI shows toast from a `BlocListener`

---

## 13. Build Runner

- State whether `build_runner` is needed after every delivery
- Run only when `freezed` or `json_serializable` generated files changed

---

## 14. Pre-Delivery Validation

Before submitting any code change, verify:

- [ ] No `package:project_name/...` imports inside `lib/`
- [ ] No Firebase / Auth / Firestore / Supabase calls in presentation or common UI widgets
- [ ] No UI or common widget file exceeds 150 lines without justification
- [ ] Localization JSON files are valid
- [ ] No missing localization keys
- [ ] No missing `part` files for generated code
- [ ] Patches apply cleanly (if providing a patch)
- [ ] `build_runner` requirement stated
- [ ] `flutter analyze` result stated (or honestly note if unavailable)
