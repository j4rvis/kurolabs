# API

There are two kinds of server-side endpoints: Next.js API routes and Supabase Edge Functions.

## Next.js API routes

Located at `verticals/<name>/web/app/api/`. Each route file is a standard App Router route handler (`route.ts`).

All routes are protected by `middleware.ts`. Inside a route handler, get an authenticated Supabase client with:

```ts
import { createClient } from '@kurolabs/web/supabase/server'
const supabase = await createClient()
```

The client is scoped to the authenticated user via their JWT — RLS enforces data isolation automatically.

### Questify routes

| Path | Methods | Purpose |
|------|---------|---------|
| `/api/quests` | GET, POST | List/create quests |
| `/api/quests/[id]` | GET, PATCH, DELETE | Single quest |
| `/api/quests/[id]/complete` | POST | Complete a quest (calls DB function) |
| `/api/characters` | GET, PATCH | Character sheet |
| `/api/village` | GET | NPC list + user connections |
| `/api/village/[npcId]/connect` | POST | Connect user to NPC |
| `/api/quest-givers` | GET, POST | List/invite quest givers |
| `/api/quest-givers/[id]` | PATCH, DELETE | Accept/revoke a giver |

## Supabase Edge Functions

Located at `verticals/<name>/supabase/functions/`. Written in Deno/TypeScript. Deployed to Supabase.

Use Edge Functions for:
- Operations requiring atomic DB transactions (e.g., `complete-quest` calls `complete_quest()`)
- Scheduled jobs (e.g., `daily-reset`)
- Webhooks or integrations

See [supabase.md](supabase.md) for deployment commands.
