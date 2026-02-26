# Spec: Shopware 6 Self-Improving System

> **Spec ID**: 033 | **Created**: 2026-02-26 | **Status**: draft

## Goal
Add Shopware 6 template skills and a cross-system learnings mechanism so Claude improves with every session.

## Context
Shopware is a detected system with context generation but zero template skills (Shopify has 8). The learnings system captures insights across sessions via a `/learn` command and CLAUDE.md reference, benefiting all systems. Follows the existing Shopify skills pattern in core.sh/setup.sh/generate.sh.

## Steps
- [ ] Step 1: Create 6 SW6 skill templates in `templates/skills/shopware-*/prompt.md` (plugin-dev, dal, admin, storefront, api, testing)
- [ ] Step 2: Add `SHOPWARE_SKILLS_MAP` to `lib/core.sh` (6 entries, same pattern as `SHOPIFY_SKILLS_MAP`)
- [ ] Step 3: Add `install_shopware_skills()` to `lib/setup.sh` (clone `install_shopify_skills`, check `SYSTEM == *shopware*`)
- [ ] Step 4: Add SW6 skill deployment block in `lib/generate.sh` regeneration path (line ~291, mirror Shopify block)
- [ ] Step 5: Create `templates/commands/learn.md` — slash command that appends timestamped insights to `.agents/learnings/`
- [ ] Step 6: Add learnings section to `templates/CLAUDE.md` — read `.agents/learnings/` at session start, suggest `/learn` before session end
- [ ] Step 7: Add `mkdir -p .agents/learnings` to `lib/setup.sh` install flow and `.agents/learnings/` to gitignore template
- [ ] Step 8: Verify: `./bin/ai-setup.sh --system shopware` installs all 6 skills, `/learn` command present, CLAUDE.md references learnings

## Acceptance Criteria
- [ ] 6 Shopware skill templates exist with accurate SW6 6.6+ knowledge (DAL, DI, Twig, Vue.js 3, PHPUnit)
- [ ] `--system shopware` installs all 6 skills to `.claude/skills/shopware-*/prompt.md`
- [ ] `/learn` command creates/appends to `.agents/learnings/*.md` with timestamped entries
- [ ] CLAUDE.md template includes learnings section that loads accumulated knowledge at session start
- [ ] `--regenerate` deploys SW6 skills alongside commands/agents (same as Shopify path)

## Files to Modify
- `lib/core.sh` — add SHOPWARE_SKILLS_MAP
- `lib/setup.sh` — add install_shopware_skills(), mkdir learnings
- `lib/generate.sh` — add SW6 skills to regeneration block
- `templates/CLAUDE.md` — add learnings section
- 6 new files: `templates/skills/shopware-{plugin-dev,dal,admin,storefront,api,testing}/prompt.md`
- 1 new file: `templates/commands/learn.md`

## Out of Scope
- Shopware App System (manifest.xml apps) — separate spec if needed
- Learnings auto-pruning or deduplication logic
- Shopware Admin MCP setup changes (already handled in generate.sh)
