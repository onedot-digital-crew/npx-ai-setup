# Spec: Context Monitor Hook

> **Spec ID**: 053 | **Created**: 2026-03-01 | **Status**: completed | **Branch**: spec/053-context-monitor-hook

## Goal
Add a PostToolUse hook that warns the agent before context window exhaustion via statusline bridge file metrics.

## Context
Context compaction fires at AUTOCOMPACT=30% but the agent has no advance warning — it starts complex tasks moments before compaction truncates its context. A PostToolUse hook reads remaining_percentage from a bridge file written by the statusline and injects WARNING (<=35%) or CRITICAL (<=25%) into the agent's conversation via `additionalContext`. Depends on statusline being installed; degrades silently without it. Inspired by gsd-build/get-shit-done `hooks/gsd-context-monitor.js`.

## Steps
- [x] Step 1: In `templates/statusline.sh`, after line 13, read `session_id` and `remaining_percentage` from the input JSON, then write `{"session_id":"...","remaining_percentage":N,"used_pct":N,"timestamp":EPOCH}` to `/tmp/claude-ctx-{session_id}.json`
- [x] Step 2: Create `templates/claude/hooks/context-monitor.sh` — reads `session_id` from stdin JSON, reads bridge file, checks `remaining_percentage` against thresholds (WARNING <=35%, CRITICAL <=25%), outputs `{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"..."}}` to stdout; debounce via `/tmp/claude-ctx-warn-{session_id}` counter file (5 calls between warnings); severity escalation (WARNING→CRITICAL) bypasses debounce; stale bridge (>60s) ignored; all errors exit 0
- [x] Step 3: In `templates/claude/settings.json`, add a PostToolUse entry with empty matcher for `context-monitor.sh` (after the existing tool-failure logger at line 112)
- [x] Step 4: Register `context-monitor.sh` in `lib/core.sh` hook template map (same pattern as other hooks) — auto-included via dynamic find scan, no manual registration needed

## Acceptance Criteria
- [x] Statusline writes bridge file with remaining_percentage on every render
- [x] Context monitor outputs additionalContext JSON at <=35% and <=25% thresholds
- [x] Debounce prevents warning spam (5 tool calls between warnings)
- [x] Silent exit 0 when bridge file missing, stale, or jq unavailable

## Files to Modify
- `templates/statusline.sh` - add bridge file writing (~5 lines)
- `templates/claude/hooks/context-monitor.sh` - new file (create)
- `templates/claude/settings.json` - add PostToolUse entry
- `lib/core.sh` - register hook in template map

## Out of Scope
- Making context monitor work without statusline installed
- Configurable thresholds (hardcoded 35%/25% is sufficient)
- JavaScript implementation (bash only, consistent with other hooks)

## Review Feedback

**[HIGH] `templates/claude/settings.json` — `PreCompact` hook section deleted (regression)**
The PreCompact hook block that exists on `main` is entirely absent from the branch. This is an unscoped regression — the spec only adds a PostToolUse entry, it must not remove the existing `PreCompact` block. Fix: restore the PreCompact section in settings.json.

**[HIGH] `session_id` used unsanitized in file paths (path traversal)**
Both `context-monitor.sh` and `statusline.sh` interpolate `SESSION_ID` directly into `/tmp/claude-ctx-${SESSION_ID}.json` without character validation. A malicious `session_id` like `../../../tmp/evil` could write outside `/tmp`. Fix: sanitize with `SESSION_ID=$(echo "$SESSION_ID" | tr -cd 'a-zA-Z0-9_-')` before use.

**[MEDIUM] Off-by-one in debounce counter**
Counter resets to `0` after firing, suppresses when `COUNTER < 5` — result is 4 calls between warnings, not 5. Fix: change condition to `[ "$COUNTER" -lt 6 ]` (i.e. `-le 5`).

**[MEDIUM] `REMAINING_PCT` truncation causes premature threshold trigger**
`cut -d. -f1` floors instead of rounds. At `used_percentage=64.1`, remaining is `35.9` but truncates to `35`, triggering WARNING falsely. Fix: use `printf '%.0f'` or `awk 'BEGIN{printf "%d", v+0.5}' v="$val"` for rounding.

**[MEDIUM] `printf` JSON output is not safe for special characters in MESSAGE**
If MESSAGE ever contains `"` or `%`, the JSON output breaks. Fix: use `jq -n --arg msg "$MESSAGE" '{hookSpecificOutput:{hookEventName:"PostToolUse",additionalContext:$msg}}'`.
