# Pre-Delivery Checklist

Run through this checklist before submitting any Flutter code change.

---

## Architecture

- [ ] Feature uses `data/` + `presentation/` structure only
- [ ] No `domain/`, `entities/`, or `use_cases/` layers added
- [ ] Repos are thin — delegate to data sources
- [ ] Data sources contain all backend/local persistence logic
- [ ] Cubit owns all screen behavior and state
- [ ] UI is dumb — displays state and forwards actions only

## UI Quality

- [ ] Screen files are 30-70 lines
- [ ] No chains of private `_build...` methods in a single file
- [ ] Large sections split into `refactor/` or `widgets/` files
- [ ] Empty, loading, and error states use package widgets
- [ ] Text widgets have `maxLines` + `overflow` where needed
- [ ] Layout is responsive (no overflow on small screens)

## State Management

- [ ] Lists rebuild from Cubit state, not stale references
- [ ] Favorite/cart/profile changes update visible UI immediately
- [ ] Refresh failure preserves previously loaded data

## Localization & Theme

- [ ] No hardcoded user-facing strings
- [ ] All missing translation keys added to JSON files
- [ ] Colors are dark-mode safe (use `AppColors` / `BuildContextExt`)
- [ ] Uses package widgets where applicable (`AppButton`, `AppCard`, `showToast`, etc.)

## Code Quality

- [ ] JSON translation files are valid (no trailing commas, no syntax errors)
- [ ] All imports are relative inside `lib/` — no `package:project_name/...`
- [ ] No Firebase / Auth / Firestore / Supabase calls in presentation or common widgets
- [ ] No UI or common widget file exceeds 150 lines without justification
- [ ] No missing `part` files for generated code
- [ ] `build_runner` requirement stated
- [ ] `flutter analyze` result stated (or noted as unavailable)
