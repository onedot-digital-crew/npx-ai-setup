# Spec: Add optional global statusline install step to ai-setup.sh

> **Spec ID**: 046 | **Created**: 2026-02-28 | **Status**: in-review | **Branch**: spec/046-statusline-global-install

## Goal
Add an optional end-of-setup step that installs a statusline script to `~/.claude/statusline.sh` and configures it in `~/.claude/settings.json`.

## Context
Claude Code supports a configurable statusline (JSON via stdin → shell script → stdout). Since statusline config lives in `~/.claude/settings.json` (user-level, not project-level), it cannot be installed via the regular template map. This spec adds `install_statusline_global()` to `lib/setup.sh` — a one-time optional step prompted at the end of `bin/ai-setup.sh`. The script shows model, context-%, git branch, and session cost in two lines with color-coded context bar.

## Steps
- [x] Step 1: Create `templates/statusline.sh` — two-line script: line 1 = model + dir + git branch; line 2 = color-coded context bar (green/yellow/red) + cost + duration; handles null fields with fallbacks
- [x] Step 2: Add `install_statusline_global()` to `lib/setup.sh` — copies script to `~/.claude/statusline.sh`, makes it executable, merges `statusLine` field into `~/.claude/settings.json` using `jq` (idempotent: skip if already set)
- [x] Step 3: Prompt user at end of `bin/ai-setup.sh` setup phase: "Install statusline? (y/N)" — skip silently on N or if already installed
- [x] Step 4: Verify script works standalone: `echo '{"model":{"display_name":"Sonnet"},"context_window":{"used_percentage":42},"cost":{"total_cost_usd":0.05,"total_duration_ms":120000}}' | ~/.claude/statusline.sh`

## Acceptance Criteria
- [x] After install: `~/.claude/settings.json` contains `statusLine.command` pointing to `~/.claude/statusline.sh`
- [x] Script handles null `context_window.used_percentage` without crashing
- [x] Re-running setup skips the prompt if statusline is already configured (idempotent)
- [x] User can decline without any side effects

## Files to Modify
- `templates/statusline.sh` — new file (the script itself)
- `lib/setup.sh` — add install_statusline_global()
- `bin/ai-setup.sh` — call install_statusline_global() with user prompt

## Out of Scope
- Multi-theme options (one good default is enough)
- Windows/PowerShell support
- Updating an already-installed statusline (user edits ~/.claude/statusline.sh directly)
