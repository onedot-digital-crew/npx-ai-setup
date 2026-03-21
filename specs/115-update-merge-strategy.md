# Spec: Boilerplate-First Architecture with Release Migrations

> **Spec ID**: 115 | **Created**: 2026-03-21 | **Status**: draft | **Branch**: —

<!-- Absorbs Spec 077 (Base/System Split). System-specific config moves to boilerplate repos. Updates via release migrations instead of template overwrite. -->

## Goal
Remove system-specific code from ai-setup and replace template-overwrite updates with a migration system. Fresh installs copy templates. Subsequent runs apply only incremental migrations. System-specific config lives in boilerplate repos.

## Context
Projects are created from GitHub Template repos (sp-shopify-boilerplate etc.) that contain a full `.claude/` setup. ai-setup runs only for updates. The current approach (copy all templates, skip user-modified via checksum) is coarse — it either overwrites or skips entirely, with no ability to patch individual lines or add specific entries. A migration system applies targeted changes per version, preserving user customizations while delivering precise updates.

## Architecture

### Fresh Install (no `.ai-setup.json`)
Same as today: copy all templates, generate context, install plugins. Write version + checksums to `.ai-setup.json`.

### Update (`.ai-setup.json` exists)
1. Read `version` from `.ai-setup.json`
2. Find all migrations in `lib/migrations/` newer than that version
3. Execute each migration sequentially
4. Update version in `.ai-setup.json`

### Migration File Format
```bash
#!/bin/bash
# Migration: 1.4.0
# Changes: Add discover command, new permission, patch spec-work

migration_1_4_0() {
  _add_file "$TPL/commands/discover.md" ".claude/commands/discover.md"
  _settings_add_permission "Bash(npx playwright*)"
  _patch_line ".claude/commands/spec-work.md" "old content" "new content"
}
```

### Migration Helpers
- `_add_file <src> <target>` — install only if target missing
- `_update_file <src> <target>` — overwrite only if not user-modified (checksum)
- `_patch_line <file> <old> <new>` — sed-style replace, skip if old not found
- `_settings_add_permission <pattern>` — add to allow list if not present
- `_settings_add_hook <event> <hook>` — add hook entry if not present
- `_remove_file <target>` — delete if matches template checksum (not user-modified)

## Decisions (from discussion 2026-03-21)
1. `--system` flag: remove (system config is boilerplate responsibility)
2. Boilerplate detection: not needed
3. settings.json: section-by-section merge via migration helpers
4. `lib/systems/`: remove entirely
5. New files on update: auto-add via migrations
6. `--regenerate`: Claude reads project directly, no hardcoded system prompts

## Steps
- [ ] Step 1: Create migration infrastructure — `lib/migrations/` dir, migration runner in `lib/update.sh`, helper functions (`_add_file`, `_update_file`, `_patch_line`, `_settings_add_permission`, `_settings_add_hook`, `_remove_file`).
- [ ] Step 2: Create first migration `lib/migrations/1.4.0.sh` capturing all changes since v1.3.5 (new commands, updated hooks, etc.). This serves as the reference implementation.
- [ ] Step 3: Modify `bin/ai-setup.sh` update flow — when `.ai-setup.json` exists and version < current, run migrations instead of full template copy.
- [ ] Step 4: Delete `lib/systems/` (6 files). Remove `load_system_plugins()`, `--system` flag, `detect_system()`, system-guarded calls.
- [ ] Step 5: Simplify `generate.sh` — remove system-specific prompt variables. Claude reads project context directly.
- [ ] Step 6: Clean up `core.sh` (remove `VALID_SYSTEMS`, `SHOPIFY_SKILLS_MAP` refs), `setup-skills.sh` (remove system install functions), `detect.sh` (remove system detection).
- [ ] Step 7: Syntax-check + E2E test: fresh install in empty project + update in boilerplate project.

## Acceptance Criteria
- [ ] Fresh install works identically to today (template copy)
- [ ] Update applies only migrations, never full template copy
- [ ] `lib/systems/` does not exist
- [ ] `--system` flag is removed
- [ ] Migration helpers exist and are tested
- [ ] Running update in boilerplate project preserves all customizations

## Files to Modify
- `lib/migrations/` — new directory with migration files
- `lib/update.sh` — migration runner + helpers
- `bin/ai-setup.sh` — update flow dispatch
- `lib/systems/*.sh` — delete all
- `lib/_loader.sh` — remove `load_system_plugins()`
- `lib/generate.sh` — remove system prompts
- `lib/core.sh` — remove system maps
- `lib/setup-skills.sh` — remove system functions
- `lib/detect.sh` — remove system detection

## Out of Scope
- Boilerplate repo modifications (separate per-repo task)
- Auto-pull from boilerplate repos
- Rollback mechanism for migrations

## Complexity: high
