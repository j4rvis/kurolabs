## ADDED Requirements

### Requirement: Vertical hub exposes Chrome extension download links
The KuroLabs launcher/hub SHALL surface a Chrome extension download link for any vertical that ships a Chrome extension. The link SHALL direct users to the vertical's extension download page.

#### Scenario: Extension link visible in launcher
- **WHEN** an authenticated user views the KuroLabs launcher dashboard
- **THEN** verticals that have a Chrome extension show a "Get Extension" link or button alongside the app card

#### Scenario: Extension link navigates to download page
- **WHEN** a user clicks the "Get Extension" link for a vertical
- **THEN** they are navigated to the vertical's Chrome extension page (e.g., `/omoi/chrome-extension`)
