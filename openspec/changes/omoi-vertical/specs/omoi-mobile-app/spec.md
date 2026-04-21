## ADDED Requirements

### Requirement: Omoi mobile app provides full CRUD for thoughts
The Flutter mobile module SHALL allow users to create, view, update, and delete thoughts. The module SHALL be registered in the KuroLabs hub and accessible from the launcher.

#### Scenario: Thought list screen
- **WHEN** a user opens Omoi in the mobile app
- **THEN** they see a list of their thoughts, ordered newest-first, with content preview, category, and tags

#### Scenario: Quick capture
- **WHEN** a user taps the "New Thought" button
- **THEN** a bottom sheet or dedicated screen opens with a text field for immediate capture

#### Scenario: Thought saved immediately
- **WHEN** a user submits a new thought
- **THEN** the thought is written to the database immediately and appears at the top of the list

### Requirement: Omoi mobile app provides a home screen widget for instant capture
The mobile app SHALL provide a platform widget (Android App Widget / iOS WidgetKit) that allows the user to type and submit a thought directly from the home screen without opening the app.

#### Scenario: Widget displays capture input
- **WHEN** the user has added the Omoi widget to their home screen
- **THEN** the widget shows a text input field and a submit button

#### Scenario: Widget submits thought
- **WHEN** the user types in the widget and taps submit
- **THEN** the thought is saved to the database and the widget shows a brief confirmation

### Requirement: Omoi mobile module is registered in the KuroLabs hub
The Omoi Flutter module SHALL export a `ModuleConfig` and be registered in the shell's hub launcher so it appears as an app card on the KuroLabs dashboard.

#### Scenario: Module registration
- **WHEN** the KuroLabs mobile shell initializes
- **THEN** the Omoi module appears as a card in the hub with its name, icon, and tap navigation
