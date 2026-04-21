## ADDED Requirements

### Requirement: User can view their thought statistics
The system SHALL provide authenticated users with a summary of their thought activity.

#### Scenario: Stats endpoint returns current counts
- **WHEN** an authenticated user requests their stats
- **THEN** the response includes:
  - `total_thoughts`: total thought count for the user
  - `thoughts_today`: count of thoughts created on the current calendar day (user's local date)
  - `total_connections`: total connection count across all user's thoughts
  - `top_tags`: up to 5 most-used tags with counts

#### Scenario: New user with no thoughts
- **WHEN** an authenticated user with zero thoughts requests stats
- **THEN** all counts are 0 and `top_tags` is an empty array

### Requirement: Stats are computed server-side
The system SHALL compute stats server-side (not client-side) to ensure accuracy and reduce payload size.

#### Scenario: Stats query
- **WHEN** the stats endpoint is called
- **THEN** the system queries the `thoughts` and `thought_connections` tables directly and returns aggregated results — no client-side computation required
