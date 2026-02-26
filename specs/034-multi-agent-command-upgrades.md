# Spec: Multi-Agent Verification for /bug Command

> **Spec ID**: 034 | **Created**: 2026-02-27 | **Status**: completed | **Branch**: spec/034-multi-agent-command-upgrades

## Goal
Upgrade /bug to automatically verify and review fixes using subagents instead of asking the user to run tests manually.

## Context
/bug currently tells the user to "run existing tests" manually after fixing. Adding verify-app + code-reviewer as automatic post-fix steps closes the loop: the bug command now confirms the fix works and flags any introduced issues. /techdebt and /spec stay monolithic — /techdebt is designed for quick end-of-session sweeps, and Opus in /spec can search directly without subagent overhead.

## Steps
- [x] Step 1: In `templates/commands/bug.md`, add `Task` to `allowed-tools`
- [x] Step 2: Replace Step 4 (manual verify instructions) with: spawn `verify-app` after the fix; if FAIL stop and report issues with suggestion to re-investigate
- [x] Step 3: If verify-app returns PASS, spawn `code-reviewer` to review the fix; include verdict in output; CONCERNS or PASS = done, FAIL = flag for manual review
- [x] Step 4: Run smoke tests (`./tests/smoke.sh`) to verify template parses correctly

## Acceptance Criteria
- [x] `/bug` automatically spawns verify-app after every fix
- [x] `/bug` spawns code-reviewer if verify-app passes
- [x] A broken fix (verify-app FAIL) stops the command and reports clearly
- [x] Smoke tests pass

## Files to Modify
- `templates/commands/bug.md` — add Task tool, replace manual verify step with subagent steps

## Out of Scope
- /techdebt parallel agents (wrong design intent — sweep should stay fast)
- /spec parallel research agents (Opus can search directly, no subagent overhead needed)
- /review, /grill, /commit changes
