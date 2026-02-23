# Spec: Move Shopify templates from commands to skills

> **Spec ID**: 019 | **Created**: 2026-02-23 | **Status**: completed

## Goal
Relocate Shopify knowledge templates from `.claude/commands/shopify/` to `.claude/skills/shopify-*/prompt.md` where they belong semantically.

## Context
The 8 Shopify templates (theme-dev, liquid, app-dev, graphql-api, hydrogen, checkout, functions, cli-tools) are reference/knowledge documents, not user-invokable commands. They were incorrectly placed under `templates/commands/shopify/`. Moving them to skills with the subdirectory convention (`.claude/skills/shopify-*/prompt.md`) matches their actual purpose. The overlapping `dragnoir/Shopify-agent-skills` entries in the skills.sh curated list will be removed since bundled templates are more detailed and version-controlled.

## Steps
- [x] Step 1: Create `templates/skills/` directory structure with 8 subdirs (`shopify-theme-dev/`, `shopify-liquid/`, etc.), move each `.md` → `prompt.md` inside its subdir
- [x] Step 2: Delete `templates/commands/shopify/` directory entirely
- [x] Step 3: In `bin/ai-setup.sh`, rename `SHOPIFY_TEMPLATE_MAP` to `SHOPIFY_SKILLS_MAP` and update all source→target paths to `templates/skills/shopify-*/prompt.md:.claude/skills/shopify-*/prompt.md`
- [x] Step 4: Update all install/update/uninstall references in `bin/ai-setup.sh` — change `commands/shopify` → `skills/shopify-*`, update `mkdir -p` targets and `cp` paths
- [x] Step 5: Remove `dragnoir/Shopify-agent-skills@*` entries (8 lines) from the shopify curated skills list in `bin/ai-setup.sh`
- [x] Step 6: Update dynamic template discovery in `bin/ai-setup.sh` if it scans `templates/commands/` — ensure it also discovers `templates/skills/`
- [x] Step 7: Bump version in `package.json` to 1.1.4, add CHANGELOG entry

## Acceptance Criteria
- [x] `templates/commands/shopify/` no longer exists
- [x] 8 skills exist at `templates/skills/shopify-*/prompt.md`
- [x] Running `./bin/ai-setup.sh --system shopify` installs to `.claude/skills/` not `.claude/commands/`
- [x] No `dragnoir/Shopify-agent-skills` references remain in setup script

## Files to Modify
- `templates/commands/shopify/*.md` → `templates/skills/shopify-*/prompt.md` (move)
- `bin/ai-setup.sh` — path mappings, install logic, curated skills list
- `package.json` — version bump
- `CHANGELOG.md` — release notes

## Out of Scope
- Content changes to the Shopify templates themselves
- Adding skills support for other systems (nuxt, next, etc.)
- Changing the skills.sh marketplace integration logic
