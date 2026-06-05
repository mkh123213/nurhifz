# Nur Hifz - Enhancement Plan (Phase 1)

A detailed audit of the Nur Hifz app with actionable enhancements organized by priority and category.

---

## 1. Security & Data Isolation

### 1.1 Firestore Data Not Scoped to Teacher (CRITICAL)

**Current:** `StudentsRemoteDataSource.getAll()` fetches ALL documents from the `students` collection with no `where('teacher_id', ...)` filter. Same issue in `SessionsRemoteDataSource`, `ProgressRemoteDataSource`, and `AttendanceRemoteDataSource`. Every teacher sees every other teacher's students, sessions, and attendance records.

**Files affected:**
- `lib/features/students/data/data_source/students_remote_data_source.dart` (line 11)
- `lib/features/students/data/data_source/sessions_remote_data_source.dart` (line 11)
- `lib/features/students/data/data_source/progress_remote_data_source.dart` (line 11)
- `lib/features/attendance/data/data_source/attendance_remote_data_source.dart` (line 11)

**Enhancement:**
- Add `teacher_id` filter to every query: `.where('teacher_id', isEqualTo: currentUserId)`
- Pass the current user's UID from `FirebaseAuth.instance.currentUser!.uid` into each data source (or inject it via the service locator)
- Ensure `teacher_id` is always written when creating students, sessions, and attendance records

### 1.2 No Firestore Security Rules Enforcement

**Current:** No evidence of Firestore security rules being configured. Even with client-side filtering, any authenticated user could read/write any document using the Firebase SDK directly.

**Enhancement:**
- Write Firestore security rules that enforce:
  - Users can only read/write documents where `teacher_id == request.auth.uid`
  - Students can only be created by authenticated users
  - Attendance and session records must reference a valid `student_id`
- Deploy rules via `firebase deploy --only firestore:rules`

### 1.3 No Input Validation on Student Creation

**Current:** `StudentsCubit.addStudent()` accepts a raw `Map<String, dynamic>` and passes it directly to Firestore with no validation. A blank name, negative age, or invalid phone number can be saved.

**Files affected:**
- `lib/features/students/presentation/cubit/students_cubit.dart` (line 33)
- `lib/features/students/data/data_source/students_remote_data_source.dart` (line 17)

**Enhancement:**
- Validate required fields (name is non-empty, age > 0 if provided) in the data source before writing
- Add form-level validation in `AddStudentSheet` using `validator` on each field
- Return localized error keys for invalid input

### 1.4 Session Score Has No Bounds Check

**Current:** `SessionModel.score` accepts any integer. A score of -50 or 999 would be stored without validation.

**Enhancement:**
- Validate score is between 0 and 100 in `SessionsRemoteDataSource.create()`
- Add `inputFormatters` and `validator` on the score field in the session form

---

## 2. Error Handling & Resilience

### 2.1 Generic `catch (_)` Swallows All Errors

**Current:** Every cubit uses `catch (_)` which catches and discards all exceptions, including programming errors (`TypeError`, `RangeError`, `StateError`). This makes debugging extremely difficult. There is no logging.

**Files affected:**
- `lib/features/students/presentation/cubit/students_cubit.dart` (lines 19, 40)
- `lib/features/students/presentation/cubit/student_detail_cubit.dart` (lines 19, 37)
- `lib/features/dashboard/presentation/cubit/dashboard_cubit.dart` (line 29)
- `lib/features/reports/presentation/cubit/reports_cubit.dart` (line 29)
- `lib/features/attendance/presentation/cubit/attendance_cubit.dart` (lines 24, 53)

**Enhancement:**
- Catch `FirebaseException` specifically and map to error keys
- Let programming errors propagate (or at minimum log them)
- Add `AppLogger` from `corereusablepackage` (or a simple logger) to record errors with stack traces
- Consider using `addError()` on the cubit for unhandled exceptions so `BlocObserver` can capture them

### 2.2 No Connectivity Handling

**Current:** All data sources make network calls without checking connectivity. If the device is offline, the user gets a generic "unknown error" with no indication to check their connection.

**Enhancement:**
- Check connectivity before network calls using `ConnectivityService` from `corereusablepackage`
- Show a specific "no connection" error message with a retry button
- Add a `no_internet` key to localization files
- Consider enabling Firestore offline persistence (`FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true)`) so the app works offline

### 2.3 No Loading/Error State After `saveAttendance`

**Current:** `AttendanceCubit.saveAttendance()` sets `isSaving: true` but on error only sets `isSaving: false` and `errorKey`. There is no `BlocListener` in the attendance UI to show the error toast. The error is silently ignored.

