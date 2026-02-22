# Spec: Dynamic Template Map for Reliable Update Propagation

> **Spec ID**: 013 | **Created**: 2026-02-22 | **Status**: completed

## Goal
Replace hardcoded TEMPLATE_MAP with dynamic generation from `templates/` directory so all template changes automatically propagate to consumer projects.

## Context
TEMPLATE_MAP is manually maintained and already has gaps: `spec-work-all.md` missing from install loop, `hooks/README.md` missing from map entirely. Adding a new template requires updating 3 places. Dynamic generation eliminates this class of bugs.

## Steps
- [x] Step 1: Add `build_template_map()` function in `bin/ai-setup.sh` that scans `$SCRIPT_DIR/templates/` recursively and maps paths using prefix rules (claude/→.claude/, commands/→.claude/commands/, agents/→.claude/agents/, github/→.github/, specs/→specs/). Exclude `mcp.json` (special merge handling).
- [x] Step 2: Replace the hardcoded `TEMPLATE_MAP=()` array (lines 56-81) with a call to `build_template_map`
- [x] Step 3: Fix Section 4 hooks loop (line 1368) to derive file list from `templates/claude/hooks/` instead of hardcoded list
- [x] Step 4: Fix Section 6c commands loop (line 1407) to derive file list from `templates/commands/` instead of hardcoded list (fixes missing `spec-work-all.md`)
- [x] Step 5: Fix Section 6d agents loop (line 1420) to derive file list from `templates/agents/` instead of hardcoded list
- [x] Step 6: Test by running `./bin/ai-setup.sh` in a test directory — verify all templates are installed on fresh install and smart update detects all files

## Acceptance Criteria
- [x] Every file in `templates/` (except mcp.json) appears in TEMPLATE_MAP automatically
- [x] Adding a new template file to `templates/` requires zero changes to `bin/ai-setup.sh`
- [x] Fresh install and smart update both cover the same set of files
- [x] Existing checksum-based update logic (backup user-modified files) still works

## Files to Modify
- `bin/ai-setup.sh` — add `build_template_map()`, replace hardcoded array, update install loops

## Out of Scope
- MCP server config (`.mcp.json`) — stays with special merge logic
- Regeneration flow (CLAUDE.md, context files) — already dynamic
- CI/CD automation for publishing
