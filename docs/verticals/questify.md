# Vertical: Questify

D&D-themed habit/quest tracker. Users create quests, complete them for XP, and level up a character.

## Schema (on top of shared)

| Table | Key fields |
|-------|-----------|
| `epics` | user_id, name, icon_name, color_hex, ability_score, is_system |
| `quests` | user_id, epic_id, quest_giver_id, title, quest_type (daily/side/epic), difficulty, xp_reward, status (active/completed/failed/archived), streak, recurrence_rule |
| `quest_completions` | quest_id, user_id, xp_earned, ability_score, score_delta, notes — immutable audit log |
| `quest_givers` | user_id → giver_user_id relationships (pending/accepted/declined/revoked) |
| `npc_quest_givers` | Village NPCs (slug, name, title, category) |
| `npc_quest_templates` | Reusable quests per NPC (frequency, difficulty, xp_reward) |
| `user_npc_connections` | User ↔ NPC link |

## XP by difficulty

| Difficulty | XP |
|-----------|-----|
| Trivial | 25 |
| Easy | 50 |
| Medium | 100 |
| Hard | 250 |
| Deadly | 500 |
| Legendary | 1000 |

## DB functions

- `complete_quest(p_quest_id, p_user_id, p_notes?)` — atomic: marks quest done, awards XP, updates character ability scores, inserts completion log, recalculates level
- `reset_daily_quests()` — resets daily quest statuses (called by `daily-reset` edge function)

## Edge Functions (`verticals/questify/supabase/functions/`)

| Function | Trigger | Purpose |
|----------|---------|---------|
| `complete-quest` | HTTP POST | Calls `complete_quest()` DB function |
| `daily-reset` | Scheduled | Calls `reset_daily_quests()` |
| `invite-quest-giver` | HTTP POST | Creates a quest_givers invite row |

## Web routes (`verticals/questify/web/app/`)

- `/` — landing / auth redirect
- `/auth/` — login, signup, callback
- `/dashboard/` — main app shell
- `/api/quests/` — CRUD + complete action
- `/api/characters/` — character sheet
- `/api/village/` — NPC connections + templates
- `/api/quest-givers/` — invite flow

## Types file

`verticals/questify/web/lib/types.ts` — all Questify-specific TypeScript types (Quest, Epic, QuestCompletion, QuestGiver, NPC, etc.)

## Migrations order

Shared migrations `…000001`–`…000005` (symlinks) run before Questify-specific `…000010`+.
