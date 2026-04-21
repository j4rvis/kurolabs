## ADDED Requirements

### Requirement: Hub is the authenticated home screen
After successful authentication, users SHALL land on the hub screen on both web and mobile. Unauthenticated users SHALL be redirected to the login screen before the hub is shown.

#### Scenario: Authenticated user opens app
- **WHEN** an authenticated user navigates to the root of the web app (`/`) or `/hub`, or opens the mobile app
- **THEN** they see the hub screen with all registered verticals displayed as cards

#### Scenario: Unauthenticated user attempts to access hub
- **WHEN** an unauthenticated user navigates to the hub URL on web or opens the mobile app
- **THEN** they are redirected to the login screen

#### Scenario: Authenticated user on login page
- **WHEN** an already-authenticated user visits the login page
- **THEN** they are redirected to the hub screen

### Requirement: Hub displays all registered verticals as a card grid
The hub SHALL display each registered vertical as a card in a grid layout. Each card SHALL show the vertical's name, icon, and a short description. Tapping or clicking a card SHALL navigate into that vertical.

#### Scenario: Hub renders Questify card
- **WHEN** the hub screen is displayed
- **THEN** a card for Questify is visible with its name, icon (⚔️), and description

#### Scenario: Hub renders User Management card
- **WHEN** the hub screen is displayed
- **THEN** a card for User Management is visible with its name, icon, and description

#### Scenario: User taps a vertical card
- **WHEN** the user taps or clicks a vertical card on the hub
- **THEN** the app navigates to that vertical's main screen

### Requirement: Registering a new vertical adds it to the hub
On web, adding an entry to the hardcoded `verticals` array in the shell dashboard SHALL cause it to appear on the hub. On mobile, registering a `ModuleConfig` in `registeredModules` SHALL cause it to appear in `HubScreen`.

#### Scenario: New vertical added to web hub config
- **WHEN** a developer adds a new entry to the `verticals` array in `(shell)/dashboard/page.tsx`
- **THEN** a new card appears on the web hub without any other code changes

#### Scenario: New module registered in mobile shell
- **WHEN** a developer adds a `ModuleConfig` to `registeredModules` in `modules.dart`
- **THEN** the new module's card appears in the mobile `HubScreen` without any other code changes
