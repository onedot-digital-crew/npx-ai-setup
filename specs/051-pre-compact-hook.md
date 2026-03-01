# Spec: PreCompact Hook for Automatic State Save

> **Spec ID**: 051 | **Created**: 2026-02-28 | **Status**: in-review | **Branch**: spec/051-pre-compact-hook

## Goal
Add a PreCompact hook to `settings.json` that automatically instructs Claude to save work state before context compaction occurs.

## Context
Context compaction is automatic and silent — in-progress work and uncommitted changes can be lost when it fires. Our CLAUDE.md template has a text instruction ("Before compaction: commit or save state") but no enforcement. A PreCompact prompt-type hook runs automatically before every compaction with zero user action, making it ideal for teams that won't invoke manual commands.

## Steps
- [ ] Step 1: Add a `PreCompact` key to the `hooks` object in `templates/claude/settings.json` with an empty matcher and a `prompt`-type hook
- [ ] Step 2: The prompt instructs Claude to: (a) commit any staged/unstaged changes if work is complete, or (b) write current task state to `HANDOFF.md` if mid-task, listing what was done and what remains
- [ ] Step 3: Keep the prompt concise (max 3 sentences) — it runs on every compaction and must not bloat the context further

## Acceptance Criteria
- [ ] `PreCompact` hook entry exists in `templates/claude/settings.json`
- [ ] Hook type is `prompt` (not `command`) — no shell dependency
- [ ] Hook fires on all compactions (empty matcher)
- [ ] Existing hooks (SessionStart, PostToolUse, PreToolUse, UserPromptSubmit, Stop) are unchanged

## Files to Modify
- `templates/claude/settings.json` - add PreCompact hook entry

## Out of Scope
- Auto-committing (Claude decides based on task state)
- PreCompact shell command hooks (prompt-type is sufficient and simpler)
- Modifying compaction threshold settings
