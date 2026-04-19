## ADDED Requirements

### Requirement: Shell app exists at mobile/ and is the sole Flutter entry point
The `mobile/` directory at the repo root SHALL be the only runnable Flutter application in the monorepo. No `verticals/*/mobile/` package SHALL contain a `main.dart` or act as a standalone Flutter app.

#### Scenario: Only mobile/ has main.dart
- **WHEN** the repo is inspected for `main.dart` files
- **THEN** exactly one exists, at `mobile/lib/main.dart`

---

### Requirement: Shell registers vertical ModuleConfigs
`mobile/lib/features/shell/` SHALL explicitly import and register the `ModuleConfig` from each vertical Dart package. The shell SHALL pass registered configs to `kurolabs_hub`'s `HubScreen`.

#### Scenario: Questify module is registered
- **WHEN** the Flutter shell app launches
- **THEN** `kurolabs_hub` lists Questify as an available module in the launcher

---

### Requirement: Shell handles top-level routing via go_router
`mobile/` SHALL configure a top-level `go_router` that routes to: the auth flow, the `HubScreen` launcher, and delegates to each vertical's registered routes via `ModuleConfig`.

#### Scenario: Unauthenticated app launch
- **WHEN** the app launches with no stored session
- **THEN** go_router routes the user to the auth screen

#### Scenario: Authenticated app launch
- **WHEN** the app launches with a valid stored session
- **THEN** go_router routes the user to `HubScreen`

---

### Requirement: Shell references verticals as path dependencies
`mobile/pubspec.yaml` SHALL reference each vertical's Dart package via a `path:` dependency pointing to `../verticals/<name>/mobile/`.

#### Scenario: Flutter pub get resolves questify package
- **WHEN** `flutter pub get` is run in `mobile/`
- **THEN** the `questify_module` (or equivalent) package is resolved from the path dependency

---

### Requirement: questify/mobile is a Dart package with no app entry point
`verticals/questify/mobile/pubspec.yaml` SHALL declare `publish_to: 'none'` and SHALL NOT have a `main.dart`. It SHALL export a `ModuleConfig` via its primary library file.

#### Scenario: questify/mobile has no main.dart
- **WHEN** `verticals/questify/mobile/lib/` is inspected
- **THEN** there is no `main.dart` file

#### Scenario: ModuleConfig is exported
- **WHEN** the shell imports from the questify mobile package
- **THEN** a `ModuleConfig` type is available for registration with `kurolabs_hub`

---

### Requirement: Shell uses kurolabs_auth for Supabase auth
`mobile/` SHALL reference `shared/mobile/packages/kurolabs_auth/` as a path dependency and use its `authProvider` and `supabaseClientProvider` for auth state.

#### Scenario: Auth state is available throughout the app
- **WHEN** any screen in the shell or a vertical needs the current user
- **THEN** it can access auth state via the `authProvider` Riverpod provider
