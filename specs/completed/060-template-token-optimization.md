# Spec: Template Token Optimization

> **Spec ID**: 060 | **Created**: 2026-03-08 | **Status**: completed | **Branch**: —

## Goal
Reduce token consumption of command templates by ~13% (~2,600 tokens) by compressing the 5 largest templates and eliminating cross-file duplication.

## Context
Audit found ~2,625 recoverable tokens across templates. Biggest waste: verbose question patterns in spec.md (400t), repeated examples in reflect.md (350t), duplicated emit logic in cross-repo-context.sh (350t), inline commentary in update.md (300t), and spec-work.md content duplicated in spec-work-all.md (280t). All command templates are loaded as prompts — every saved token compounds across all users and sessions.

## Steps
- [x] Step 1: Compress `templates/commands/spec.md` Phase 1e from 30 lines of nested questions to a 5-line checklist format. Preserve all check categories, remove verbose phrasing.
- [x] Step 2: Compress `templates/commands/reflect.md` from 4 identical example blocks (CONVENTIONS, CLAUDE, ARCHITECTURE, STACK) to 1 example + "apply same pattern to other context files" note.
- [x] Step 3: Refactor `templates/claude/hooks/cross-repo-context.sh` — consolidate duplicated emit_repo_line branches, inline small helper functions.
- [x] Step 4: Compress `templates/commands/update.md` — remove inline bash commentary, reduce 15-line display template to essential structure.
- [x] Step 5: Compress `templates/commands/spec-work-all.md` — replace inline spec-work duplication with "Follow /spec-work process" reference + only worktree-specific additions.
- [x] Step 6: Remove duplication in `templates/claude/hooks/README.md` where it repeats AGENTS.md hook table content.
- [x] Step 7: Measure before/after line counts for all modified files, verify total reduction ≥ 10%.

## Acceptance Criteria
- [x] Total line count across modified files reduced by ≥ 10%
- [x] No behavioral changes — all commands produce same outcomes
- [x] All hooks pass `bash -n` syntax check
- [x] spec.md still contains all Phase 1 challenge categories

## Files to Modify
- `templates/commands/spec.md` — compress Phase 1e questions
- `templates/commands/reflect.md` — deduplicate example blocks
- `templates/claude/hooks/cross-repo-context.sh` — consolidate emit logic
- `templates/commands/update.md` — remove verbose commentary
- `templates/commands/spec-work-all.md` — reference spec-work instead of duplicate
- `templates/claude/hooks/README.md` — remove AGENTS.md duplication

## Out of Scope
- Deadloop fixes (spec 059)
- Compressing already-lean templates (test.md, commit.md, bug.md, etc.)
- Changing command behavior or thresholds
