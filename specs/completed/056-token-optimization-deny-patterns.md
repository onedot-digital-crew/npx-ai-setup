# Spec: Token Optimization — Deny Patterns, Tips & Settings

> **Spec ID**: 056 | **Created**: 2026-03-04 | **Status**: completed | **Branch**: spec/056-token-optimization-deny-patterns

## Goal
Expand deny patterns, add missing session tips, and configure plansDirectory to reduce token waste and improve workflow.

## Context
Current deny list covers 7 paths but misses lock files (10k+ lines), source maps, minified assets, and cache dirs. CLAUDE.md Tips section lacks checkpointing (`Esc Esc`), `/rename`+`/resume`, and commit-checkpoint advice. The `plansDirectory` setting is missing. Playwright references need removal (per spec 055). Informed by rtk, token-optimizer, ACE-FCA patterns, and Claude Code best practices.

## Steps
- [ ] Step 1: Add lock file deny patterns to `templates/claude/settings.json` — `Read(package-lock.json)`, `Read(yarn.lock)`, `Read(pnpm-lock.yaml)`, `Read(bun.lockb)`, `Read(composer.lock)`
- [ ] Step 2: Add framework/cache deny patterns — `Read(.turbo/**)`, `Read(.vercel/**)`, `Read(.svelte-kit/**)`, `Read(.cache/**)`, `Read(.parcel-cache/**)`, `Read(storybook-static/**)`
- [ ] Step 3: Add minified/generated asset deny patterns — `Read(*.min.js)`, `Read(*.min.css)`, `Read(*.map)`, `Read(*.chunk.js)`
- [ ] Step 4: Add `"plansDirectory": ".claude/plans"` and `"enableAllProjectMcpServers": true` to `templates/claude/settings.json`
- [ ] Step 5: Expand Tips section in `templates/CLAUDE.md` — add `Esc Esc` (rewind/summarize), `/rename` + `/resume`, commit-after-task checkpoint rule
- [ ] Step 6: Remove Playwright references — MCP section in CLAUDE.md, `Bash(npx playwright *)` from settings.json allow list
- [ ] Step 7: Add rtk + GSD as optional extensions in README.md
- [ ] Step 8: Verify settings.json is valid JSON and deny patterns don't block legitimate dev files

## Acceptance Criteria
- [ ] Deny list covers lock files, cache dirs, minified assets, source maps
- [ ] Tips section includes checkpointing, session management, and commit advice
- [ ] `plansDirectory` and `enableAllProjectMcpServers` are configured in settings.json
- [ ] No Playwright references remain in templates

## Files to Modify
- `templates/claude/settings.json` — deny patterns, plansDirectory, remove playwright
- `templates/CLAUDE.md` — tips expansion, remove Playwright MCP section
- `README.md` — optional extensions (rtk, GSD)

## Out of Scope
- Installing rtk automatically (external binary, user choice)
- Output Styles templates (CLAUDE.md Communication Protocol covers this)
- Beads/graph task trackers (too early, GSD covers similar needs)
