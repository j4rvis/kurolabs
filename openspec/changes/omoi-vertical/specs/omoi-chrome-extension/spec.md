## ADDED Requirements

### Requirement: Chrome extension allows quick thought capture
The Omoi Chrome extension SHALL provide a browser popup that allows the user to type and submit a thought without leaving the current tab. The thought is saved to the user's Omoi account via the Supabase API.

#### Scenario: User opens popup and submits a thought
- **WHEN** an authenticated user clicks the Omoi extension icon
- **THEN** a popup opens with a text area and a submit button
- **WHEN** the user types a thought and clicks submit
- **THEN** the thought is saved to the Omoi backend and the popup shows a success confirmation

#### Scenario: Popup pre-fills page context
- **WHEN** the user opens the popup on a web page
- **THEN** the popup MAY pre-fill a reference to the current page URL as additional context (not the full content)

#### Scenario: Submission fails
- **WHEN** the API call fails (network error, server error)
- **THEN** the popup displays an error message and allows the user to retry

### Requirement: Chrome extension authenticates via Supabase session
The extension SHALL authenticate the user using a Supabase session token stored in `chrome.storage.local`. The session is populated when the user logs in via the Omoi web app.

#### Scenario: User is already logged in
- **WHEN** a valid session token exists in `chrome.storage.local`
- **THEN** the popup opens directly to the capture UI without prompting for login

#### Scenario: User is not logged in
- **WHEN** no valid session token exists in `chrome.storage.local`
- **THEN** the popup displays a message directing the user to log in via the Omoi web app
- **THEN** a "Open Omoi" button opens the web app login page in a new tab

#### Scenario: Session expires
- **WHEN** the stored session token is expired
- **THEN** the extension attempts to refresh the token using the stored refresh token
- **WHEN** refresh fails
- **THEN** the extension clears the session and prompts re-login

### Requirement: Chrome extension is packaged as Manifest V3
The extension SHALL be built as a Manifest V3 extension compatible with Chrome 88+.

#### Scenario: Extension structure
- **WHEN** the extension is loaded
- **THEN** the manifest includes: `manifest_version: 3`, popup action, `storage` permission, and `host_permissions` for the Supabase project URL

### Requirement: Extension source lives under the vertical
The Chrome extension source SHALL be located at `verticals/omoi/chrome-extension/` and is a first-class sub-app of the vertical, alongside `web/`, `mobile/`, and `supabase/`.

#### Scenario: Extension directory structure
- **WHEN** the `verticals/omoi/chrome-extension/` directory is present
- **THEN** it contains: `manifest.json`, `popup.html`, `popup.js` (or a bundled build), `background.js`, and an `icons/` directory

### Requirement: Omoi web app provides a Chrome extension download link
The Omoi web app SHALL include a page or section where users can download or install the Chrome extension.

#### Scenario: Download page accessible
- **WHEN** an authenticated user navigates to `/omoi/chrome-extension`
- **THEN** the page displays extension features, screenshots or description, and a link to install from the Chrome Web Store (or a `.crx` download for development builds)
