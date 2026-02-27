# Spec: Integrate Orphaned Agent Templates into Pipelines

> **Spec ID**: 033 | **Created**: 2026-02-26 | **Status**: completed | **Branch**: spec/033-integrate-orphaned-agents

## Goal
Wire build-validator into the PR pipeline and expand /review to cover branch commits.

## Context
build-validator exists as an agent template but is referenced by no command. Additionally, /review only sees uncommitted changes — branch commits on feature branches are invisible. perf-reviewer belongs in /analyze (Spec 035) and /review, not in /spec-work which processes shell/template files.

## Steps
- [x] Step 1: In `templates/commands/pr.md`, add build-validator as the first step — spawn it before staff review; if FAIL, stop with "Fix the build before creating a PR"
- [x] Step 2: In `templates/commands/review.md`, replace the git diff step with: run `git diff` + `git diff --staged` first; if on a branch also run `git diff main...HEAD`; combine all changes for review; note "no changes found" if all are empty
- [x] Step 3: Update agent listing in `bin/ai-setup.sh` (~line 2146) to include build-validator
- [x] Step 4: Run smoke tests (`./tests/smoke.sh`) to verify templates parse correctly

## Acceptance Criteria
- [x] `/pr` fails fast with a build error message before staff review if build is broken
- [x] `/review` on a feature branch shows both uncommitted changes and branch commits
- [x] Smoke tests pass

## Files to Modify
- `templates/commands/pr.md` — add build-validator as Step 1
- `templates/commands/review.md` — extend git diff to include branch commits
- `bin/ai-setup.sh` — update agent listing in summary output

## Out of Scope
- perf-reviewer in /spec-work (wrong context — shell/template files have no perf issues)
- Changing /grill (stays monolithic Opus by design)
- test-generator integration (requires separate design)
