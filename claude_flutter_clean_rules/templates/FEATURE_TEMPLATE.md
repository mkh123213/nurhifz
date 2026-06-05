# Feature Template

Use this structure when adding a new feature to the project.

## Folder Structure

```
lib/features/<feature>/
  data/
    data_source/<feature>_remote_data_source.dart
    models/<feature>_model.dart
    repos/<feature>_repo.dart
  presentation/
    cubit/<feature>_cubit.dart
    cubit/<feature>_state.dart          # if using separate state file
    refactor/<feature>_body.dart
    refactor/<feature>_view_data.dart   # if feature needs UI-specific DTOs
    screens/<feature>_screen.dart
    widgets/<feature>_card.dart
    widgets/<feature>_empty_view.dart
    widgets/<feature>_loading_view.dart
    widgets/<feature>_error_view.dart
```

## Screen Pattern

```dart
class FeatureScreen extends StatelessWidget {
  const FeatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FeatureCubit>()..load(),
      child: const FeatureBody(),
    );
  }
}
```

## Body Pattern

```dart
class FeatureBody extends StatelessWidget {
  const FeatureBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeatureCubit, FeatureState>(
      builder: (context, state) {
        if (state.isLoading) return const AppLoadingOverlay();
        if (state.error != null) {
          return AppErrorState(
            message: state.error!,
            onRetry: () => context.read<FeatureCubit>().load(),
          );
        }
        if (state.items.isEmpty) {
          return AppEmptyState(
            message: 'empty_message'.tr(),
            icon: Icons.inbox_outlined,
          );
        }
        return RefreshIndicator(
          onRefresh: () => context.read<FeatureCubit>().refresh(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => FeatureCard(item: state.items[i]),
          ),
        );
      },
    );
  }
}
```

## Service Locator Registration

```dart
// In service_locator.dart
sl.registerLazySingleton(() => FeatureRemoteDataSource(sl()));
sl.registerLazySingleton(() => FeatureRepo(sl()));
sl.registerFactory(() => FeatureCubit(sl()));
```
