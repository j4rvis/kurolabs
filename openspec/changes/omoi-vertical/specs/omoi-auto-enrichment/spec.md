## ADDED Requirements

### Requirement: Thought is auto-tagged on creation
After a thought is created, the system SHALL asynchronously extract relevant tags from the content and persist them to the thought's `tags` array column. The creation response SHALL NOT block on this process.

#### Scenario: Tags extracted and saved
- **WHEN** a thought is created with content
- **THEN** the `enrich-thought` edge function is invoked asynchronously
- **THEN** extracted tags are written back to the `tags` column within a reasonable time (< 5 seconds)

#### Scenario: No tags extractable
- **WHEN** the content contains no recognizable keywords or concepts
- **THEN** the `tags` column remains an empty array (no error is raised)

### Requirement: Thought category is auto-classified on creation
After a thought is created, the system SHALL asynchronously classify the thought into one of the defined categories: `question`, `reminder`, `insight`, `idea`, or `other`.

#### Scenario: Category classified and saved
- **WHEN** a thought is created with content
- **THEN** the `enrich-thought` edge function classifies the content and writes the result to the `category` column

#### Scenario: Classification uncertain
- **WHEN** the enrichment function cannot confidently classify the content
- **THEN** the category defaults to `other`

### Requirement: Enrichment is idempotent and re-triggerable
The system SHALL allow re-triggering enrichment for an existing thought without side effects. Re-running enrichment SHALL overwrite previous tags and category.

#### Scenario: Re-enrichment on content update
- **WHEN** a thought's content is updated
- **THEN** the enrichment function is re-triggered and the tags and category are refreshed

#### Scenario: Manual re-enrichment trigger
- **WHEN** an admin or system process calls the enrichment endpoint for a specific thought ID
- **THEN** the thought's tags and category are recomputed and saved
