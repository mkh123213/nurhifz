# Nur Hifz (Halaqati) - Enhancement Phases

A comprehensive enhancement plan for the Quran Memorization Circle Management app, organized into prioritized phases.

---

## Phase 1: Architecture & Code Quality Fixes (Critical)

### 1.1 Missing `LangKeys` class
**Current:** All localization uses raw strings like `'app_name'.tr()` throughout the entire codebase.
**Enhancement:** Create `lib/core/localization/lang_keys.dart` with static constants for every key. Replace all raw string `.tr()` calls with `LangKeys.keyName.tr()` or `context.translate(LangKeys.keyName)`.
**Files affected:** Every presentation file (screens, bodies, widgets) + new `lang_keys.dart`.

### 1.2 Missing `corereusablepackage` integration
**Current:** The app duplicates widgets that already exist in `corereusablepackage` (e.g., `AppButton`, `AppCard`, `AppEmptyState`, `AppErrorState`, `AppLoadingOverlay`, `AppToast`, `SettingRow`, `SettingToggle`, `AppAvatar`, `AppColors`, `AppTheme`, context extensions).
**Enhancement:** Remove local duplicates in `lib/core/widgets/`, `lib/core/theme/`, `lib/core/extensions/` and import from `corereusablepackage`. Add the dependency to `pubspec.yaml`.
**Files affected:** `pubspec.yaml`, all files under `lib/core/widgets/`, `lib/core/theme/`, `lib/core/extensions/`, and every file that imports them.

### 1.3 Unsafe `dynamic` casts in Cubits
**Current:** `DashboardCubit`, `StudentsCubit`, `AttendanceCubit`, `ReportsCubit` all use `results[0] as dynamic` from `Future.wait`, losing type safety.
**Enhancement:** Use properly typed variables:
```dart
final students = await _studentsRepo.getAll();
final sessions = await _sessionsRepo.getAll(limit: 20);
```
Or assign typed results from `Future.wait` with explicit casts like `results[0] as List<StudentModel>`.
**Files affected:** `dashboard_cubit.dart`, `students_cubit.dart`, `attendance_cubit.dart`, `reports_cubit.dart`, `student_detail_cubit.dart`.

### 1.4 App file should be separate from `main.dart`
**Current:** `NurHifzApp` widget is defined inside `main.dart`.
**Enhancement:** Extract `NurHifzApp` to `lib/nur_hifz_app.dart`. Keep `main.dart` for initialization only.
**Files affected:** `main.dart`, new `nur_hifz_app.dart`.

### 1.5 `createRouter()` creates a new instance on every build
**Current:** `routerConfig: createRouter()` is called inside `BlocBuilder`, creating a new `GoRouter` on every rebuild.
**Enhancement:** Make the router a singleton or a late-initialized field so it is created once.
**Files affected:** `app_router.dart`, `main.dart` / `nur_hifz_app.dart`.

### 1.6 `DropdownButtonFormField` uses non-existent `initialValue` parameter
**Current:** `AddStudentSheet` and `SessionForm` use `initialValue:` on `DropdownButtonFormField`, which is not a valid parameter. The correct parameter is `value:`.
**Enhancement:** Replace `initialValue` with `value` in all `DropdownButtonFormField` usages.
**Files affected:** `add_student_sheet.dart`, `session_form.dart`.

---

## Phase 2: Security & Data Integrity (High Priority)

### 2.1 No Firestore security rules
**Current:** No `firestore.rules` file exists. Data is likely open or using default rules.
**Enhancement:** Create proper Firestore security rules that:
- Restrict reads/writes to authenticated users.
- Scope student/session/attendance/progress data to the `teacher_id` (current user UID).
- Prevent users from reading/writing other teachers' data.

### 2.2 No `teacher_id` enforcement on data creation
**Current:** When creating students, sessions, and attendance records, the `teacher_id` is optional and never set from `FirebaseAuth.instance.currentUser!.uid`.
**Enhancement:** Automatically attach `teacher_id` from the current authenticated user in every data source `create`/`save` method. Filter all `getAll()` queries by `teacher_id`.
**Files affected:** `students_remote_data_source.dart`, `sessions_remote_data_source.dart`, `attendance_remote_data_source.dart`, `progress_remote_data_source.dart`.

