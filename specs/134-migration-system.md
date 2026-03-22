# Spec: Release Migration System

> **Spec ID**: 134 | **Created**: 2026-03-21 | **Status**: in-review | **Branch**: main

## Goal
Replace template-overwrite updates with versioned migration files that apply incremental changes.

## Context
Current update flow compares every template checksum and overwrites changed files. This is fragile: it can't rename files, remove obsolete config, or apply structural changes. A migration system applies versioned scripts sequentially, each describing exactly what changes. Requires Spec 115 (system removal) to be completed first — system-conditional logic would complicate migrations. Part 2 of 3.

## Steps
- [x] Step 1: Create `lib/migrations/` directory. Create migration runner in `lib/migrate.sh`: reads version from `.ai-setup.json`, finds all migration files > installed version, executes them in order.
- [x] Step 2: Implement migration helper functions: `_add_file`, `_update_file`, `_patch_line`, `_settings_add_permission`, `_settings_add_hook`, `_remove_file` (as described in Spec 115 architecture).
- [x] Step 3: Create first migration `lib/migrations/1.4.0.sh` capturing all changes since v1.3.5 (current version).
- [x] Step 4: Wire migration runner into `handle_version_check()` in `lib/update.sh` — when version differs, run migrations instead of `run_smart_update`.
- [x] Step 5: Update `write_metadata()` to record migration version after successful run (called after `run_migrations` in `handle_version_check`).
- [x] Step 6: Keep `run_smart_update` as fallback for major version jumps or `--force-reinstall`.

## Acceptance Criteria
- [x] `lib/migrations/` exists with at least one migration file
- [x] Updates apply migrations sequentially (not full template overwrite)
- [x] Each migration is idempotent (safe to run twice)
- [x] `.ai-setup.json` version is updated after migrations

## Files to Modify
- `lib/migrate.sh` — NEW: migration runner + helpers
- `lib/migrations/1.4.0.sh` — NEW: first migration
- `lib/update.sh` — wire migration runner into version check
- `bin/ai-setup.sh` — source migrate.sh

## Out of Scope
- System-specific migrations (system code removed in Spec 115)
- Rollback mechanism
- Boilerplate pull (Spec 135)
