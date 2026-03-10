# Spec: Developer Workflow Guide

> **Spec ID**: 071 | **Created**: 2026-03-10 | **Status**: draft

## Goal
Install a static `.claude/WORKFLOW-GUIDE.md` that teaches developers the daily AI workflow, commands, and Claude Code basics.

## Context
ONEDOT developers struggle with the ai-setup output — they don't know which commands to use, how the spec workflow works, or what hooks/context files do. A human-readable guide installed alongside the config gives immediate onboarding without adding token cost (not referenced in CLAUDE.md system context). Uses the existing `_install_or_update_file` mechanism.

## Steps
- [ ] Step 1: Create `templates/claude/WORKFLOW-GUIDE.md` with sections: Quick Start, Daily Workflow (spec-driven), Commands Reference (all installed commands with one-liner + example), Claude Code Essentials (context, subagents, hooks), Troubleshooting
- [ ] Step 2: Add `install_workflow_guide()` function in `lib/setup.sh` — copies template to `.claude/WORKFLOW-GUIDE.md` via `_install_or_update_file`
- [ ] Step 3: Call `install_workflow_guide` from the main install flow in `bin/ai-setup.sh`
- [ ] Step 4: Add a one-line reference in `templates/CLAUDE.md` Tips section pointing developers to the guide
- [ ] Step 5: Add `WORKFLOW-GUIDE.md` to the update selector in `lib/update.sh` so it stays current on re-runs

## Acceptance Criteria
- [ ] Running `npx @onedot/ai-setup` installs `.claude/WORKFLOW-GUIDE.md`
- [ ] Guide covers all installed slash commands with usage examples
- [ ] Guide is NOT referenced in CLAUDE.md context loading (no token cost)
- [ ] Re-running setup updates the guide without losing user modifications (checksum logic)

## Files to Modify
- `templates/claude/WORKFLOW-GUIDE.md` - new file, the guide content
- `lib/setup.sh` - new `install_workflow_guide()` function
- `bin/ai-setup.sh` - call the new install function
- `templates/CLAUDE.md` - one-line tip referencing the guide
- `lib/update.sh` - add to update selector

## Out of Scope
- Interactive `/guide` slash command (future enhancement)
- Video tutorials or external documentation
- Translating the guide to German (all templates stay English)
