## Why

Both the web and mobile apps currently drop users directly into Questify, making the platform feel single-purpose and blocking future vertical growth. A central hub makes KuroLabs a multi-vertical platform from the user's first interaction.

## What Changes

- The authenticated home route (`/`) of the web app becomes a vertical hub — a card grid listing all available verticals
- The mobile app's initial authenticated screen becomes the same hub, replacing any direct-to-Questify launch
- User Management is introduced as a first-class vertical (profile, account settings, character management) alongside Questify
- Each vertical card shows its name, icon, and a short description; tapping navigates into that vertical
- Unauthenticated users are redirected to login before seeing the hub

## Capabilities

### New Capabilities

- `vertical-hub`: Authenticated home screen rendered as a card grid of all available verticals; shared concept across web and mobile
- `user-management-vertical`: User Management vertical — entry point for profile editing, account settings, and character management

### Modified Capabilities

<!-- None — no existing specs exist yet -->

## Impact

- **Web**: `apps/web/app/page.tsx` (or equivalent root route) replaced with hub UI; routing to each vertical preserved
- **Mobile**: Flutter root widget / navigator updated to show hub screen as the post-login destination
- **Shared**: Vertical registry/config (list of verticals with metadata) lives in shared so both platforms consume it
- **Auth**: No auth changes; existing auth guards on both platforms redirect to hub after login
