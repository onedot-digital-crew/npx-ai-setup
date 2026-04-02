# Spec: Unified Session Handoff State

> **Spec ID**: 616 | **Created**: 2026-04-01 | **Status**: completed | **Complexity**: medium | **Branch**: —
> **Execution Order**: after 609 AND after 614 (depends on 609 for spec-work/SKILL.md, depends on 612 for post-compact-restore.sh)

## Goal
Unify the repo's existing pause/resume and compact-resume state into one small machine-readable handoff layer so session recovery becomes more reliable without introducing a second task system.

## Context
The repo already has three separate resumption ideas: manual `.continue-here.md` via `/pause` and `/resume`, spec progress markers inside spec Markdown, and compact-only state in `.claude/compact-state.json`. The leaked Claude Code internals are useful here mainly as confirmation that durable task state matters, but a full task-graph clone would create more state divergence than it solves. This spec instead introduces one small machine-readable handoff file that complements existing Markdown, rather than replacing it.

### Verified Assumptions
- The repo already has manual handoff state in `.continue-here.md` plus compact-specific state in `.claude/compact-state.json`. — Evidence: `templates/skills/pause/SKILL.md`, `templates/skills/resume/SKILL.md`, `templates/claude/hooks/pre-compact-state.sh` | Confidence: High | If Wrong: the consolidation problem is smaller than expected
- `spec-work` and `spec-run` still use spec Markdown as the human source of truth, so replacing that entirely would create a disruptive migration surface. — Evidence: `templates/skills/spec-work/SKILL.md`, `templates/skills/spec-run/SKILL.md` | Confidence: High | If Wrong: a larger state migration would be acceptable
- The useful gap is not “resume is missing” but “resume state is split across two formats with partial overlap.” — Evidence: `templates/skills/resume/SKILL.md`, `templates/claude/hooks/post-compact-restore.sh` | Confidence: High | If Wrong: docs-only cleanup may be enough

## Steps
- [x] Step 1: Design a small machine-readable handoff schema in `.claude/session-state.json` that captures active spec ID, current phase, next action, and timestamp without trying to model a full task graph.
- [x] Step 2: Refactor `templates/skills/pause/SKILL.md` and `templates/skills/resume/SKILL.md` so manual pause/resume reads and writes the same canonical handoff state instead of relying only on free-form Markdown.
- [x] Step 3: Refactor `templates/claude/hooks/pre-compact-state.sh` and `templates/claude/hooks/post-compact-restore.sh` so compact recovery reuses the same canonical handoff state rather than a separate compact-only format.
- [x] Step 4: Update `templates/skills/spec-work/SKILL.md` and `templates/skills/spec-run/SKILL.md` so they refresh the unified handoff state at meaningful checkpoints without replacing spec Markdown as the human source of truth.
- [x] Step 5: Document the ownership split between spec Markdown, `.continue-here.md`, and `.claude/session-state.json` in workflow docs so the repo has one clear recovery model.

## Acceptance Criteria

### Truths
- [x] The repo has one canonical machine-readable session handoff file instead of separate pause-only and compact-only state formats.
- [x] Manual `/pause` and `/resume` use the same structured state that compact recovery uses.
- [x] Crashed or compacted sessions can be resumed using the unified handoff state without replacing human-readable spec files.

### Artifacts
- [x] `templates/skills/pause/SKILL.md` — writes unified handoff state (min 60 lines)
- [x] `templates/skills/resume/SKILL.md` — restores from unified handoff state (min 60 lines)
- [x] `templates/claude/hooks/pre-compact-state.sh` — unified compact save path (min 40 lines)
- [x] `templates/claude/hooks/post-compact-restore.sh` — unified compact restore path (min 40 lines)

### Key Links
- [x] `templates/skills/pause/SKILL.md` → `.claude/session-state.json` via manual handoff writes
- [x] `templates/claude/hooks/pre-compact-state.sh` → `.claude/session-state.json` via compact save path
- [x] `templates/skills/resume/SKILL.md` → `.claude/session-state.json` via restore flow

## Files to Modify
- `templates/skills/pause/SKILL.md` - write unified structured handoff state
- `templates/skills/resume/SKILL.md` - restore from unified structured handoff state
- `templates/claude/hooks/pre-compact-state.sh` - reuse the canonical handoff state
- `templates/claude/hooks/post-compact-restore.sh` - restore from the canonical handoff state
- `templates/skills/spec-work/SKILL.md` - refresh handoff state at meaningful checkpoints
- `templates/skills/spec-run/SKILL.md` - refresh handoff state at phase boundaries
- `templates/WORKFLOW-GUIDE.md` - document the unified recovery model

## Out of Scope
- Building a full task graph or dependency engine
- Replacing spec Markdown as the human source of truth
- Cross-project session persistence
