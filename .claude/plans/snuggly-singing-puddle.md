# Setup Audit: Performance, Overhead & Missing Pieces

## Context

Full audit of the npx-ai-setup Claude Code configuration for:
1. Best-practice compliance and known bugs
2. Unnecessary overhead (hooks that always no-op, noisy output)
3. Missing pieces that would increase quality
4. Expanding the local-shell-first pattern to save tokens while maximizing quality

---

## What's Working Well (don't touch)

- Hook architecture is comprehensive and covers every lifecycle event
- `circuit-breaker.sh` is well-tuned with spec-aware thresholds
- `context-reinforcement.sh` iron-law pattern survives compaction
- `test-prep.sh` / `lint-prep.sh` zero-token green-path is exactly right
- `transcript-ingest.sh` + memory recall is solid cross-session learning
- `tool-redirect.sh` enforces rtk/gh routing cleanly
- Permission allow/deny model is well thought out
- RTK integration + `BASH_MAX_OUTPUT_LENGTH: 12000` combo is correct

---

## Bug 1 — `context-monitor.sh` is dead code (HIGH)

**Problem:** `context-monitor.sh` reads from `/tmp/claude-ctx-${SESSION_ID}.json` (bridge file), but nothing ever writes that file. `statusline.sh` calculates `pct_used` and renders it to the terminal but never writes to `/tmp`. The hook silently exits at line 11 (`[ -f "$BRIDGE_FILE" ] || exit 0`) on every single PostToolUse call.

**Fix:** Add a bridge file write to `statusline.sh` — after `pct_used` is calculated and before rendering, write the JSON:

```bash
# After pct_used is computed (~line 136), write bridge for context-monitor.sh
SESSION_ID=$(echo "$input" | jq -r '.session_id // ""' 2>/dev/null | tr -cd 'a-zA-Z0-9_-')
if [ -n "$SESSION_ID" ]; then
  printf '{"timestamp":%s,"remaining_percentage":%s}\n' \
    "$(date +%s)" "$(( 100 - pct_used ))" \
    > "/tmp/claude-ctx-${SESSION_ID}.json" 2>/dev/null || true
fi
```

This must be inserted **before** the output block (the `printf "%b" "$line1"` near line 346), after `pct_used` is set (~line 137 in statusline.sh).

**File:** `.claude/scripts/statusline.sh` (add ~4 lines after line 137)

---

## Bug 2 — `context-reinforcement.sh` timeout likely wrong (MEDIUM)

**Problem:** In `settings.json`, most hook timeouts are clearly in **seconds** (30s for ESLint, 120s for the Haiku LLM call in transcript-ingest). That makes `context-reinforcement.sh`'s `"timeout": 5000` = 5000 seconds ≈ 83 minutes — an accidentally infinite timeout for a script that runs in <1ms.

**Fix:** Change `"timeout": 5000` → `"timeout": 5` for `context-reinforcement.sh` in `settings.json` line 116.

```json
// before
"timeout": 5000

// after
"timeout": 5
```

**File:** `.claude/settings.json` line 116

---

## Bug 3 — `context-freshness.sh` emits permanent noise (LOW)

**Problem:** For this bash CLI project (no JS/TS), `context-freshness.sh` emits `[HINT] No graph.json found. Run /analyze...` on **every single user prompt** (lines 69–71). There is no graph.json and `/analyze` on a bash project produces minimal value. This is constant noise.

**Fix:** Add a project-type guard — suppress the graph.json hint when there's no `package.json`, since graph.json is only meaningful for JS/TS projects:

```bash
# Line 69 — change condition:
# Before:
if [ ! -f "$GRAPH_FILE" ] && [ -f "package.json" ]; then

# After: (already gated on package.json — this IS the fix, it's already correct!)
# Wait: the condition IS gated on package.json. But this project HAS a package.json
# (it's an npm-distributed package). So the hint fires.
# Fix: also check for src/ or app/ directory typical of JS apps:
if [ ! -f "$GRAPH_FILE" ] && [ -f "package.json" ] && [ -d "src" -o -d "app" -o -d "pages" ]; then
```

