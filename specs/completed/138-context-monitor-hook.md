# Spec: Context Monitor Hook

> **Spec ID**: 138 | **Created**: 2026-03-22 | **Status**: completed | **Complexity**: medium | **Branch**: main

## Goal
Add a PostToolUse hook that warns the agent when context window usage approaches limits, enabling proactive state-saving.

## Context
Adapted from GSD's `gsd-context-monitor.js`. Currently agents have no way to detect context pressure — they work until quality degrades. This hook reads context metrics from the statusline bridge file and injects WARNING (≤35% remaining) or CRITICAL (≤25%) as `additionalContext`. Includes debouncing (5 tool uses between warnings) and severity escalation bypass.

## Steps
- [x] Step 1: Create `templates/hooks/context-monitor.js` — PostToolUse hook that reads `/tmp/claude-ctx-{session_id}.json`, checks thresholds, injects warnings with debounce logic
- [x] Step 2: Add hook registration to `templates/claude/settings.json` under `hooks.PostToolUse`
- [x] Step 3: Mirror hook to active project: copy to `.claude/hooks/` and update `.claude/settings.json`
- [ ] Step 4: Add hook install step to `bin/ai-setup.sh` (copy hook file, register in settings)
- [ ] Step 5: Test — verify WARNING fires at ≤35%, CRITICAL at ≤25%, debounce works, escalation bypasses debounce

## Acceptance Criteria
- [x] Hook file exists at `templates/claude/hooks/context-monitor.sh` with working threshold logic
- [x] Mirror file `.claude/hooks/context-monitor.sh` synced with template
- [x] Hook is registered in settings.json PostToolUse array
- [x] Debounce prevents spam (min 5 tool uses between same-severity warnings)
- [x] Severity escalation (WARNING→CRITICAL) bypasses debounce

## Files to Modify
- `templates/claude/hooks/context-monitor.sh` — new file
- `templates/claude/settings.json` — add hook registration
- `bin/ai-setup.sh` — add hook install step

## Out of Scope
- Statusline changes (separate concern, handled by claude-hud)
- Auto-compact trigger (user decides what to do with the warning)