**Enhancement:**
- Add `BlocListener` in attendance screen to show toast on error
- Show success toast after successful save
- Clear `errorKey` after displaying

---

## 3. Data & State Management

### 3.1 No Pagination — All Data Loaded at Once

**Current:** `StudentsRemoteDataSource.getAll()` loads ALL students. `AttendanceRemoteDataSource.getAll()` loads up to 200 records. `SessionsRemoteDataSource.getAll()` loads up to 100 records. As the circle grows, this will cause slow loads and high Firestore read costs.

**Enhancement:**
- Implement cursor-based pagination using Firestore's `startAfterDocument()`
- Add `loadMore()` method to cubits
- Show a "load more" button or infinite scroll in the student list and session list
- For the dashboard and reports, keep limited queries but document the limit

### 3.2 Dashboard & Reports Reload All Data Every Time

**Current:** `DashboardCubit.load()` and `ReportsCubit.load()` fetch students, sessions, progress, and attendance from scratch on every call. There is no caching.

**Enhancement:**
- Add a simple in-memory cache with TTL (e.g., 2 minutes) in repositories
- Only re-fetch when data is stale or user explicitly pulls to refresh
- Share fetched student data between cubits instead of each cubit fetching independently

### 3.3 Attendance Saves Then Re-fetches All 200 Records

**Current:** After saving a single attendance record, `AttendanceCubit.saveAttendance()` (line 52) re-fetches all 200 attendance records from Firestore. This is wasteful.

**Enhancement:**
- After saving, update the local state optimistically instead of re-fetching
- Add the new/updated record to `state.records` directly
- Only do a full reload on pull-to-refresh

### 3.4 No Student Edit or Delete in UI

**Current:** `StudentsRemoteDataSource` has `update()` and `delete()` methods, but there is no UI or cubit method to edit or delete a student. Students can only be added.

**Enhancement:**
- Add `editStudent()` and `deleteStudent()` methods to `StudentsCubit`
- Add edit button in `StudentDetailSheet` that opens a pre-filled form
- Add delete button with confirmation dialog
- Add `edit_student`, `delete_student`, `confirm_delete_student` localization keys

### 3.5 No Session Edit or Delete

**Current:** Sessions can only be created. There is no way to correct a mistake in a logged session.

**Enhancement:**
- Add `update()` and `delete()` methods to `SessionsRemoteDataSource`
- Add `editSession()` and `deleteSession()` methods to `StudentDetailCubit`
- Allow long-press on a session card to edit or delete
- Add confirmation dialog for delete

### 3.6 Progress Not Auto-Updated After Session

**Current:** When a teacher logs a new recitation session, the student's `ProgressModel` is not automatically updated. `juzCompleted` and `pagesCompleted` must be manually managed separately.

**Enhancement:**
- After a session is saved, automatically calculate and update the student's progress
- Track which surahs/ayahs have been completed and compute juz/pages from that
- Update `lastSessionDate` on the progress document

---

## 4. Authentication & User Profile

### 4.1 No Teacher Profile Management

**Current:** The settings screen shows a hardcoded avatar "م" and static labels "المعلم" / "معلم الحلقة". The actual teacher's name and email are never displayed. There is no way to update the teacher's display name.

**Files affected:**
- `lib/features/settings/presentation/refactor/settings_body.dart` (lines 44-81)

**Enhancement:**
- Show the teacher's actual name from `FirebaseAuth.instance.currentUser?.displayName`
- Show the teacher's email
- Allow the teacher to update their display name via `updateDisplayName()`
- Create a proper profile screen or modal
- Add a `teacher_name`, `teacher_email`, `edit_profile` localization keys

### 4.2 No Auth State Listener for Session Expiry

**Current:** The router checks `FirebaseAuth.instance.currentUser` synchronously on each navigation event. If the user's token expires or they are signed out from another device, the app won't know until the next navigation.

**Enhancement:**
- Listen to `FirebaseAuth.instance.authStateChanges()` at the app level
- When the user becomes null (signed out), redirect to login immediately
- Use `GoRouter.refreshListenable` with a `ChangeNotifier` that wraps `authStateChanges()`

### 4.3 No Email Verification

**Current:** Users can register and immediately use the app without verifying their email address.

**Enhancement:**
- After registration, send a verification email via `user.sendEmailVerification()`
- Show a "verify your email" screen until `user.emailVerified` is true
- Add `verify_email`, `verification_sent`, `resend_verification` localization keys