**File:** `.claude/hooks/context-freshness.sh` line 69

---

## Gap 1 — `decisions.md` is empty (MEDIUM)

The file exists but has zero ADR entries. The CLAUDE.md says "read before planning, if exists" — so Claude reads an empty table on every spec. At minimum, document the foundational choices already made:

| # | When | Scope | Decision | Choice | Rationale | Revisable? |
|---|------|-------|----------|--------|-----------|------------|
| 1 | 2024 | Distribution | Runtime language | Bash (POSIX sh) | Zero install deps, runs everywhere git does | No |
| 2 | 2024 | Distribution | Package manager | npm tarball | Widest reach for a dev tool | No |
| 3 | 2025 | Architecture | Quality gates | Hook-first, scripts for green path | LLM only activates on failure — saves tokens | No |
| 4 | 2025 | Tooling | Token optimization | RTK mandatory | 60-90% reduction across all dev ops | No |

**File:** `decisions.md` — add rows

---

## Gap 2 — No MCP servers configured (LOW)

`.mcp.json` is `{"mcpServers": {}}` but `CLAUDE.md` tells Claude to "use Context7 MCP (`use context7`)". If Context7 is only global, this instruction confuses Claude in environments where it's not installed globally.

**Options:**
- If Context7 is always globally available for this team: document that in `.claude/rules/mcp.md`
- If not: either add Context7 to `.mcp.json` or remove the Context7 reference from `CLAUDE.md`

**Action:** Add a note in `.claude/rules/mcp.md` clarifying that Context7 is expected as a global MCP server.

---

## Gap 3 — No local quality gates for `.sh` files (addresses new requirement)

**Problem:** The zero-token green-path pattern exists for JS/TS (ESLint via post-edit-lint.sh) and tests (test-prep.sh), but this is a **bash project** and there's no local `shellcheck` or `bash -n` validation. Claude edits `.sh` files frequently.

**New: `shellcheck-guard.sh` PreToolUse hook**

Create `.claude/hooks/shellcheck-guard.sh`:

```bash
#!/bin/bash
# shellcheck-guard.sh — PreToolUse hook for .sh file edits
# Runs shellcheck on the target file before Claude edits it.
# Reports existing issues as context (advisory, not blocking).
# Zero output = zero tokens if no issues.

command -v shellcheck >/dev/null 2>&1 || exit 0
command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
[ -z "$FILE_PATH" ] && exit 0

case "$FILE_PATH" in
  *.sh) ;;
  *) exit 0 ;;
esac

[ -f "$FILE_PATH" ] || exit 0

# Run shellcheck, capture output
ISSUES=$(shellcheck -f gcc "$FILE_PATH" 2>/dev/null | head -20) || true
[ -z "$ISSUES" ] && exit 0

jq -n --arg ctx "[shellcheck] Existing issues in $FILE_PATH (fix while editing):\n$ISSUES" \
  '{"additionalContext": $ctx}'
```

Wire it into `settings.json` PreToolUse `Edit|Write` matcher alongside the existing `protect-files.sh` and `circuit-breaker.sh`:

```json
{
  "matcher": "Edit|Write",
  "hooks": [
    { "type": "command", "command": "...protect-files.sh" },
    { "type": "command", "command": "...circuit-breaker.sh" },
    { "type": "command", "command": "bash \"${CLAUDE_PROJECT_DIR:-.}\"/.claude/hooks/shellcheck-guard.sh", "timeout": 5 }
  ]
}
```

**New: `quality-gate.sh` zero-token local check**

Create `.claude/scripts/quality-gate.sh` — a comprehensive local validator for this bash project:

```bash
#!/usr/bin/env bash
# quality-gate.sh — local quality check, zero tokens on green
# Checks: bash -n syntax, shellcheck, smoke tests
# Exits 0 with "QUALITY_GATE_PASSED" on green; exits 2 with failures on red
set -euo pipefail

PASS=1
ERRORS=""

# Syntax check all .sh files
while IFS= read -r f; do
  if ! bash -n "$f" 2>/dev/null; then
    PASS=0
    ERRORS="${ERRORS}\nSYNTAX ERROR: $f"
  fi
done < <(git diff --name-only HEAD 2>/dev/null | grep '\.sh$'; echo "")

# Shellcheck (if available)
if command -v shellcheck >/dev/null 2>&1; then
  while IFS= read -r f; do
    [ -f "$f" ] || continue
    OUT=$(shellcheck "$f" 2>&1) || { PASS=0; ERRORS="${ERRORS}\n$OUT"; }
  done < <(git diff --name-only HEAD 2>/dev/null | grep '\.sh$')
fi

# Smoke tests
if [ -f "tests/smoke.sh" ]; then
  if ! bash tests/smoke.sh > /dev/null 2>&1; then
    PASS=0
    ERRORS="${ERRORS}\nSMOKE TESTS FAILED"
  fi
fi

if [ "$PASS" -eq 1 ]; then
  echo "QUALITY_GATE_PASSED"
  exit 0
fi

printf "=== QUALITY GATE FAILURES ===%b\n" "$ERRORS"
exit 2
```

Add to CLAUDE.md CLI Shortcuts section:
```
- Quality gate: `! bash .claude/scripts/quality-gate.sh`
```

---

## Change Summary

```
settings.json
  line 116: timeout 5000 → 5 (context-reinforcement.sh)
  PreToolUse Edit|Write: add shellcheck-guard.sh

.claude/scripts/statusline.sh
  after pct_used calculated: write bridge file for context-monitor.sh

.claude/hooks/context-freshness.sh
  line 69: add -d src / -d app / -d pages guard to suppress graph.json hint

decisions.md
  add 4 foundational ADR rows

.claude/rules/mcp.md
  add note: Context7 expected as global MCP server

.claude/hooks/shellcheck-guard.sh  (NEW)
  PreToolUse advisoryon .sh edits

.claude/scripts/quality-gate.sh  (NEW)
  zero-token comprehensive local validator

CLAUDE.md
  add quality-gate to CLI Shortcuts section
```

---

## Flow Diagram

```
UserPromptSubmit
  └─ context-freshness.sh (stale check, suppress graph hint for bash-only repos)
  └─ memory-recall.sh
  └─ update-check.sh

PreToolUse Edit|Write
  └─ protect-files.sh
  └─ circuit-breaker.sh
  └─ shellcheck-guard.sh ← NEW: advisory issues injected as context

PostToolUse Edit|Write
  └─ post-edit-lint.sh (auto-format)
  └─ tdd-checker.sh
  └─ context-monitor.sh ← NOW WORKS after statusline.sh writes bridge file

StatusLine render (continuous)
  └─ pct_used calculated
  └─ write /tmp/claude-ctx-{SESSION_ID}.json ← NEW bridge write
  └─ render output to terminal
```

---

## Verification

1. **context-monitor.sh**: Open a long session until context fills → statusline should write the bridge file → context-monitor.sh should emit WARNING/CRITICAL. Verify: `cat /tmp/claude-ctx-*.json` exists after statusline renders.

2. **context-reinforcement.sh timeout**: Check `bash -c "timeout 5 bash .claude/hooks/context-reinforcement.sh < /dev/null"` exits 0 (it runs in <1ms, well within 5s).

3. **shellcheck-guard.sh**: `echo '{}' | bash .claude/hooks/shellcheck-guard.sh` → exits 0 silently. Test with a .sh file that has issues.

4. **quality-gate.sh**: `bash .claude/scripts/quality-gate.sh` → should output `QUALITY_GATE_PASSED` on clean repo.

5. **context-freshness.sh**: In a bash-only repo with no `src/`, `app/`, or `pages/` dir, the graph.json hint should no longer fire on every prompt.