### 2.3 No input validation on auth forms
**Current:** Login and register forms submit without validating email format or password length. Empty fields are submitted directly.
**Enhancement:** Add `Form` with `GlobalKey<FormState>`, add `validator` to each `AppTextField`. Validate email format and minimum password length before calling the cubit.
**Files affected:** `login_body.dart`, `register_body.dart`, `forgot_password_body.dart`.

### 2.4 No input validation on student form
**Current:** The add student button's `onPressed` is `null` when name is empty, but this check happens only at build time (won't react to typing). No phone format or age range validation.
**Enhancement:** Use a `Form` key, add a `ValueListenableBuilder` on `_nameCtrl` for reactive button state, validate phone format and age range (e.g., 3-99).
**Files affected:** `add_student_sheet.dart`.

### 2.5 `StudentModel.toFirestore()` always overwrites `created_at`
**Current:** `toFirestore()` always includes `'created_at': FieldValue.serverTimestamp()`, so updating a student overwrites the original creation timestamp.
**Enhancement:** Remove `created_at` from `toFirestore()`. Only add it in the data source's `create()` method (which already does this).
**Files affected:** `student_model.dart`, `attendance_model.dart`.

---

## Phase 3: Missing Features (Core Functionality)

### 3.1 No edit/update student functionality
**Current:** `StudentsRepo` has `update()` and `delete()` methods, but no UI exposes them. Once a student is added, they cannot be edited or deleted from the app.
**Enhancement:** Add edit student sheet (pre-filled form), delete confirmation dialog, and swipe-to-delete or long-press menu on `StudentCard`.
**Files affected:** New `edit_student_sheet.dart`, update `student_card.dart`, update `students_cubit.dart`.

### 3.2 No edit/delete session functionality
**Current:** Sessions can only be added. No way to edit a session's score, surah, or ayah range, or delete an incorrect session.
**Enhancement:** Add edit mode to `SessionTile` with long-press or an edit button. Add delete capability. Add `update()` and `delete()` methods to `SessionsRemoteDataSource` and `SessionsRepo`.
**Files affected:** `sessions_remote_data_source.dart`, `sessions_repo.dart`, `session_tile.dart`, `student_detail_cubit.dart`.

### 3.3 No automatic progress update after adding a session
**Current:** Adding a session does not update the student's progress (juz/pages completed). Progress is a separate, disconnected collection.
**Enhancement:** After successfully adding a session, automatically calculate and update the student's progress based on the ayah range and surah covered. Use `ProgressRepo.upsert()` from within `StudentDetailCubit.addSession()`.
**Files affected:** `student_detail_cubit.dart`, potentially `progress_remote_data_source.dart`.

### 3.4 No logout UI
**Current:** `AuthCubit` has a `signOut()` method, but the settings screen has no logout button. Users cannot sign out.
**Enhancement:** Add a logout button at the bottom of `SettingsBody` with a confirmation dialog. On logout, navigate to the login screen and clear cached data.
**Files affected:** `settings_body.dart`, `settings_screen.dart`.

### 3.5 No profile management
**Current:** The settings screen shows a hardcoded 'م' avatar and generic "Teacher" label. No user profile data is stored or displayed.
**Enhancement:** Create a user profile model and Firestore collection. Allow the teacher to set their name and optionally upload a profile image. Display the real name in `DashboardHeader` and `SettingsBody`.
**Files affected:** New `profile_model.dart`, new `profile_remote_data_source.dart`, new `profile_repo.dart`, update `dashboard_header.dart`, update `settings_body.dart`.

### 3.6 Notifications are toggled but never implemented
**Current:** `AppPreferencesCubit.toggleNotifications()` saves a boolean to SharedPreferences, but no push notification service, FCM integration, or local notification is implemented.
**Enhancement:** Either implement FCM push notifications for session reminders and attendance alerts, or remove the toggle from settings to avoid user confusion.
**Files affected:** `pubspec.yaml` (add `firebase_messaging`, `flutter_local_notifications`), new notification service, or remove from `settings_body.dart`.