---

## 5. UI/UX Improvements

### 5.1 No Empty State for Filtered Students

**Current:** When the search field in `StudentsBody` filters down to zero results, the list is simply empty with no feedback. The user might think the app is broken.

**Enhancement:**
- Show `AppEmptyState` widget when `state.filtered.isEmpty` and search is non-empty
- Use a message like "no students match your search" with a clear-search action
- Add `no_search_results` localization key

### 5.2 No Confirmation Before Logout

**Current:** There is likely a logout action somewhere in settings but no confirmation dialog. Accidental taps can sign the user out.

**Enhancement:**
- Show an `AlertDialog` before logout with cancel/confirm buttons
- Use `LangKeys.confirm` and `LangKeys.cancel` keys

### 5.3 Settings Has `_build...` Methods Inside Body (Architecture Violation)

**Current:** `SettingsBody` at 304 lines contains 6 private `_build...` methods (`_profileCard`, `_appearanceSection`, `_notificationsSection`, `_languageSection`, `_quickLinksSection`, `_aboutSection`). This violates the architecture rule that body files should be 80-120 lines max 150 and should not contain `_build...` methods.

**Enhancement:**
- Extract each section into its own widget file under `features/settings/presentation/widgets/`:
  - `profile_card.dart`
  - `appearance_section.dart`
  - `notifications_section.dart`
  - `language_section.dart`
  - `quick_links_section.dart`
  - `about_section.dart`
- `SettingsBody` should be ~40 lines composing these widgets

### 5.4 StudentsBody Has Layout Logic in Body (Architecture Violation)

**Current:** `StudentsBody` at 141 lines contains a `_buildList` method and two `_show...Sheet` methods. It exceeds the 150-line soft limit and contains layout logic that should be in separate widgets.

**Enhancement:**
- Extract search bar into a `StudentSearchBar` widget
- Extract header row (title + add button) into a `StudentsHeader` widget
- Move sheet-showing logic into the screen or use a dedicated helper

### 5.5 No Skeleton/Shimmer Loading

**Current:** Loading state shows a plain `AppLoadingOverlay` (spinner). This provides no visual hint about what content is loading.

**Enhancement:**
- Replace loading spinners on list screens with skeleton/shimmer placeholders that match the card layout
- Use `corereusablepackage`'s shimmer component if available, or add one
- Keep spinner only for full-screen actions (login, save)

### 5.6 No Date Range or Period Filter in Reports

**Current:** `ReportsCubit` loads up to 100 sessions with no date filter. Reports always show all-time data. The teacher cannot view reports for this week, this month, or a custom range.

**Enhancement:**
- Add date range picker to reports screen (this week / this month / custom)
- Filter sessions and attendance by the selected date range in the cubit
- Add `date_range`, `this_week`, `this_month`, `custom_range` localization keys

### 5.7 No Attendance Summary View

**Current:** Attendance is only viewable day-by-day. There is no way to see a student's attendance pattern over time (e.g., "absent 3 days this month").

**Enhancement:**
- Add a weekly/monthly attendance summary view
- Show attendance percentage per student
- Highlight students with concerning attendance patterns (e.g., absent > 3 days in a month)

---

## 6. Architecture & Code Quality

### 6.1 Package Import Violation

**Current:** `StudentsBody` and `ReportsBody` use `package:nurhifz/core/localization/lang_keys.dart` — an absolute package import instead of a relative import. This violates the project rule: "Relative inside lib/. Never package:project_name/..."

**Files affected:**
- `lib/features/students/presentation/refactor/students_body.dart` (line 1)
- `lib/features/reports/presentation/refactor/reports_body.dart` (line 1)
- `lib/features/settings/presentation/refactor/settings_body.dart` (line 1)

**Enhancement:**
- Change to relative imports: `import '../../../../core/localization/lang_keys.dart';`
- Run a project-wide search for `package:nurhifz/` and fix all occurrences

### 6.2 `DashboardBody` Missing Import for `AppLoadingOverlay` and `AppErrorState`

**Current:** `DashboardBody` uses `AppLoadingOverlay()` and `AppErrorState()` (lines 22, 25) but has no visible import for them. These likely come from `corereusablepackage` via a barrel export, but the import is not shown. If these are resolved via an implicit import, it should be explicit.

**Enhancement:**
- Ensure all files explicitly import `corereusablepackage` when using its widgets
- Verify compilation with `flutter analyze`

### 6.3 `toFirestore()` on `StudentModel` Always Overwrites `created_at`

