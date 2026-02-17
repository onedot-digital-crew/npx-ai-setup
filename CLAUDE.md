# CLAUDE.md

## Communication Protocol
No small talk. Just do it.
Confirmations one word (Done, Fixed). Show code changes as diff only.
If you edit the same file 3+ times without progress, stop and ask for guidance.

## Project
- NPM package `@onedot/ai-setup` — scaffolding tool for AI-assisted development
- Entry point: `bin/ai-setup.sh` (Bash, POSIX-compatible where possible)
- Templates in `templates/` are copied 1:1 into target projects
- Published via `npm publish`, executed via `npx @onedot/ai-setup`

## Key Files
- `bin/ai-setup.sh` — Main setup script (~1670 lines)
- `templates/CLAUDE.md` — CLAUDE.md template for target projects
- `templates/claude/settings.json` — Claude settings template
- `templates/claude/hooks/` — Hook scripts (protect-files, circuit-breaker, post-edit-lint, context-freshness)
- `templates/commands/` — Slash command templates (spec.md, spec-work.md)
- `templates/specs/` — Spec workflow templates (TEMPLATE.md, README.md)
- `README.md` — NPM package documentation

## Commands
- No build step — pure shell script
- `bash -n bin/ai-setup.sh` — Syntax validation
- `npx . --regenerate` — Test regeneration locally

## Critical Rules
- All template content MUST be in English (no German in generated files)
- No umlauts in files (use ae, oe, ue)
- Templates are copied 1:1 — they must work standalone in any target project
- Shell script must work on macOS (bash 3.2) and Linux (bash 4+)
- Use `cksum` not `md5` (POSIX compatibility)
- Hook scripts must be lightweight (<50ms, no API calls)
- Generation prompts run in target projects — keep token usage minimal

## Spec-Driven Development
Specs live in `specs/` — structured task plans created before coding.

**When to suggest a spec:** Changes across 3+ files, new features, template changes.
**Skip specs for:** Single-file fixes, README updates.

**Workflow:**
1. `/spec "task"` — create spec
2. Review and refine
3. `/spec-work NNN` — execute step by step
4. Completed specs move to `specs/completed/`
