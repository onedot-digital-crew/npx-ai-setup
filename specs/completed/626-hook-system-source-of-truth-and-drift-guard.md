# Spec: Hook System Drift Fix

> **Spec ID**: 626 | **Created**: 2026-04-06 | **Status**: completed | **Complexity**: low | **Branch**: —

## Goal
Reconcile the 5 concrete drift points between template hooks, installed hooks, and documentation so all three describe the same runtime.

## Context
Analysis found 5 template hooks missing from installed runtime, 1 installed hook missing from template, and README.md listing 25 hooks with stale names while the installation has 23. This drift caused incorrect analysis results in the current session (wrong hook counts, wrong assumptions about what fires).

### Known Drift Points
1. `protect-files.sh` + `circuit-breaker.sh` (template) → `protect-and-breaker.sh` (installed) — intentional merge, undocumented
2. `tool-redirect.sh` — in template, not registered in installed settings.json
3. `context-reinforcement.sh` — in template only, missing from installed
4. `task-created-log.sh` — in template only, missing from installed
5. `update-check.sh` — in template only, missing from installed
6. README.md line 32 lists 25 hooks with old names (`circuit-breaker`, `protect-files`, `memory-recall`)

### Verified Assumptions
- `.claude/hooks/README.md` is mostly current (lists `protect-and-breaker.sh`) — Evidence: file read | Confidence: High
- README.md hook list is stale (names template hooks, not installed) — Evidence: line 32 vs installed diff | Confidence: High
- Drift is template-ahead: template has newer hooks not yet installed — Evidence: diff analysis | Confidence: High | If Wrong: installed has intentional deviations that need documenting

## Steps
- [x] Step 1: For each of the 5 drift points, determine: intentional deviation or missing installation? Read each template-only script to understand what it does.
- [x] Step 2: Activate or explicitly exclude each drifted hook — install missing hooks in `.claude/settings.json` if they should be active, or document why they're template-only.
- [x] Step 3: Update `README.md` line 32 hook inventory to match the actual installed runtime (correct names, correct count).
- [x] Step 4: Verify `.claude/hooks/README.md` matches installed state — add any missing entries.

## Acceptance Criteria
- [x] "Every hook in `.claude/settings.json` has a matching entry in `.claude/hooks/README.md`"
- [x] "README.md hook count and names match the installed runtime"
- [x] "Each of the 5 drift points has an explicit resolution: activated, or documented as template-only with rationale"
- [x] "No existing safety hook removed or deactivated"

## Files to Modify
- `.claude/settings.json` — register missing hooks or document exclusions
- `README.md` — update hook inventory (line 32 area)
- `.claude/hooks/README.md` — align with installed state

## Out of Scope
- Drift guard tests/scripts (follow-up spec)
- Hook classification framework (unnecessary — `.claude/hooks/README.md` already has a table)
- Template-side changes (template is ahead, installed catches up)
- Token optimization of hook output (covered by 624 analysis: hooks already optimized)