---

## Phase 4: UX & Usability Improvements

### 4.1 No "mark all present" button for attendance
**Current:** Teachers must tap each student individually to mark attendance.
**Enhancement:** Add a "Mark All Present" and "Mark All Absent" button at the top of the attendance list for bulk operations.
**Files affected:** `attendance_body.dart`, `attendance_cubit.dart`, `attendance_remote_data_source.dart`.

### 4.2 No date picker for sessions
**Current:** `SessionForm._submit()` hardcodes the date to today (`DateTime.now()`). Teachers cannot record a session for a previous day.
**Enhancement:** Add a date picker field to `SessionForm` that defaults to today but allows selecting past dates.
**Files affected:** `session_form.dart`.

### 4.3 No confirmation/success feedback pattern consistency
**Current:** Some actions show toast on success, some don't. Session form stays open after saving. No form reset after successful submission.
**Enhancement:** Reset form fields and optionally collapse the form after successful session save. Standardize success/error toast across all write operations.
**Files affected:** `session_form.dart`, `add_student_sheet.dart`.

### 4.4 No empty state for attendance screen
**Current:** If no students exist, the attendance screen shows an empty list with no guidance.
**Enhancement:** Show `AppEmptyState` with a message like "Add students first" and a button to navigate to the students screen.
**Files affected:** `attendance_body.dart`.

### 4.5 Student search does not filter by level
**Current:** Search only matches name and phone.
**Enhancement:** Add filter chips above the student list for levels (All, Beginner, Intermediate, Advanced). Combine with text search.
**Files affected:** `students_body.dart`, `students_state.dart`, `students_cubit.dart`.

### 4.6 No pull-to-refresh on student detail sheet
**Current:** The student detail bottom sheet has no way to refresh data after it loads.
**Enhancement:** Wrap the sessions tab and progress tab content in `RefreshIndicator`.
**Files affected:** `student_detail_sheet.dart`.

### 4.7 Attendance date navigation has no calendar picker
**Current:** `AttendanceDatePicker` allows only previous/next day navigation.
**Enhancement:** Add a tap-to-open `showDatePicker` on the date display, so teachers can jump to any date directly.
**Files affected:** `attendance_date_picker.dart`, `attendance_cubit.dart`.

---

## Phase 5: Data & Performance Optimizations

### 5.1 All queries fetch all data without teacher scoping
**Current:** `getAll()` in every data source fetches ALL documents from the collection globally. In a multi-tenant app, this returns every teacher's data.
**Enhancement:** Filter all Firestore queries by `teacher_id == currentUser.uid`. Pass the current user's UID through the DI chain or access it from the registered `FirebaseAuth` instance.
**Files affected:** All data sources (`students_remote_data_source.dart`, `sessions_remote_data_source.dart`, `progress_remote_data_source.dart`, `attendance_remote_data_source.dart`).

### 5.2 Attendance fetches up to 200 records every time
**Current:** `AttendanceCubit.load()` fetches 200 attendance records and filters client-side by date. After saving attendance, it re-fetches all 200 records.
**Enhancement:** Use `getByDate(selectedDate)` instead of `getAll()` for the initial load. When the date changes, fetch only that date's records. Cache previously fetched dates.
**Files affected:** `attendance_cubit.dart`.

### 5.3 Dashboard and Reports load all data on every visit
**Current:** Every time the user navigates to the dashboard or reports tab, all data is re-fetched from Firestore.
**Enhancement:** Add a caching strategy: only reload if data is stale (e.g., more than 5 minutes old) or on explicit pull-to-refresh. Consider using Firestore snapshots for real-time updates instead of one-shot gets.
**Files affected:** `dashboard_cubit.dart`, `reports_cubit.dart`.

### 5.4 No pagination for sessions and students
**Current:** `getAll()` fetches all students and sessions in one call. This won't scale beyond ~100 records.
**Enhancement:** Implement cursor-based pagination using Firestore's `startAfterDocument`. Load 20 items at a time and load more on scroll.
**Files affected:** `students_remote_data_source.dart`, `sessions_remote_data_source.dart`, `students_cubit.dart`, `students_body.dart`.

