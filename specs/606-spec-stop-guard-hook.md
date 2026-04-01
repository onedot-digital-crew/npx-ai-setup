# Spec: Spec Stop Guard Hook

> **Spec ID**: 606 | **Created**: 2026-04-01 | **Status**: completed | **Complexity**: medium | **Branch**: main

## Goal
Prevent Claude from stopping silently while a spec is still marked in progress.

## Context
The current setup has a `Stop` hook, but it only ingests transcripts. There is no workflow guard that says "a spec is active, do not end the session as if the work is complete". This leads to partial spec execution and lost momentum. The goal is not heavy workflow orchestration; it is one small guardrail around the most important in-progress signal the repo already has.

### Verified Assumptions
- The repo already uses frontmatter-like status lines inside spec files and stores specs in `specs/*.md`. — Evidence: `specs/603-claude-plugin-first-foundation.md`, `specs/605-tdd-enforcement-hook.md` | Confidence: High | If Wrong: the status detection strategy must change
- The active local setup already has a `Stop` hook chain containing `transcript-ingest.sh`. — Evidence: `.claude/settings.json` | Confidence: High | If Wrong: registration order would need redesign
- A lightweight block with a cooldown is acceptable because hard-blocking every stop forever would create user-hostile loops. — Inference from current hook philosophy and prior research | Confidence: Medium | If Wrong: this should be downgraded to warning-only

## Steps
- [x] Step 1: Create `templates/claude/hooks/spec-stop-guard.sh` as a Bash Stop hook that scans only `specs/*.md` for `Status: in-progress`.
- [x] Step 2: Add a short cooldown mechanism keyed by project path hash under `/tmp/` so the first stop is blocked but a second stop within 60 seconds is allowed through intentionally.
- [x] Step 3: Print a direct block message that names the reason, suggests the detection command, and tells Claude to continue the spec rather than pretending completion.
- [x] Step 4: Register the hook in `templates/claude/settings.json` and `.claude/settings.json` in the `Stop` event as a SEPARATE array entry AFTER `transcript-ingest.sh`. Ordering matters: transcript-ingest must run first (captures context even on blocked stops), then the guard fires. If both were in the same hooks array, a guard block (exit 2) would skip transcript-ingest — losing exactly the learnings from the session most likely to need them.
- [x] Step 5: Update `.claude/hooks/README.md` with the new Stop guard and its cooldown behavior.

## Acceptance Criteria

### Truths
- [x] If any file in `specs/*.md` contains `Status: in-progress`, the first Stop event is blocked with a clear message.
- [x] If Stop fires again within 60 seconds for the same project, the hook allows it through.
- [x] If no spec is in progress, Stop passes through with no guard output.
- [x] The hook only inspects shallow `specs/*.md` files and does not depend on git state, worktrees, or external APIs.

### Artifacts
- [x] `templates/claude/hooks/spec-stop-guard.sh` — new Stop hook with cooldown (min 25 lines)
- [x] `templates/claude/settings.json` — Stop registration for generated projects
- [x] `.claude/hooks/spec-stop-guard.sh` — installed copy for this repository
- [x] `.claude/settings.json` — active local Stop registration

### Key Links
- [x] `templates/claude/settings.json` → `templates/claude/hooks/spec-stop-guard.sh`
- [x] `.claude/settings.json` → `.claude/hooks/spec-stop-guard.sh`
- [x] `specs/*.md` status lines → `.claude/hooks/spec-stop-guard.sh`

## Files to Modify
- `templates/claude/hooks/spec-stop-guard.sh` - new Stop hook that guards in-progress specs
- `templates/claude/settings.json` - register the hook in the Stop pipeline
- `.claude/hooks/spec-stop-guard.sh` - installed copy for this repository
- `.claude/settings.json` - register the hook in the active local setup
- `.claude/hooks/README.md` - document the Stop guard and cooldown behavior

**Canonical source**: `templates/claude/` is source of truth. Local `.claude/` copies are synced to match for repo verification.

## Out of Scope
- Tracking current checklist progress inside a spec
- Reading `.continue-here.md` or other side-channel state in this first version
- Blocking non-spec workflows from stopping
- Coordinating with git worktree state or agent lifecycle metrics
