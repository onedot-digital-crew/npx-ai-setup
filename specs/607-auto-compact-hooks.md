# Spec: Auto Pre/Post-Compact State Hooks

> **Spec ID**: 607 | **Created**: 2026-04-01 | **Status**: completed | **Complexity**: medium | **Branch**: main

## Goal
Preserve minimal spec state automatically across context compaction without requiring manual `/pause` and `/resume`.

## Context
The current local setup already uses a `PreCompact` hook, but only to auto-commit tracked changes before compaction. Session continuity is still manual. This is the exact gap pilot-shell closes with pre/post compact state handling. For this repo, the right version is much smaller: capture only the active spec signal and restore only a short resume hint.

### Verified Assumptions
- The active local setup already defines a `PreCompact` hook inline in `.claude/settings.json`. — Evidence: `.claude/settings.json` | Confidence: High | If Wrong: hook insertion point changes
- Session state for this feature should stay project-local, not global, because the rest of the setup is project-local first. — Inference from repo architecture and managed file philosophy | Confidence: High | If Wrong: state location should move out of `.claude/`
- The most useful compact-restoration signal is whether any spec is currently `in-progress`, not a full resumable task log. — Inference from existing spec workflow and scope target | Confidence: Medium | If Wrong: this spec would need to capture richer state

## Steps
- [x] Step 1: Create `templates/claude/hooks/pre-compact-state.sh` to scan `specs/*.md`, capture active `in-progress` spec paths plus a timestamp, and write `.claude/compact-state.json`.
- [x] Step 2: Create `templates/claude/hooks/post-compact-restore.sh` for `SessionStart` with matcher `compact`. Claude Code supports matchers on SessionStart (`startup|clear|compact`) — confirmed by pilot-shell's `hooks.json` which uses this exact pattern in production. When state shows an active spec, print a concise restoration message.
- [x] Step 3: Refactor `templates/claude/settings.json` and `.claude/settings.json` so PreCompact keeps current behavior while also calling the new state-save hook, and SessionStart adds the compact-only restore hook.
- [x] Step 4: Add `.claude/compact-state.json` to both `.gitignore` (prevents PreCompact auto-commit from capturing it) and `.claudeignore` (hides from Claude reads). Document as ephemeral session state.
- [x] Step 5: Update `.claude/hooks/README.md` with the pre/post compact flow and the reduced scope relative to full `/pause` and `/resume`.

## Acceptance Criteria

### Truths
- [x] Before compaction, `.claude/compact-state.json` is written when at least one spec is marked `in-progress`.
- [x] After a compact-triggered session restart, the restore hook emits a short resume message when prior state exists.
- [x] If no spec is active, the save hook writes empty/minimal state or no meaningful state, and the restore hook stays silent.
- [x] Failure to write or read compact state never breaks compaction itself.

### Artifacts
- [x] `templates/claude/hooks/pre-compact-state.sh` — save minimal spec state before compaction
- [x] `templates/claude/hooks/post-compact-restore.sh` — restore compact hint on session restart
- [x] `templates/claude/settings.json` — PreCompact/SessionStart registration for generated projects
- [x] `.claude/hooks/pre-compact-state.sh` — installed copy for this repository
- [x] `.claude/hooks/post-compact-restore.sh` — installed copy for this repository
- [x] `.claude/settings.json` — active local hook registration

### Key Links
- [x] `templates/claude/settings.json` → `templates/claude/hooks/pre-compact-state.sh`
- [x] `templates/claude/settings.json` → `templates/claude/hooks/post-compact-restore.sh`
- [x] `.claude/settings.json` → `.claude/hooks/pre-compact-state.sh`
- [x] `.claude/settings.json` → `.claude/hooks/post-compact-restore.sh`

## Files to Modify
- `templates/claude/hooks/pre-compact-state.sh` - save minimal spec state before compaction
- `templates/claude/hooks/post-compact-restore.sh` - restore a short resume hint after compact restart
- `templates/claude/settings.json` - wire the save/restore hooks into PreCompact and SessionStart
- `.claude/hooks/pre-compact-state.sh` - installed copy for this repository
- `.claude/hooks/post-compact-restore.sh` - installed copy for this repository
- `.claude/settings.json` - wire the hooks into the active local setup
- `.claude/hooks/README.md` - document the compact state flow
- `.gitignore` - exclude `.claude/compact-state.json` from git (critical: PreCompact auto-commits tracked changes)
- `.claudeignore` - hide `.claude/compact-state.json` from Claude reads

**Canonical source**: `templates/claude/` is source of truth. Local `.claude/` copies are synced to match for repo verification.

## Out of Scope
- Replacing full `/pause` and `/resume` behavior
- Persisting detailed task notes, tool history, or worktree metadata
- Any global daemon, worker API, or local web service
- Cross-project compact state sharing
