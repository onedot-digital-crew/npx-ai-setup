# Spec: Pure Script Commands (spec-board, doctor, release)

> **Spec ID**: 116 | **Created**: 2026-03-21 | **Status**: draft | **Branch**: —

## Goal
Replace `/spec-board`, `/doctor`, and `/release` with pure Bash scripts that produce output with zero LLM tokens.

## Context
These three commands perform deterministic operations (file parsing, status checks, version bumps) that don't need Claude's intelligence. Moving them to Bash scripts saves ~95% of their token cost. Scripts live in `templates/scripts/` and are copied to `.claude/scripts/` during setup. Commands call scripts via `!` prefix.

## Steps
- [ ] Step 1: Create `templates/scripts/spec-board.sh` — reads all `specs/*.md`, parses frontmatter Status/Steps, outputs Kanban table as Markdown
- [ ] Step 2: Create `templates/scripts/doctor.sh` — 12 checks (hooks exist, settings.json valid, context files present, CLAUDE.md size, MCP servers, skills, git config), outputs results table
- [ ] Step 3: Create `templates/scripts/release.sh` — version bump in package.json, CHANGELOG entry template, git tag, git push with confirmation gate
- [ ] Step 4: Update corresponding command `.md` files to call scripts via `!.claude/scripts/<name>.sh` instead of Claude-driven logic
- [ ] Step 5: Add `scripts/` directory to `bin/ai-setup.sh` install flow (copy templates/scripts/ → .claude/scripts/, chmod +x)
- [ ] Step 6: Verify all 3 scripts work standalone (`bash .claude/scripts/spec-board.sh`) and produce correct output

## Acceptance Criteria
- [ ] All 3 commands produce output without consuming LLM tokens
- [ ] Scripts are idempotent and work on macOS + Linux (bash 3.2+)
- [ ] `bin/ai-setup.sh` installs scripts directory during setup
- [ ] Existing command files updated to delegate to scripts

## Files to Modify
- `templates/scripts/spec-board.sh` — new
- `templates/scripts/doctor.sh` — new
- `templates/scripts/release.sh` — new
- `templates/commands/spec-board.md` — delegate to script
- `templates/commands/release.md` — delegate to script
- `bin/ai-setup.sh` — add scripts install step

## Out of Scope
- Hybrid commands (scan, commit, test) — see Spec 117
- New `/doctor` command creation — this spec handles doctor as pure script
