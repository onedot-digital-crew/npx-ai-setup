# Spec: Fix CLAUDE.md generation timeout and error message

> **Spec ID**: 031 | **Created**: 2026-02-24 | **Status**: completed | **Branch**: spec/031-fix-claudemd-generation-timeout

## Goal
Increase the CLAUDE.md generation timeout from 120s to 180s and show a clear "timed out" message instead of "check authentication" when exit code is 143.

## Context
The `wait_parallel` function gives CLAUDE.md generation 120s before killing the process with SIGTERM (exit code 143). The verify step then shows "check authentication" which is misleading — the real cause is a timeout, not an auth issue. Context generation already gets 180s; CLAUDE.md should match.

## Steps
- [x] Step 1: In `bin/ai-setup.sh` line 837, change `"$PID_CM:CLAUDE.md:30:120"` → `"$PID_CM:CLAUDE.md:30:180"` (match context timeout)
- [x] Step 2: In lines 843-854, detect exit code 143 separately — show "Generation timed out (>180s). Re-run: npx @onedot/ai-setup --regenerate" instead of "check authentication"

## Acceptance Criteria
- [x] CLAUDE.md generation gets 180s (same as context)
- [x] Exit code 143 shows timeout message, not auth message
- [x] Other non-zero exit codes still show "check authentication"

## Files to Modify
- `bin/ai-setup.sh` — lines 837 and 849-853

## Out of Scope
- Retry logic for failed generation
- Changes to context generation timeout (already 180s)
