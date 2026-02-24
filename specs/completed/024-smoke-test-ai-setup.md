# Spec: Smoke Test for bin/ai-setup.sh

> **Spec ID**: 024 | **Created**: 2026-02-24 | **Status**: in-review | **Branch**: spec/024-smoke-test-ai-setup

## Goal
Add a minimal smoke test script that catches syntax errors and flag regressions in `bin/ai-setup.sh` without requiring a live install.

## Context
`bin/ai-setup.sh` is the core of the package but has zero automated tests. Bugs go undetected until a user runs `npx @onedot/ai-setup`. A lightweight bash test covering syntax, `--help`, and key function presence provides a safety net for changes.

## Steps
- [x] Step 1: Create `tests/smoke.sh` — run `bash -n bin/ai-setup.sh` (syntax check), then `bash bin/ai-setup.sh --help` and assert exit 0
- [x] Step 2: Assert key functions exist in the script: `setup_system`, `update_system`, `build_template_map`
- [x] Step 3: Add `"test": "bash tests/smoke.sh"` to `package.json` scripts
- [x] Step 4: Verify `npm test` passes

## Acceptance Criteria
- [x] `npm test` runs `tests/smoke.sh` and exits 0
- [x] Syntax errors in `bin/ai-setup.sh` cause test failure
- [x] Missing key functions cause test failure
- [x] Test runs in under 5 seconds

## Files to Modify
- `tests/smoke.sh` — new file
- `package.json` — add test script

## Out of Scope
- Integration tests that actually install files to a temp directory
- Testing every flag or system type
