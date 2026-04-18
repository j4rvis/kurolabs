# Claude Code Skills & Workflows

## OpenSpec workflow

OpenSpec is a structured change-management workflow. Config at `openspec/config.yaml`. Specs and changes live in `openspec/specs/` and `openspec/changes/`.

Use the following slash commands (via the Skill tool):

| Command | When to use |
|---------|-------------|
| `/opsx:explore` | Think through an idea before proposing |
| `/opsx:propose` | Create a new change with design, spec, and tasks |
| `/opsx:apply` | Implement tasks from an existing change |
| `/opsx:archive` | Finalize and archive a completed change |

## Available skills

| Skill | Purpose |
|-------|---------|
| `supabase` | Any task involving Supabase products or supabase-js |
| `supabase-postgres-best-practices` | Query/schema optimization |
| `claude-api` | Building with the Anthropic/Claude API |
| `simplify` | Review changed code for quality and reuse |
| `schedule` | Create/manage scheduled remote agents |

## GitHub Actions

- `.github/workflows/claude.yml` — Claude Code responds to `@claude` mentions in issues, PRs, and comments
- `.github/workflows/claude-code-review.yml` — Automated PR review

## Scaffold a new vertical

```bash
./scripts/new-vertical.sh <name> [--web] [--mobile] [--supabase]
```

See [verticals/index.md](verticals/index.md) for details.
