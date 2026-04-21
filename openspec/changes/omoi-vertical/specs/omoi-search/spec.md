## ADDED Requirements

### Requirement: User can search thoughts by text
The system SHALL allow authenticated users to search their thoughts by a free-text query. The search SHALL match against thought content and tags.

#### Scenario: Text search returns matching thoughts
- **WHEN** an authenticated user searches with a non-empty query string
- **THEN** the system returns thoughts whose content or tags contain the query (case-insensitive)
- **THEN** results are ordered by relevance then recency

#### Scenario: Empty query returns error
- **WHEN** an authenticated user submits an empty search query
- **THEN** the system SHALL return a 400 error

#### Scenario: No results
- **WHEN** an authenticated user searches with a query that matches no thoughts
- **THEN** the system returns an empty array (not an error)

### Requirement: User can filter thoughts by tag
The system SHALL allow authenticated users to filter their thoughts by one or more tags.

#### Scenario: Single tag filter
- **WHEN** an authenticated user filters by a tag value
- **THEN** the system returns only thoughts that contain that tag in their `tags` array

#### Scenario: Multiple tag filter (AND)
- **WHEN** an authenticated user filters by multiple tags
- **THEN** the system returns thoughts that contain ALL specified tags

### Requirement: User can filter thoughts by category
The system SHALL allow authenticated users to filter their thoughts by category.

#### Scenario: Category filter
- **WHEN** an authenticated user filters by a category (e.g., `insight`)
- **THEN** the system returns only thoughts with that category

### Requirement: Search includes connected thoughts
When a thought matches a search query, the system SHOULD include a summary of its directly connected thoughts in the result.

#### Scenario: Search result with connections
- **WHEN** a search query matches a thought that has connections
- **THEN** each matching result includes a `connections` field with connected thought IDs and previews
