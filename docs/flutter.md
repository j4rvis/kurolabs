# Flutter

Flutter apps live at `verticals/<name>/mobile/`. Shared Flutter packages are at `shared/mobile/packages/`.

## Shared packages

Both packages are referenced via path dependencies in each vertical's `pubspec.yaml`.

### `kurolabs_auth`
- Supabase client init + Riverpod auth provider
- Exposes `authProvider`, `supabaseClientProvider`, and the `AuthState` type

### `kurolabs_hub`
- Module launcher shell UI (go_router + Riverpod)
- Handles top-level routing and module registration

## Commands

From `verticals/questify/mobile/` (or any vertical mobile dir):

```bash
flutter run                   # run on connected device/emulator
flutter test                  # run all tests
flutter test test/foo_test.dart  # single test file
flutter build apk             # Android build
flutter build ios             # iOS build (macOS only)
flutter pub get               # install dependencies
```

For shared packages, run `flutter pub get` inside each package directory when changing their `pubspec.yaml`.

## App structure

```
lib/
  core/
    theme/           # ThemeData, colors, text styles
    constants/       # App-wide constants
  modules/
    <vertical>/      # Feature modules (quests, character, village, auth)
      screens/
      widgets/
      providers/     # Riverpod providers
  router/            # go_router configuration
  main.dart
```

## State management

Riverpod throughout. Providers are co-located with their feature modules. The `kurolabs_hub` package provides the top-level router; verticals register their own routes.

## Dart version

Dart 3.11.4 (check `verticals/questify/mobile/pubspec.yaml` for the SDK constraint).
