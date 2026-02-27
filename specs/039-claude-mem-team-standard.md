# Spec: Claude-Mem as Team Standard

> **Spec ID**: 039 | **Created**: 2026-02-27 | **Status**: in-progress | **Branch**: spec/039-claude-mem-team-standard

## Goal
Make claude-mem the default for every team member by changing opt-in to opt-out, adding folder context support to CLAUDE.md, and documenting the team expectation.

## Context
`install_claude_mem()` already exists in `lib/plugins.sh` and is called during init. It writes `enabledPlugins: {"claude-mem@thedotmack": true}` to `.claude/settings.json` which propagates to all team members via git — teammates are auto-prompted to install when they open the project. The only gaps: default prompt is `N` (skippable), no `<claude-mem-context>` placeholder in the CLAUDE.md template for folder context, and no team expectation documented.

## Steps
- [x] Step 1: In `lib/plugins.sh` `install_claude_mem()` — change the prompt default from `N` to `Y`: replace `read -p "   Install Claude-Mem? (y/N) "` with `read -p "   Install Claude-Mem? (Y/n) "` and update the condition to treat empty input as yes: `[[ "$INSTALL_CMEM" =~ ^[Nn]$ ]] && WITH_CLAUDE_MEM="no" || WITH_CLAUDE_MEM="yes"`
- [x] Step 2: Add `<claude-mem-context></claude-mem-context>` placeholder block to `templates/CLAUDE.md` — place it at the very end of the file so claude-mem can inject folder context without touching other sections
- [x] Step 3: Add a `## Required Plugins` section to `templates/CLAUDE.md` (before `## Communication Protocol`) — document that claude-mem is expected: install via `/plugin marketplace add thedotmack/claude-mem` then `/plugin install claude-mem`
- [x] Step 4: In `lib/plugins.sh` `install_claude_mem()` — update the skip message from `"⏭️  Claude-Mem skipped."` to a warning: `"⚠️  Claude-Mem skipped — team members will lack persistent memory. Re-run with --with-claude-mem to install."`
- [x] Step 5: Run `./tests/smoke.sh` to verify nothing broken

## Acceptance Criteria
- [x] Running `npx @onedot/ai-setup` prompts claude-mem with Y as default (pressing Enter installs it)
- [x] `templates/CLAUDE.md` contains `<claude-mem-context>` placeholder at end of file
- [x] `templates/CLAUDE.md` documents claude-mem as required plugin with install command
- [x] Skipping claude-mem shows a warning instead of silent skip
- [x] Smoke tests pass

## Files to Modify
- `lib/plugins.sh` — change default prompt + skip warning
- `templates/CLAUDE.md` — add `<claude-mem-context>` placeholder + Required Plugins section

## Out of Scope
- Forcing installation without prompt (user must still confirm)
- Changing the `--no-claude-mem` flag behavior
- Adding claude-mem to gitignore handling (folder context CLAUDE.md files in subdirs are committed by default — no gitignore needed)
- Shopware or other system-specific changes
