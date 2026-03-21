# Spec: Boilerplate-First Architecture — Remove System Code, Smart Merge

> **Spec ID**: 115 | **Created**: 2026-03-21 | **Status**: draft | **Branch**: —

<!-- Absorbs Spec 077 (Base/System Split). System-specific config moves to boilerplate repos. -->

## Goal
Remove all system-specific code from ai-setup. The package becomes a pure generic base layer. System-specific config (skills, MCP, rules) lives in boilerplate repos. Update flow uses section-by-section merge for settings.json and adds new files without overwriting existing ones.

## Context
Projects are created from boilerplate repos that already contain system-specific `.claude/` setup. ai-setup currently duplicates this via `lib/systems/*.sh`. After removal, ai-setup provides only: hooks, commands, agents, rules, settings, plugins. System detection (`--system`) becomes unnecessary. `--regenerate` relies on Claude reading the project directly instead of hardcoded system prompts.

## Decisions (from discussion 2026-03-21)
1. `--system` flag: evaluate removal feasibility, deprecate if possible
2. Boilerplate detection: not needed — treat every project the same
3. settings.json: section-by-section merge (hooks, permissions, env separately)
4. `lib/systems/`: remove entirely
5. New files on update: auto-add, never overwrite existing
6. `--regenerate`: Claude reads project via repomix/files, no hardcoded system prompts

## Steps
- [ ] Step 1: Delete `lib/systems/` directory (6 files). Remove `load_system_plugins()` from `_loader.sh`. Remove system plugin calls from `bin/ai-setup.sh`.
- [ ] Step 2: Remove `--system` flag from `bin/ai-setup.sh`. Remove `detect_system()` from `detect.sh`. Remove `VALID_SYSTEMS` array from `core.sh`. Remove system-guarded calls (`install_shopify_skills`, `install_storyblok_scripts`).
- [ ] Step 3: Simplify `generate.sh` — remove `system_get_default_skills` call, remove `CTX_SHOPWARE`/`SHOPWARE_INSTRUCTION`/`SHOPWARE_RULE` from prompts. Claude gets raw project context only (package.json, file tree, existing CLAUDE.md).
- [ ] Step 4: Implement section-by-section merge for `settings.json` in `setup.sh`. Merge strategy: add new hook entries, add new permission entries, preserve user-added entries. Never remove existing entries.
- [ ] Step 5: Update `_install_or_update_file()` — new files always install, existing files with matching checksum update silently, user-modified files are skipped with notice.
- [ ] Step 6: Remove `install_shopify_skills`, `install_storyblok_scripts` from `setup-skills.sh`. Remove `SHOPIFY_SKILLS_MAP` references from remaining code.
- [ ] Step 7: Syntax-check all files. E2E test in fresh project + boilerplate-based project.

## Acceptance Criteria
- [ ] `lib/systems/` directory does not exist
- [ ] `--system` flag is removed or deprecated with warning
- [ ] `settings.json` is merged section-by-section, not overwritten
- [ ] Running in a boilerplate project preserves all existing files
- [ ] New commands/agents from ai-setup updates are auto-added
- [ ] `--regenerate` works without system-specific prompts

## Files to Modify
- `lib/systems/*.sh` — delete all 6 files
- `lib/_loader.sh` — remove `load_system_plugins()`
- `bin/ai-setup.sh` — remove `--system`, `detect_system`, system guards
- `lib/detect.sh` — remove `detect_system()` or simplify
- `lib/generate.sh` — remove system-specific prompt sections
- `lib/setup.sh` — implement section merge for settings.json
- `lib/setup-skills.sh` — remove system-specific functions
- `lib/core.sh` — remove `VALID_SYSTEMS`, system-specific maps

## Out of Scope
- Boilerplate repo modifications (separate task per repo)
- Auto-pull from boilerplate repos via GitHub API
- Two-mode architecture (rejected from Spec 077)

## Complexity: high
