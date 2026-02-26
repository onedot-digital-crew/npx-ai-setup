# Spec: Bash Performance Optimizations for ai-setup.sh

> **Spec ID**: 036 | **Created**: 2026-02-27 | **Status**: completed | **Branch**: spec/036-bash-performance-optimizations

## Goal
Reduce ai-setup.sh runtime by parallelizing skills search and installation, capping unbounded parallel curl calls, and eliminating subshell overhead in string transformations.

## Context
Profiling found 4 concrete bottlenecks: (1) skills installation is fully sequential (~30s/skill), (2) skills search per keyword is sequential (~30s/keyword × N keywords), (3) curl install-count fetches spawn unlimited parallel subshells with no job pool, (4) string transformations use echo|sed subshells where bash parameter expansion suffices. Total savings potential: 100+ seconds on a typical run with 5+ skills.

## Steps
- [x] Step 1: Parallelize the keyword search loop (~line 1012): run each `search_skills "$kw"` in background with `&`, collect results with `wait`, merge into a single deduped list
- [x] Step 2: Parallelize the system skills installation loop (~line 1300): install each skill with `&`; collect PIDs; `wait` for all; report results in order
- [x] Step 3: Parallelize the dynamic skills installation loop (~line 1159): same `&` + `wait` pattern; ensure duplicate-check logic is safe for concurrent execution
- [x] Step 4: Add job pool cap to the curl install-count fetch loop (~line 1052): limit to max 8 concurrent curl subshells using a semaphore pattern (`while (( $(jobs -r | wc -l) >= 8 )); do sleep 0.1; done`)
- [x] Step 5: Replace `echo "$var" | sed` and `echo "$var" | tr` subshells with bash parameter expansion (`${var//from/to}`, `${var^^}`, etc.) in the inner loops
- [x] Step 6: Run `./tests/smoke.sh` to verify correctness after changes; manually time a test run before/after with `time ./bin/ai-setup.sh --help`

## Acceptance Criteria
- [x] Skills search keywords run in parallel (not sequential npx calls)
- [x] Skills installation runs in parallel (not one-by-one)
- [x] curl fetch loop has max 8 concurrent jobs at any time
- [x] No `echo | sed` or `echo | tr` inside loops — replaced with parameter expansion
- [x] Smoke tests pass with no behavior change

## Files to Modify
- `bin/ai-setup.sh` — lines ~1012-1035 (search), ~1052-1062 (curl), ~1159-1164 (install), ~1300-1302 (system install), string transforms in loops

## Out of Scope
- Rewriting in Node.js
- Changing the user-facing output or UX
- Optimizing the Claude API call for CLAUDE.md generation (network-bound, not fixable in bash)
