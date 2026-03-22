# Spec: Script Source of Truth

> **Spec ID**: 155 | **Created**: 2026-03-22 | **Status**: draft | **Complexity**: low | **Branch**: —

## Goal
Make `templates/scripts/` the documented canonical source for repo-local Claude shell scripts and fail fast on drift with `.claude/scripts/`.

## Context
The repo keeps some scripts both under `templates/scripts/` and `.claude/scripts/`. Today those overlaps are maintained manually. The install path already copies from templates into `.claude/scripts/`, so the remaining gap is enforcement and documentation.

## Steps
- [ ] Step 1: In `tests/smoke.sh`, add a parity check for every script name that exists in both `templates/scripts/` and `.claude/scripts/`.
- [ ] Step 2: In `tests/smoke.sh`, fail with the concrete filename when an overlapping script differs.
- [ ] Step 3: In `README.md`, add one explicit note that `templates/scripts/` is the source of truth and `.claude/scripts/` contains installed copies for this repo.
- [ ] Step 4: In `lib/setup.sh`, tighten the `install_claude_scripts()` comment so it explicitly describes `templates/scripts/` → `.claude/scripts/` as the intended flow.
- [ ] Step 5: In `tests/integration.sh`, assert that fresh install still creates the repo-local Claude scripts that are tracked in `.claude/scripts/`.

## Acceptance Criteria
- [ ] `npm test` fails if any overlapping script pair between `templates/scripts/` and `.claude/scripts/` diverges.
- [ ] The failure message names the drifted script.
- [ ] `README.md` documents `templates/scripts/` as canonical.
- [ ] Fresh install still creates `.claude/scripts/doctor.sh`, `.claude/scripts/release.sh`, and `.claude/scripts/spec-board.sh`.

## Files to Modify
- `tests/smoke.sh` - add overlapping-script parity checks
- `tests/integration.sh` - assert installed repo-local scripts
- `README.md` - document canonical script source
- `lib/setup.sh` - clarify installer intent in comments

## Out of Scope
- Replacing copied scripts with symlinks
- Refactoring command templates or non-shell assets
- Reworking update flow for already-installed projects
