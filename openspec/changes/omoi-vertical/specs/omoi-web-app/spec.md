## ADDED Requirements

### Requirement: Omoi web app provides a thought capture and management UI
The system SHALL provide a web interface for users to create, view, search, and manage their thoughts. The web app SHALL be built as a Next.js module under `verticals/omoi/web/` and integrated into the KuroLabs shell at `web/app/(omoi)/`.

#### Scenario: Dashboard view
- **WHEN** an authenticated user navigates to the Omoi dashboard
- **THEN** they see their recent thoughts, today's stats, and a quick-capture input

#### Scenario: Full thought list
- **WHEN** an authenticated user views the full thought list
- **THEN** thoughts are paginated, showing content preview, category badge, tags, and creation date

#### Scenario: Thought detail view
- **WHEN** an authenticated user opens a single thought
- **THEN** they see full content, category, tags, connections, and options to edit or delete

### Requirement: Omoi web app provides thought search and filter UI
The web app SHALL provide a search bar and filter controls for tag and category filtering.

#### Scenario: Search bar
- **WHEN** a user types in the search bar
- **THEN** results update to show matching thoughts (with a short debounce)

#### Scenario: Tag filter chips
- **WHEN** a user clicks a tag chip
- **THEN** the list filters to thoughts with that tag

#### Scenario: Category filter
- **WHEN** a user selects a category from a dropdown
- **THEN** the list filters to thoughts in that category

### Requirement: Omoi web app routes are protected
All Omoi web routes SHALL be protected by the shell's auth middleware. Unauthenticated users are redirected to the login page.

#### Scenario: Unauthenticated access
- **WHEN** an unauthenticated user navigates to any `/omoi/*` route
- **THEN** they are redirected to `/auth/login`
