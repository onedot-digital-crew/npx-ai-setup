# Spec: TDD Enforcement Hook

> **Spec ID**: 605 | **Created**: 2026-04-01 | **Status**: completed | **Complexity**: medium | **Branch**: main

## Goal
Add a lightweight PostToolUse hook that warns when production code is edited without a nearby matching test file.

## Context
`testing.md` now defines stricter TDD expectations, but the setup still relies on the model following those rules voluntarily. The missing enforcement gap is specifically "code changed, no corresponding test exists, no immediate warning fired". This spec closes that gap with a Bash hook that stays advisory and fast.

### Verified Assumptions
- Active project hooks currently run from `.claude/hooks/` and are configured in `.claude/settings.json`. — Evidence: `.claude/hooks/README.md`, `.claude/settings.json` | Confidence: High | If Wrong: the hook would be registered in the wrong place
- Template hooks for generated projects live under `templates/claude/hooks/` and are wired via `templates/claude/settings.json`. — Evidence: `templates/claude/hooks/`, `templates/claude/settings.json` | Confidence: High | If Wrong: generated projects would miss the new hook
- Existing PostToolUse hooks already target `Edit|Write`, so the new hook should align with the current event strategy instead of inventing a new flow. — Evidence: `.claude/settings.json`, `templates/claude/settings.json` | Confidence: High | If Wrong: matcher behavior would need revisiting

## Steps
- [x] Step 1: Create `templates/claude/hooks/tdd-checker.sh` as a Bash-only, non-blocking PostToolUse hook that reads the edited file path from hook JSON input.
- [x] Step 2: Teach the hook to skip test files, docs/config files, generated directories, and unsupported extensions; only inspect likely source files (`.py`, `.js`, `.jsx`, `.ts`, `.tsx`, `.go`).
- [x] Step 3: Implement language-aware test path heuristics:
  Python: `tests/test_<name>.py`, `<dir>/test_<name>.py`
  JS/TS: `<base>.test.*`, `<base>.spec.*`, `__tests__/<name>.test.*`
  Go: `<base>_test.go`
- [x] Step 4: Print a short advisory warning when no expected test path exists, but always exit `0` so the edit itself is never blocked.
- [x] Step 5: Register the hook in `templates/claude/settings.json` and `.claude/settings.json` under `PostToolUse` for the same edit matcher family as `post-edit-lint.sh`.
- [x] Step 6: Update `.claude/hooks/README.md` to document the new hook, its advisory behavior, and its matcher scope.

## Acceptance Criteria

### Truths
- [x] Editing a supported source file with no matching test file emits a warning from `tdd-checker.sh`.
- [x] Editing a test file, markdown file, JSON file, or generated/build artifact emits no warning.
- [x] The hook never blocks the edit path; it always exits `0`.
- [x] The hook runs locally with shell utilities only and does not call any external API or model.

### Artifacts
- [x] `templates/claude/hooks/tdd-checker.sh` — new advisory TDD hook (min 25 lines)
- [x] `templates/claude/settings.json` — PostToolUse registration for generated projects
- [x] `.claude/hooks/tdd-checker.sh` — installed copy for this repo
- [x] `.claude/settings.json` — active project registration for local verification

### Key Links
- [x] `templates/claude/settings.json` → `templates/claude/hooks/tdd-checker.sh`
- [x] `.claude/settings.json` → `.claude/hooks/tdd-checker.sh`
- [x] `.claude/rules/testing.md` → `templates/claude/hooks/tdd-checker.sh`

## Files to Modify
- `templates/claude/hooks/tdd-checker.sh` - new advisory TDD enforcement hook for generated projects
- `templates/claude/settings.json` - register the hook in the template hook pipeline
- `.claude/hooks/tdd-checker.sh` - installed copy for this repository
- `.claude/settings.json` - register the hook in the active local setup
- `.claude/hooks/README.md` - document the new hook and expected behavior

**Canonical source**: `templates/claude/` is source of truth. Local `.claude/` copies are synced to match for repo verification.

## Out of Scope
- Running the test suite automatically after every edit
- Blocking edits when no test exists
- Supporting every language in one iteration
- Deep semantic mapping between source files and tests beyond filename/path heuristics