### 5.5 No offline support
**Current:** The app requires network connectivity for every operation. If offline, all operations fail silently.
**Enhancement:** Enable Firestore offline persistence (enabled by default on mobile but needs testing). Add connectivity-aware UI states that inform the user when they're offline and queue writes.
**Files affected:** `main.dart` (Firestore settings), potentially a network cubit.

---

## Phase 6: Reports & Analytics Enhancements

### 6.1 No date range filter for reports
**Current:** Reports show all-time data. No way to view weekly, monthly, or custom date range reports.
**Enhancement:** Add date range selector (This Week / This Month / Custom Range) at the top of the reports screen. Filter sessions and attendance by the selected range.
**Files affected:** `reports_cubit.dart`, `reports_state.dart`, `reports_body.dart`.

### 6.2 No attendance percentage over time chart
**Current:** Reports show overall attendance percentage per student but no trend over time.
**Enhancement:** Add a line chart showing daily/weekly attendance rate over the past 30 days.
**Files affected:** New `reports_attendance_chart.dart`, update `reports_body.dart`, `reports_state.dart`.

### 6.3 No individual student report screen
**Current:** The reports tab only shows aggregate data. No way to generate a detailed report for a single student.
**Enhancement:** Add a "View Report" action on each student card or in the student detail sheet that shows a dedicated per-student report with score trends, attendance history, and memorization timeline.
**Files affected:** New `student_report_screen.dart`, new `student_report_cubit.dart`, update `app_router.dart`, `app_routes.dart`.

### 6.4 No export/share functionality for reports
**Current:** Reports are only viewable in-app. Teachers cannot share them with parents or administrators.
**Enhancement:** Add a "Share Report" button that generates a PDF summary (using `pdf` package) or shares a screenshot of the charts.
**Files affected:** `pubspec.yaml` (add `pdf`, `share_plus`, `screenshot`), new `report_export_service.dart`, update `reports_body.dart`.

### 6.5 No session score trend chart per student
**Current:** Student detail sheet shows a flat list of sessions with no visual trend.
**Enhancement:** Add a line chart at the top of the sessions tab showing score progression over time.
**Files affected:** New `student_score_chart.dart`, update `student_detail_sheet.dart`.

---

## Phase 7: Feature Additions

### 7.1 No parent/guardian contact integration
**Current:** Student model has a `phone` field but no way to call or message the parent directly.
**Enhancement:** Add a phone call and WhatsApp button on the student card and detail sheet using `url_launcher`.
**Files affected:** `pubspec.yaml` (add `url_launcher`), `student_card.dart`, `student_detail_sheet.dart`.

### 7.2 No multiple circles (halaqat) support
**Current:** The app assumes one teacher managing one circle. All students are in a single flat list.
**Enhancement:** Add a `Circle` model with name, schedule, and student IDs. Allow teachers to create multiple circles and assign students. Filter dashboard/attendance/reports by circle.
**Files affected:** New `circle_model.dart`, new `circles_remote_data_source.dart`, new `circles_repo.dart`, new `circles_cubit.dart`, new circle management screens.

### 7.3 No weekly schedule / timetable
**Current:** No concept of which days the circle meets or session scheduling.
**Enhancement:** Add a weekly timetable feature where the teacher sets which days and times the halaqah meets. Show upcoming sessions on the dashboard.
**Files affected:** New `schedule_model.dart`, new schedule data layer, new `schedule_screen.dart`.

### 7.4 No Quran page/Juz tracking visualization
**Current:** Progress shows juz completed as a number. No visual map of which surahs/juz have been memorized.
**Enhancement:** Add a Quran map view showing 30 juz as a grid or list, with color-coded completion status per student.
**Files affected:** New `quran_map_widget.dart`, update `student_progress_view.dart`.

### 7.5 No mistake categorization
**Current:** Session model has a `mistakes` field (list of strings) but the UI never lets the teacher record specific mistakes.
**Enhancement:** Add mistake categories (tajweed, harakat, word confusion, etc.) with a multi-select chip UI in the session form.
**Files affected:** `session_form.dart`, new `mistake_categories.dart` constants.

