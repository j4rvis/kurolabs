## ADDED Requirements

### Requirement: User can connect two thoughts
The system SHALL allow authenticated users to create a connection between two thoughts they own. Connections are undirected and unique.

#### Scenario: Successful connection
- **WHEN** an authenticated user connects thought A to thought B (both owned by the user)
- **THEN** a row is inserted into `thought_connections` with the lower ID stored as `thought_id_a`

#### Scenario: Duplicate connection rejected
- **WHEN** an authenticated user attempts to connect two thoughts that are already connected
- **THEN** the system SHALL return a 409 error with message "Connection already exists"

#### Scenario: Self-connection rejected
- **WHEN** an authenticated user attempts to connect a thought to itself
- **THEN** the system SHALL return a 400 error with message "Cannot connect a thought to itself"

#### Scenario: Connection to unowned thought rejected
- **WHEN** an authenticated user attempts to connect a thought they own to a thought owned by another user
- **THEN** the system SHALL return a 404 error

### Requirement: User can remove a connection
The system SHALL allow authenticated users to remove a connection between two thoughts they own.

#### Scenario: Successful disconnection
- **WHEN** an authenticated user removes a connection between two thoughts they own
- **THEN** the `thought_connections` row is deleted

#### Scenario: Connection not found
- **WHEN** an authenticated user attempts to remove a connection that does not exist
- **THEN** the system SHALL return a 404 error

### Requirement: Connected thoughts are returned when reading a thought
When fetching a single thought, the system SHALL include the IDs (and optionally summaries) of all thoughts connected to it.

#### Scenario: Fetch thought with connections
- **WHEN** an authenticated user fetches a thought that has connections
- **THEN** the response includes a `connections` array with the IDs and short content previews of connected thoughts
