## ADDED Requirements

### Requirement: User can create a thought
The system SHALL allow authenticated users to create a new thought with at minimum a content string. Category and tags are optional at creation time (auto-enrichment fills them in asynchronously). The thought SHALL be immediately persisted with the provided content and associated to the user.

#### Scenario: Successful thought creation
- **WHEN** an authenticated user submits a non-empty content string
- **THEN** a new thought row is created in the `thoughts` table with `user_id`, `content`, `created_at`, and default `category = 'other'`
- **THEN** the response includes the newly created thought's `id` and `created_at`

#### Scenario: Empty content rejected
- **WHEN** an authenticated user submits an empty or whitespace-only content string
- **THEN** the system SHALL return a 400 error with message "Content is required"

#### Scenario: Unauthenticated creation rejected
- **WHEN** an unauthenticated request attempts to create a thought
- **THEN** the system SHALL return a 401 error

### Requirement: User can list their thoughts
The system SHALL allow authenticated users to retrieve their thoughts, paginated, ordered by `created_at` descending.

#### Scenario: Default listing
- **WHEN** an authenticated user requests their thoughts with no filters
- **THEN** the system returns up to 20 thoughts ordered newest-first with id, content, category, tags, created_at, updated_at

#### Scenario: Pagination
- **WHEN** an authenticated user provides a `cursor` (thought id) and `limit`
- **THEN** the system returns thoughts created before that cursor, up to the limit

### Requirement: User can read a single thought
The system SHALL allow authenticated users to fetch a thought by ID, including its connections.

#### Scenario: Existing thought
- **WHEN** an authenticated user requests a thought by its ID that they own
- **THEN** the system returns the thought with its tags, category, and list of connected thought IDs

#### Scenario: Thought not found or not owned
- **WHEN** an authenticated user requests a thought ID that does not exist or belongs to another user
- **THEN** the system SHALL return a 404 error

### Requirement: User can update a thought
The system SHALL allow authenticated users to update the content, category, or tags of a thought they own.

#### Scenario: Successful update
- **WHEN** an authenticated user submits updated fields for a thought they own
- **THEN** the thought row is updated and `updated_at` is refreshed

#### Scenario: Update triggers re-enrichment
- **WHEN** an authenticated user updates the content of a thought
- **THEN** the enrichment edge function is re-triggered asynchronously to refresh tags and category

### Requirement: User can delete a thought
The system SHALL allow authenticated users to delete a thought they own. Deletion SHALL cascade to remove all connections involving that thought.

#### Scenario: Successful deletion
- **WHEN** an authenticated user deletes a thought they own
- **THEN** the thought row is removed and all `thought_connections` rows referencing it are removed

#### Scenario: Delete not owned thought
- **WHEN** an authenticated user attempts to delete a thought they do not own
- **THEN** the system SHALL return a 404 error