### 7.6 No backup/restore functionality
**Current:** All data lives in Firestore with no local backup option.
**Enhancement:** Add export data to JSON file and import from JSON file options in settings. Useful for data migration or offline backup.
**Files affected:** New `backup_service.dart`, update `settings_body.dart`.

---

## Phase 8: UI Polish & Accessibility

### 8.1 No onboarding / first-use experience
**Current:** After registration, the user lands on an empty dashboard with no guidance.
**Enhancement:** Add a simple onboarding flow (3 slides) explaining the app features. Show "Add your first student" prompt on empty dashboard.
**Files affected:** New `onboarding_screen.dart`, update `app_router.dart`, update `dashboard_body.dart`.

### 8.2 No splash screen
**Current:** The app shows a white/black screen while initializing Firebase and localization.
**Enhancement:** Add a branded splash screen with the app logo using `flutter_native_splash` or a custom splash widget.
**Files affected:** `pubspec.yaml`, new splash configuration.

### 8.3 No app icon
**Current:** Uses the default Flutter icon.
**Enhancement:** Design and set a custom app icon using `flutter_launcher_icons` package.
**Files affected:** `pubspec.yaml`, icon assets.

### 8.4 No skeleton/shimmer loading
**Current:** Loading shows a centered spinner (`AppLoadingOverlay`).
**Enhancement:** Replace with shimmer/skeleton loading that mimics the layout shape (e.g., card-shaped placeholders on the dashboard).
**Files affected:** `pubspec.yaml` (add `shimmer`), new `dashboard_skeleton.dart`, `students_skeleton.dart`.

### 8.5 Hardcoded Arabic avatar 'م' in header and settings
**Current:** Dashboard header and settings profile show a hardcoded 'م' character.
**Enhancement:** Use the first character of the actual user's display name, or a generic user icon if no name is set.
**Files affected:** `dashboard_header.dart`, `settings_body.dart`.

### 8.6 No animation/transition between screens
**Current:** Shell route tabs use `NoTransitionPage` with no animation.
**Enhancement:** Add subtle fade or slide transitions for tab switching and screen navigation.
**Files affected:** `app_router.dart`.

### 8.7 No `BlocObserver` for debugging
**Current:** `main.dart` doesn't set `Bloc.observer`.
**Enhancement:** Create an `AppBlocObserver` that logs state transitions in debug mode.
**Files affected:** `main.dart`, new `app_bloc_observer.dart`.

---

## Phase 9: Testing & CI/CD

### 9.1 No unit tests
**Current:** Only the default `widget_test.dart` exists.
**Enhancement:** Add unit tests for all cubits, data sources, and repos. Test state transitions, error handling, and data mapping.

### 9.2 No widget tests
**Enhancement:** Add widget tests for key screens: login flow, add student sheet, attendance card toggling, session form validation.

### 9.3 No integration tests
**Enhancement:** Add integration tests for critical flows: login -> dashboard, add student -> view in list, record attendance -> verify summary.

### 9.4 No product flavors, Fastlane, or GitHub Actions
**Current:** No CI/CD pipeline, no dev/staging/prod flavors.
**Enhancement:** Set up product flavors (dev, staging, prod) with separate Firebase projects. Configure Fastlane for automated builds and GitHub Actions for CI.

### 9.5 No `flutter analyze` compliance verification
**Enhancement:** Add `flutter analyze` to CI pipeline. Fix all existing warnings and enforce zero-warning policy.

---

## Priority Summary

| Priority | Phase | Impact | Effort |
|----------|-------|--------|--------|
| P0 | Phase 1 (Architecture fixes) | Foundation stability | Medium |
| P0 | Phase 2 (Security) | Data protection | Medium |
| P1 | Phase 3 (Missing core features) | Feature completeness | High |
| P1 | Phase 5 (Performance) | Scalability | Medium |
| P2 | Phase 4 (UX improvements) | User satisfaction | Medium |
| P2 | Phase 6 (Reports) | Teacher value | High |
| P3 | Phase 7 (New features) | Competitive edge | High |
| P3 | Phase 8 (UI polish) | Professional feel | Medium |
| P3 | Phase 9 (Testing & CI/CD) | Long-term quality | High |
