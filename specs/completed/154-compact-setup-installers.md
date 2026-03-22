# Spec: Compact Setup Installers

> **Spec ID**: 154 | **Created**: 2026-03-22 | **Status**: completed | **Complexity**: medium | **Branch**: —

## Goal
Reduce duplication in `lib/setup.sh` by introducing shared helpers for installing template directories.

## Context
`lib/setup.sh` contains several near-identical loops for hooks, rules, commands, and scripts. The current code is readable, but it repeats the same install mechanics in multiple places.

## Steps
- [x] Step 1: Add a generic helper in `lib/setup.sh` for copying template directories into target directories.
- [x] Step 2: Refactor hook installation to use the helper.
- [x] Step 3: Refactor rule and command installation to use the helper while preserving conditional TypeScript logic.
- [x] Step 4: Refactor Claude script installation to use the helper while preserving executable bits.
- [x] Step 5: Verify setup output and installed file set remain unchanged.

## Acceptance Criteria
- [x] `lib/setup.sh` has less duplicated directory-copy logic.
- [x] Hook, rule, command, and script installation still produce the same files.
- [x] `npm test` and `bash tests/integration.sh` pass after the refactor.

## Files to Modify
- `lib/setup.sh` - add shared installer helper and refactor call sites
- `tests/smoke.sh` - update expectations if needed
- `tests/integration.sh` - confirm installed artifacts stay stable

## Out of Scope
- Moving setup logic into a different runtime or language
- Refactoring non-setup modules as part of this spec
