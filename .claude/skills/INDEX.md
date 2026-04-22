# Skills Index

Read this file to discover available skills. Do NOT scan individual skill files.

| Skill / Command | Invoke | Use when… |
|---|---|---|
| new-app | `.claude/skills/new-app.md` | Scaffolding a new vertical (product line). Runs `scripts/new-vertical.sh <name> [--web] [--mobile] [--supabase]`. Trigger phrases: "new vertical", "scaffold X app", "create a new app", "add a vertical". |
| supabase | skill: `supabase` | Any Supabase work: database, auth, edge functions, realtime, storage, RLS, migrations, supabase-js. |
| opsx:propose | `/opsx:propose` | Propose a new change — generates proposal.md, design.md, tasks.md. |
| opsx:apply | `/opsx:apply` | Implement tasks from an existing OpenSpec change. |
| opsx:explore | `/opsx:explore` | Thinking-partner mode — explore ideas, investigate problems, clarify requirements before proposing. |
| opsx:archive | `/opsx:archive` | Archive a completed change after implementation. |
| design-ingest | `.claude/skills/design-ingest.md` | Ingest a Claude Design handoff zip — copies files to permanent homes, updates the design skill, and deletes the zip. Trigger phrases: "incorporate the design zip", "ingest the design handoff", "new design zip", "/design-ingest". |