**Current:** `StudentModel.toFirestore()` (line 50) always includes `'created_at': FieldValue.serverTimestamp()`. If `toFirestore()` is used for updates, it would overwrite the original creation timestamp.

**Enhancement:**
- Remove `created_at` from `toFirestore()` — it should only be set in `StudentsRemoteDataSource.create()`
- This is already correctly handled in the data source (line 19), so `toFirestore()` should not include it

### 6.4 Duplicated Date Formatting Logic

**Current:** `AttendanceCubit` has inline date formatting logic duplicated in `_todayStr()` (line 13) and `changeDate()` (line 37-38). Both do manual `year-month-day` string formatting with `padLeft`.

**Enhancement:**
- Use `intl` package's `DateFormat('yyyy-MM-dd').format(date)` which is already a dependency
- Or create a small extension `DateTime.toDateStr()` in `core/extensions/`
- Reuse it across the app

### 6.5 No `BlocObserver` for Debugging

**Current:** `main.dart` sets up `Bloc.observer = AppBlocObserver()` per the architecture rules, but there is no evidence this observer logs transitions or errors in a useful way during development.

**Enhancement:**
- Ensure `AppBlocObserver` logs state transitions in debug mode
- Log errors with stack traces
- Optionally integrate with a crash reporting service (e.g., Firebase Crashlytics)

---

## 7. Performance

### 7.1 No Firestore Indexes Defined

**Current:** Queries like `attendance` filtered by `student_id` + `session_date` with ordering by `session_date` require composite Firestore indexes. Without them, queries fail at runtime.

**Enhancement:**
- Define composite indexes in `firestore.indexes.json`
- Required indexes:
  - `attendance`: `student_id` ASC + `session_date` DESC
  - `sessions`: `student_id` ASC + `date` DESC
  - `students`: `teacher_id` ASC + `created_at` DESC
- Deploy with `firebase deploy --only firestore:indexes`

### 7.2 No `const` Constructors on Stateless Widgets Where Possible

**Current:** Some widgets could benefit from `const` constructors to enable compile-time constant optimization and reduce rebuilds.

**Enhancement:**
- Audit all stateless widgets and add `const` constructors where all fields are final
- Mark widget instances as `const` in parent build methods where possible

### 7.3 ListView Without `itemExtent`

**Current:** `StudentsBody` uses `ListView.separated` without `itemExtent`. If all student cards have the same height, specifying `itemExtent` improves scroll performance.

**Enhancement:**
- If student cards are uniform height, set `itemExtent` on the ListView
- Otherwise, consider `ListView.builder` with `prototypeItem` for auto-measurement

---

## 8. Missing Features

### 8.1 Notifications Are Toggle-Only — No Actual Push Notifications

**Current:** The notifications toggle in settings saves a boolean to SharedPreferences but does nothing. There is no Firebase Cloud Messaging (FCM) setup, no notification scheduling, no push notification handling.

**Enhancement:**
- Add `firebase_messaging` package
- Register for FCM token on login
- Store FCM token in Firestore under the teacher's profile
- Implement local notifications for session reminders using `flutter_local_notifications`
- Send push notifications for attendance reminders or session alerts

### 8.2 No Data Export (PDF/Excel)

**Current:** Reports are view-only. Teachers cannot export or share student progress reports.

**Enhancement:**
- Add PDF export for student reports using `pdf` package
- Add Excel/CSV export using `csv` package
- Allow sharing via the system share sheet (`share_plus` package)
- Add `export_pdf`, `export_excel`, `share_report` localization keys

### 8.3 No Student Photo/Avatar Upload

**Current:** `StudentModel` has an `avatarUrl` field but there is no UI to upload or capture a student photo. The field is never populated.

**Enhancement:**
- Add image picker button in `AddStudentSheet` and edit form
- Upload image to Firebase Storage
- Store the download URL in `avatar_url`
- Display in `StudentCard` and `StudentDetailSheet` with fallback to initials

### 8.4 No Backup/Restore

**Current:** All data lives in Firestore with no backup strategy. If a teacher accidentally deletes students or sessions, data is lost.

**Enhancement:**
- Add a "soft delete" pattern with `is_deleted` flag instead of hard deletes
- Add an export-all-data feature for local backup (JSON/CSV)
- Consider Firestore scheduled backups via Cloud Functions

### 8.5 No Multi-Circle Support

**Current:** The app assumes one circle per teacher. Teachers managing multiple circles cannot separate students by circle.

