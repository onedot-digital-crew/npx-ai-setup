# Spec: Circuit Breaker — spec-work-all Detection

> **Spec ID**: 099 | **Created**: 2026-03-16 | **Status**: draft | **Branch**: —

## Goal
Raise circuit breaker thresholds to WARN=25 / BLOCK=40 when multiple specs are in-progress simultaneously, preventing false-positive blocks during spec-work-all batch runs.

## Context
Spec 094 raised thresholds (WARN=12, BLOCK=20) for single in-progress specs. During spec-work-all, central files like `lib/setup.sh` receive legitimate edits from multiple specs in sequence — 8 edits in 10 min is normal batch behaviour, not a loop. The fix: detect ≥2 in-progress specs and apply a higher tier.

## Steps
- [ ] Step 1: In `templates/claude/hooks/circuit-breaker.sh`, after the existing spec-active check, add a second check — count files matching `Status.*in-progress` in `specs/*.md`; if count ≥ 2, raise WARN=25 and BLOCK=40
- [ ] Step 2: Update `tests/smoke.sh` — add assertion that the circuit breaker hook contains the multi-spec detection string (e.g. `SPEC_COUNT` or the count comparison)

## Acceptance Criteria
- [ ] Single in-progress spec: thresholds remain WARN=12 / BLOCK=20 (spec 094 behaviour preserved)
- [ ] Two or more in-progress specs: thresholds raise to WARN=25 / BLOCK=40
- [ ] No spec active: default thresholds WARN=5 / BLOCK=8
- [ ] Smoke test passes for the new detection logic

## Files to Modify
- `templates/claude/hooks/circuit-breaker.sh` — add multi-spec count check
- `tests/smoke.sh` — add assertion for multi-spec detection

## Out of Scope
- Per-file exclusions (threshold tiers are sufficient)
- Resetting the log on spec completion
