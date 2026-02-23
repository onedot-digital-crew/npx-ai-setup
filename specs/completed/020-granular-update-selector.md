# Spec: Granular Template Update Selector

> **Spec ID**: 020 | **Created**: 2026-02-23 | **Status**: completed

## Goal
Allow users to select which template categories to update during a version-bump smart update instead of updating all files at once.

## Context
The smart update (option 1 on version bump) currently iterates the full `TEMPLATE_MAP` and copies every template. Users who only want e.g. updated commands must accept hook/settings changes too. A new `ask_update_parts` checkbox UI (same pattern as existing `ask_regen_parts`) lets users toggle 5 categories: Hooks, Settings, Commands, Agents, Other. The filter applies to the `TEMPLATE_MAP` loop in the smart update block.

## Steps
- [x] Step 1: Add `ask_update_parts` function (lines ~480) using same checkbox UI pattern as `ask_regen_parts`. 5 options: Hooks (`.claude/hooks/`), Settings (`.claude/settings.json`), Commands (`.claude/commands/`), Agents (`.claude/agents/`), Other (`specs/`, `github/`, `CLAUDE.md` template). Sets flags `UPD_HOOKS`, `UPD_SETTINGS`, `UPD_COMMANDS`, `UPD_AGENTS`, `UPD_OTHER`.
- [x] Step 2: Add `should_update_template` helper function that takes a template mapping string and returns 0/1 based on the `UPD_*` flags. Match by target path prefix: `.claude/hooks/` → UPD_HOOKS, `.claude/settings` → UPD_SETTINGS, `.claude/commands/` → UPD_COMMANDS, `.claude/agents/` → UPD_AGENTS, everything else → UPD_OTHER.
- [x] Step 3: Insert `ask_update_parts` call at line ~1214 (after "Analyzing templates..." echo, before the template loop). If returns 1 (nothing selected), skip to metadata update.
- [x] Step 4: Add `should_update_template "$mapping"` guard at top of the `TEMPLATE_MAP` loop (line ~1222) and the `SHOPIFY_TEMPLATE_MAP` loop (line ~1270). Skip entries that don't match selected categories.
- [x] Step 5: Update the summary output (line ~1304) to mention which categories were selected.

## Acceptance Criteria
- [x] Running smart update shows 5-category checkbox selector before template processing
- [x] Deselecting a category skips all template files in that category
- [x] Selecting nothing skips the template update entirely (goes straight to regen prompt)
- [x] Shopify templates respect the Commands filter
- [x] Fresh install and reinstall paths are NOT affected

## Files to Modify
- `bin/ai-setup.sh` — add `ask_update_parts`, `should_update_template`, integrate into smart update block

## Out of Scope
- Changing the `ask_regen_parts` regeneration selector (already works correctly)
- Adding CLI flags for non-interactive category selection
- Per-file selection (too granular, checkbox UI doesn't scale)
