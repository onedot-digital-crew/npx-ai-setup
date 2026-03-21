# Spec: Remove System-Specific Code

> **Spec ID**: 115 | **Created**: 2026-03-21 | **Status**: in-review | **Branch**: —

## Goal
Remove all system-specific code from ai-setup. The package becomes a pure generic base layer.

## Context
System-specific config (Shopify skills, Shopware MCP, Nuxt rules) now lives in boilerplate repos. ai-setup still bundles `lib/systems/*.sh` (6 plugins), `--system` flag, `select_system` TUI, `detect_system()`, and system-conditional logic scattered across generate.sh, update.sh, core.sh. All of this is dead weight. Also removes `--regenerate` (redundant with Auto-Init) and monorepo detection (unused). Part 1 of 3 — see Spec 134 (migrations) and Spec 135 (boilerplate pull).

## Steps
- [x] Step 1: Delete `lib/systems/` directory (6 files: shopify, nuxt, next, laravel, shopware, storyblok).
- [x] Step 2: Remove `load_system_plugins()` from `lib/_loader.sh`. Remove `source_lib "monorepo.sh"` from `bin/ai-setup.sh`.
- [x] Step 3: Remove `--system` and `--regenerate` flag parsing from `bin/ai-setup.sh` (lines 26-48, 68-89, 103-143). Remove `select_system` and `detect_system` calls.
- [x] Step 4: Remove `VALID_SYSTEMS`, `SHOPIFY_SKILLS_MAP`, `TS_RULES_MAP`, `SYSTEM_BOILERPLATES` from `lib/core.sh`. Remove `detect_system()` from `lib/detect.sh`. Remove `select_system()` from `lib/tui.sh`.
- [x] Step 5: Simplify `lib/generate.sh` — remove all `$SYSTEM`, `$SHOPWARE_*`, `$CTX_SHOPWARE` variables and system-conditional prompt sections. Context prompt becomes generic.
- [x] Step 6: Clean up `lib/update.sh` — remove `SHOPIFY_SKILLS_MAP` references and system-conditional logic in `scan_template_changes` and `_process_update_mappings`.
- [x] Step 7: Simplify `lib/setup-skills.sh` — remove system-specific skill install functions. Delete `lib/monorepo.sh` and `setup_repo_group_context()` from `lib/setup.sh`.
- [x] Step 8: Run `grep -r "SYSTEM\|system_plugin\|detect_system\|select_system\|SHOPIFY\|SHOPWARE\|regenerate\|REGEN_" lib/ bin/` to find and remove all orphan references.

## Acceptance Criteria
- [x] `lib/systems/` deleted (was already absent)
- [x] `lib/monorepo.sh` deleted (was already absent)
- [x] `--system` and `--regenerate` flags rejected with "unknown flag" error
- [x] Zero references to `SYSTEM`, `SHOPIFY_SKILLS_MAP`, `detect_system`, `select_system` in `lib/` and `bin/`
- [x] `bin/ai-setup.sh` runs successfully without any system flags

## Files to Modify
- `lib/systems/*.sh` — DELETE all 6 files
- `lib/monorepo.sh` — DELETE
- `bin/ai-setup.sh` — remove flags, system calls, regenerate mode
- `lib/_loader.sh` — remove load_system_plugins()
- `lib/core.sh` — remove system maps and constants
- `lib/detect.sh` — remove detect_system()
- `lib/tui.sh` — remove select_system()
- `lib/generate.sh` — remove system-conditional logic
- `lib/update.sh` — remove system-conditional logic
- `lib/setup-skills.sh` — remove system skill functions
- `lib/setup.sh` — remove setup_repo_group_context()

## Out of Scope
- Migration system (Spec 134)
- Boilerplate pull via gh (Spec 135)
- CLAUDE.md/AGENTS.md generation changes (Spec 131)
