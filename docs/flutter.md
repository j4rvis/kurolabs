# Flutter

One Flutter shell app lives at `mobile/` (repo root). It owns auth, the KuroLabs launcher (via `kurolabs_hub`), and composes all vertical modules. Vertical-specific mobile code lives at `verticals/<name>/mobile/` as Dart packages — they export feature modules but have no standalone entry point.

## Shared packages

Both packages are referenced via path dependencies in `mobile/pubspec.yaml` and in each vertical's `pubspec.yaml`.

### `kurolabs_auth`
- Supabase client init + Riverpod auth provider
- Exposes `authProvider`, `supabaseClientProvider`, and the `AuthState` type

### `kurolabs_hub`
- Module launcher shell UI (go_router + Riverpod)
- Handles top-level routing and module registration
- The shell app passes all registered vertical `ModuleConfig`s to `HubScreen`

## Commands

From `mobile/`:

```bash
flutter run                   # run on connected device/emulator
flutter test                  # run all tests
flutter test test/foo_test.dart  # single test file
flutter build apk             # Android build
flutter build ios             # iOS build (macOS only)
flutter pub get               # install dependencies
```

For shared packages, run `flutter pub get` inside each package directory when changing their `pubspec.yaml`.

## Shell app structure (`mobile/`)

```
lib/
  core/
    theme/               # ThemeData, colors, text styles
    constants/           # App-wide constants
  features/
    shell/               # KuroLabs launcher — registers all vertical modules
  router/                # Top-level go_router configuration
  main.dart
```

## Vertical mobile modules

Each vertical's `verticals/<name>/mobile/` is a Dart package — it is **not** a standalone Flutter app and cannot run independently. It exports a `ModuleConfig` for `kurolabs_hub` registration plus all feature screens and providers.

```
verticals/<name>/mobile/
  lib/
    <name>_module.dart   # Exports ModuleConfig for hub registration
    screens/
    widgets/
    providers/           # Riverpod providers
  pubspec.yaml           # publish_to: none — no Flutter app entry point
```

The shell app references vertical packages via path dependencies, registers their `ModuleConfig`s, and `kurolabs_hub` handles routing into them.

## State management

Riverpod throughout. Providers are co-located with their feature modules in `verticals/<name>/mobile/lib/providers/`. The `kurolabs_hub` package provides the top-level router; verticals register their own routes via `ModuleConfig`.

## Dart version

Dart 3.11.4 (check `mobile/pubspec.yaml` for the SDK constraint).
