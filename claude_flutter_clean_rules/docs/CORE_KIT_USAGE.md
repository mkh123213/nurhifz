# Core Package Setup Guide

## 1. Add Dependency

```yaml
# pubspec.yaml
dependencies:
  corereusablepackage:
    path: ../corereusablepackage
    # or via git:
    # git:
    #   url: https://github.com/<owner>/corereusablepackage.git
```

```bash
flutter pub get
```

## 2. Import

```dart
import 'package:corereusablepackage/corereusablepackage.dart';
```

## 3. Add Backend Dependencies Separately

The package includes: `flutter_bloc`, `equatable`, `shared_preferences`, `google_fonts`, `fluttertoast`, `get_it`, `go_router`, `easy_localization`.

Add only what your project needs for backend:

```yaml
dependencies:
  firebase_core:
  firebase_auth:
  cloud_firestore:
  supabase_flutter:
```

## 4. App Setup

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize backend (Firebase, Supabase, etc.)
  // 2. Initialize localization
  // 3. Set up service locator with GetIt

  final prefs = await SharedPreferences.getInstance();
  final dataSource = PreferencesLocalDataSource(prefs);
  final repo = PreferencesRepo(dataSource);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      child: BlocProvider(
        create: (_) => AppPreferencesCubit(repo),
        child: const MyApp(),
      ),
    ),
  );
}
```

## 5. Theme Configuration

```dart
// Default — Cairo font, blue primary
AppTheme.dark()
AppTheme.light()

// Custom font
AppTheme.dark(fontFamily: 'Tajawal')

// Custom primary color
AppTheme.light(primaryColor: Color(0xFF10B981))

// Both
AppTheme.dark(fontFamily: 'Poppins', primaryColor: Color(0xFFE11D48))
```

## 6. Theme Mode from Preferences

```dart
BlocBuilder<AppPreferencesCubit, AppPreferencesState>(
  builder: (context, state) {
    return MaterialApp.router(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
    );
  },
)
```

## 7. New Feature Scaffold

```
lib/features/<feature>/
  data/
    data_source/<feature>_remote_data_source.dart
    models/<feature>_model.dart
    repos/<feature>_repo.dart
  presentation/
    cubit/<feature>_cubit.dart
    refactor/<feature>_body.dart
    screens/<feature>_screen.dart
    widgets/<feature>_card.dart
```
