#!/bin/bash
# precompact-guidance.sh — PreCompact hook
# Injects a structured summary template before autocompact runs.
# Helps Claude preserve session intent, modified files, and open decisions
# across context compression events.
# Fail-open: no heredoc (avoids temp-file failures in read-only sandboxes).

guidance='# PreCompact Guidance — Session State Snapshot

Before compacting, ensure the following are preserved in the compact summary:

## 1. Session Intent
What is the user trying to accomplish in this session? (1-2 sentences, not a task list)

## 2. Files Modified This Session
List every file edited or created (path + one-line reason). Do NOT omit files that are "obviously" part of the work.

## 3. Decisions Made
Any explicit or implicit decisions (approach chosen, options rejected, constraints discovered).

## 4. Blockers & Open Questions
Anything that was discovered but not yet resolved. Investigations in progress.

## 5. Next Steps
Concrete next actions — specific file to edit, command to run, spec step to complete.

---
Compact rule: preserve ALL of the above. Detail loss here = wasted tokens re-discovering context later.'

if command -v jq >/dev/null 2>&1; then
  printf '%s' "$guidance" | jq -Rs '{"additionalContext": .}' 2>/dev/null || true
elif command -v python3 >/dev/null 2>&1; then
  printf '%s' "$guidance" | python3 -c 'import json,sys; print(json.dumps({"additionalContext": sys.stdin.read()}))' 2>/dev/null || true
fi
exit 0
