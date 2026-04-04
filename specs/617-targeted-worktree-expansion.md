# Spec: Targeted Worktree Expansion

> **Spec ID**: 617 | **Created**: 2026-04-01 | **Status**: parked | **Complexity**: medium | **Branch**: —
> **Parked**: Zu vage für Implementierung — "selected skills" ohne konkrete Targets. Nachschärfen wenn konkreter Auslöser kommt.

## Goal
Extend the repo's existing worktree-isolation approach to a small set of additional high-risk flows, instead of introducing a second manual sandbox system.

## Context
The leaked Claude Code architecture confirms worktree isolation as a strong pattern for complex delegated work, but this repo already uses native worktree isolation in batch spec execution. The real question here is not whether to add “sandboxing” from scratch, but which additional flows should also use the existing native isolation path. This spec keeps the problem narrow: expand worktree usage only where the current main-repo flow is unnecessarily risky.

### Verified Assumptions
- The repo already uses native worktree isolation for batch spec execution. — Evidence: `templates/skills/spec-run-all/SKILL.md`, `specs/completed/018-native-worktree-rewrite.md` | Confidence: High | If Wrong: the value of expansion is lower
- Normal single-spec execution in `spec-run` still happens in the main working tree. — Evidence: `templates/skills/spec-run/SKILL.md` | Confidence: High | If Wrong: the target flow should be a different skill
- Some flows, especially risky multi-file experiments or write-capable research, may benefit from optional isolation without making every task pay the worktree overhead. — Evidence: current workflow split and practical repo usage | Confidence: Medium | If Wrong: worktree use should remain limited to batch execution

## Steps
- [ ] Step 1: Inventory current worktree usage and document which flows already use native `Agent(isolation: "worktree")` versus which still run directly in the main working tree.
- [ ] Step 2: Pick one or two concrete additional flows for optional or default worktree isolation, such as risky multi-file experimentation or write-capable research execution, and document the selection criteria in workflow docs.
- [ ] Step 3: Update the relevant skill files to use the existing native worktree-isolation path where selected, instead of creating a new manual `git worktree` lifecycle wrapper.
- [ ] Step 4: Define cleanup and branch-handling rules for those flows so isolation remains predictable and does not leave stray branches or directories.
- [ ] Step 5: Document when worktree isolation should not be used, so simple tasks stay fast and local.

## Acceptance Criteria

### Truths
- [ ] The repo has a documented answer for which flows use worktree isolation and which do not.
- [ ] At least one additional high-risk flow beyond batch spec execution can run via the existing native worktree-isolation path.
- [ ] The expansion does not introduce a second manual worktree-management system alongside the current native path.

### Artifacts
- [ ] selected skill(s) — updated to support targeted native worktree isolation
- [ ] `templates/WORKFLOW-GUIDE.md` — documented worktree selection rules
- [ ] supporting workflow/governance doc — clarified ownership and cleanup rules if needed

### Key Links
- [ ] selected skill → native `Agent(isolation: "worktree")` via execution lifecycle
- [ ] `templates/WORKFLOW-GUIDE.md` → selected skill via worktree selection rules

## Files to Modify
- selected skill file(s) under `templates/skills/` - adopt targeted native worktree isolation
- `templates/WORKFLOW-GUIDE.md` - document when to use worktrees
- related docs if needed - define cleanup and ownership rules

## Out of Scope
- Building a new manual `git worktree` orchestration layer
- Moving every implementation flow into isolated worktrees by default
- Copying tracked repo files into worktrees by hand