**Enhancement:**
- Add a `Circle` model with id, name, teacherId, schedule
- Add a `circle_id` field to students, sessions, and attendance
- Add a circle selector/switcher in the dashboard
- Allow creating and managing multiple circles

### 8.6 No Student/Parent Access

**Current:** Only teachers can use the app. Parents or students cannot view their own progress or attendance.

**Enhancement:**
- Add role-based authentication (teacher vs. student/parent)
- Create a read-only student/parent view with progress and attendance
- Share progress via a unique link or QR code

---

## 9. Testing

### 9.1 No Unit Tests

**Current:** The `test/` directory is empty or has only a minimal `widget_test.dart`. Zero test coverage.

**Enhancement:**
- Add unit tests for all cubits:
  - `AuthCubit`: sign in, register, sign out, error mapping
  - `StudentsCubit`: load, search, add student
  - `StudentDetailCubit`: load, add session
  - `AttendanceCubit`: load, change date, save attendance
  - `DashboardCubit`: load, computed stats
  - `ReportsCubit`: load, computed stats
- Add unit tests for all data sources (mock Firestore)
- Add unit tests for models (fromFirestore/toFirestore)
- Target: 80%+ cubit coverage

### 9.2 No Widget Tests

**Enhancement:**
- Add widget tests for key screens:
  - Login form validation
  - Student list rendering
  - Attendance status selection
  - Report chart rendering
- Test empty states, loading states, error states

### 9.3 No Integration Tests

**Enhancement:**
- Add integration test for the core flow:
  1. Login
  2. Add a student
  3. Record attendance
  4. Log a session
  5. View reports
- Use `integration_test` package with Firebase emulator

---

## 10. DevOps & CI/CD

### 10.1 No Product Flavors

**Current:** The app runs with a single Firebase configuration (project `test-8f18d`). There are no dev/staging/production flavors.

**Enhancement:**
- Set up product flavors (dev, staging, production) per `CLAUDEMAKEFLAVORSANDFASLANEWITHGITHUBACTIONS.md`
- Each flavor points to a different Firebase project
- This is mandatory per project setup rules

### 10.2 No Fastlane Configuration

**Enhancement:**
- Set up Fastlane for iOS and Android
- Automate build, test, and deployment pipelines
- This is mandatory per project setup rules

### 10.3 No GitHub Actions

**Enhancement:**
- Set up CI/CD with GitHub Actions:
  - Run `flutter analyze` on every PR
  - Run tests on every PR
  - Build APK/IPA on release tags
  - Deploy to Firebase App Distribution or Play Store/TestFlight
- This is mandatory per project setup rules

---

## Priority Summary

| Priority | Enhancement | Impact |
|----------|------------|--------|
| P0 - Critical | 1.1 Data not scoped to teacher | Data leak between teachers |
| P0 - Critical | 1.2 No Firestore security rules | Anyone can read/write any data |
| P1 - High | 2.1 Generic catch swallows errors | Undebuggable production issues |
| P1 - High | 1.3 No input validation | Corrupt data in Firestore |
| P1 - High | 3.4 No student edit/delete | Basic CRUD incomplete |
| P1 - High | 4.1 Hardcoded teacher profile | Poor UX, no personalization |
| P1 - High | 6.1 Package import violations | Architecture rule violation |
| P2 - Medium | 2.2 No connectivity handling | Confusing offline behavior |
| P2 - Medium | 3.1 No pagination | Slow loads as data grows |
| P2 - Medium | 3.3 Attendance re-fetches all records | Wasted Firestore reads |
| P2 - Medium | 3.6 Progress not auto-updated | Manual work for teachers |
| P2 - Medium | 5.3 Settings body too large | Architecture violation |
| P2 - Medium | 5.6 No date filter in reports | Reports are always all-time |
| P2 - Medium | 6.3 toFirestore overwrites created_at | Data integrity risk |
| P3 - Low | 3.5 No session edit/delete | Minor friction |
| P3 - Low | 4.2 No auth state listener | Edge case session expiry |
| P3 - Low | 5.1 No empty search state | Minor UX gap |
| P3 - Low | 5.5 No skeleton loading | Polish |
| P3 - Low | 7.2 Missing const constructors | Marginal performance |
| P3 - Low | 8.1 Push notifications | Feature request |
| P3 - Low | 8.2 Data export | Feature request |
| P4 - Future | 8.5 Multi-circle support | Major feature |
| P4 - Future | 8.6 Student/parent access | Major feature |
| P4 - Future | 9.x Testing | Quality investment |
| P4 - Future | 10.x CI/CD | Infrastructure investment |
