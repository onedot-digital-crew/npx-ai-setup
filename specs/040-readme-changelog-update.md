# Spec: README & CHANGELOG Update + Release Validation

> **Spec ID**: 040 | **Created**: 2026-02-27 | **Status**: in-progress | **Branch**: —

## Goal
Bring README.md in sync with actual features, compact CHANGELOG entries, and extend /release to validate README counts automatically.

## Context
README lists 13 commands (actual: 15), 4 agents (actual: 8), 3 hooks (actual: 6). CHANGELOG [Unreleased] has 9 verbose spec entries that need compacting. The /release command already checks command count — extend it to also validate agents and hooks counts so README never drifts again.

## Steps
- [x] Step 1: Update README.md commands section — change count to 15, add `/analyze` and `/context-full` to table
- [ ] Step 2: Update README.md agents section — change count to 8, add code-reviewer, code-architect, perf-reviewer, test-generator to table
- [ ] Step 3: Update README.md hooks section — change count to 6, add context-freshness, update-check, notify to table
- [ ] Step 4: Update README.md file structure tree — add missing files (new agents, hooks, commands)
- [ ] Step 5: Compact README overall — tighten verbose sections, remove redundancy, ensure nothing exceeds what's needed
- [ ] Step 6: Compact CHANGELOG.md [Unreleased] entries — shorten each spec entry to one concise line
- [ ] Step 7: Extend `templates/commands/release.md` Step 3 — validate agent count and hook count alongside command count

## Acceptance Criteria
- [ ] README command/agent/hook counts match actual template files
- [ ] CHANGELOG [Unreleased] entries are each one concise line
- [ ] `/release` validates commands, agents, and hooks counts before proceeding
- [ ] `npm test` passes (smoke tests)

## Files to Modify
- `README.md` — update counts, tables, file structure, compact
- `CHANGELOG.md` — compact [Unreleased] entries
- `templates/commands/release.md` — extend validation step

## Out of Scope
- Version bump or actual release
- Rewriting README structure or sections
- Adding new features
