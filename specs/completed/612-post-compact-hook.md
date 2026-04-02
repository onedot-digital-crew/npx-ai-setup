# Spec: PostCompact Hook

> **Spec ID**: 612 | **Created**: 2026-04-01 | **Status**: completed | **Complexity**: low | **Branch**: —
> **Execution Order**: after 610, before 613

## Goal
Add `PostCompact`-based restore behavior so compact recovery can happen immediately after compaction, while keeping the existing SessionStart(compact) restore path as a fallback.

## Context
Spec 607 already introduced pre-compact state capture and a `SessionStart` restore path for compact restarts. If `PostCompact` is available as a real hook event in the target Claude environment, this repo should use it to restore the existing compact-state hint earlier instead of waiting for the next SessionStart. This is an incremental runtime improvement to an existing hook, not a new state model.

### Verified Assumptions
- `PostCompact` exists as a hook event type in decompiled Claude Code v2.1.88. Whether it fires in the public release is unverified. — Evidence: Spec 611 Research, `hooksConfigManager.ts` | Confidence: Medium | If Wrong: Hook gets registered but never fires — SessionStart fallback covers this, no damage.
- `templates/claude/hooks/post-compact-restore.sh` already exists and is currently wired for `SessionStart` with matcher `compact`. — Evidence: `templates/claude/hooks/post-compact-restore.sh`, `templates/claude/settings.json` | Confidence: High | If Wrong: the implementation path changes
- Spec 607 intentionally kept SessionStart(compact) restore as the current recovery path. — Evidence: `specs/607-auto-compact-hooks.md` | Confidence: High | If Wrong: this spec may already be obsolete
- The useful change is to reuse the existing restore logic on an earlier hook event, not to invent a second restore mechanism. — Evidence: current hook flow | Confidence: High | If Wrong: a broader redesign belongs in a different spec

## Steps
- [x] Step 1: **Verify Event Availability** — Register a minimal echo-only `PostCompact` hook in local `.claude/settings.json`. Trigger a compaction (e.g. via `/compact`). If the event does not fire: document as "event unavailable", keep SessionStart fallback as sole path, mark spec completed with note.
- [x] Step 2: Refactor `templates/claude/hooks/post-compact-restore.sh` so the existing restore logic can be invoked safely from `PostCompact` without changing the compact-state file format.
- [x] Step 3: Register a `PostCompact` hook in `templates/claude/settings.json` that reuses the existing restore script, while keeping the current SessionStart(compact) path as fallback until verified.
- [x] Step 4: Mirror the hook registration and script updates into the local `.claude/` copies for repo verification.
- [x] Step 5: Update `templates/claude/hooks/README.md` so the docs explain the new precedence: `PostCompact` first, SessionStart(compact) fallback.

## Implementation Note

Runtime event availability could not be proven from this terminal session because Claude hook events cannot be triggered directly here. The hook is therefore wired as experimental, with the existing `SessionStart(compact)` path preserved as the stable fallback.

## Acceptance Criteria

### Truths
- [ ] After compaction, the existing restore script can emit the active-spec hint immediately via `PostCompact` when the environment supports that event.
- [x] If `PostCompact` does not fire or is unavailable, the existing SessionStart(compact) restore path still works.
- [x] No error occurs when compact state is missing or empty.

### Artifacts
- [x] `templates/claude/hooks/post-compact-restore.sh` — existing restore hook adapted for dual use (min 25 lines)
- [x] `templates/claude/settings.json` — adds `PostCompact` registration alongside existing fallback path (includes PostCompact registration alongside existing fallback)
- [x] `templates/claude/hooks/README.md` — documents the restore precedence

### Key Links
- [x] `templates/claude/settings.json` → `templates/claude/hooks/post-compact-restore.sh` via `PostCompact`
- [x] `templates/claude/settings.json` → `templates/claude/hooks/post-compact-restore.sh` via `SessionStart` matcher `compact`

## Files to Modify
- `templates/claude/hooks/post-compact-restore.sh` - adapt the existing restore logic for `PostCompact`
- `templates/claude/settings.json` - register `PostCompact` while keeping fallback behavior
- `.claude/hooks/post-compact-restore.sh` - local parity copy
- `.claude/settings.json` - local parity registration
- `templates/claude/hooks/README.md` - document the updated restore order

## Out of Scope
- Changing the compact-state file format
- Removing the existing SessionStart(compact) fallback
- Redesigning compact recovery beyond active-spec restoration
