## ADDED Requirements

### Requirement: User Management vertical exists as a registered vertical
A User Management vertical SHALL exist at `verticals/user-management/` following the standard vertical structure, with web and mobile packages that the shell composes. It SHALL appear as a card on the hub on both platforms.

#### Scenario: User Management visible on web hub
- **WHEN** an authenticated user views the web hub
- **THEN** a User Management card is visible and links to `/hub/user-management`

#### Scenario: User Management visible on mobile hub
- **WHEN** an authenticated user views the mobile hub
- **THEN** a User Management card is visible and navigates to the user management screen

### Requirement: User can view their profile
The User Management vertical SHALL display the current user's profile information in read-only view: display name, username, avatar, and character class.

#### Scenario: Profile screen displays user information
- **WHEN** the user navigates to the User Management vertical
- **THEN** they see their display name, username, avatar URL (or placeholder), and character class

#### Scenario: Profile loads from existing profile record
- **WHEN** the profile screen renders
- **THEN** it reads data from the `profiles` table for the authenticated user and displays it without requiring additional input

### Requirement: User can edit their display name and username
The User Management vertical SHALL allow users to update their `display_name` and `username` fields on their profile record.

#### Scenario: User updates display name
- **WHEN** the user edits their display name and saves
- **THEN** the `profiles.display_name` field is updated in the database and the UI reflects the new value

#### Scenario: Username uniqueness enforced
- **WHEN** the user attempts to save a username that is already taken
- **THEN** an error message is shown and the record is not updated

### Requirement: User can sign out from User Management
The User Management vertical SHALL provide a sign-out action that ends the user's session and redirects to the login screen.

#### Scenario: User signs out
- **WHEN** the user taps "Sign out" in the User Management vertical
- **THEN** the Supabase session is invalidated and the user is redirected to the login screen on both platforms
