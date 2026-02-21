# Spec: Prompt Cache-Aware Template Design

> **Spec ID**: 005 | **Created**: 2026-02-21 | **Status**: completed

## Goal
Document prompt caching best practices in generated templates so target projects benefit from Claude Code's caching architecture.

## Context
Lance Martin's writeup on Claude Code's caching strategy reveals that CLAUDE.md, context files, and `<system-reminder>` hooks map directly to Claude's caching tiers. Our templates already follow these patterns accidentally — we should make them intentional and documented so devs understand the "why" and don't accidentally break the cache.

## Steps
- [x] Step 1: Add `## Prompt Cache Strategy` section to `templates/CLAUDE.md` explaining the 4 tiers
- [x] Step 2: Add inline comment to context-freshness hook explaining `<system-reminder>` preserves cache vs. system prompt edits
- [x] Step 3: Add comment to `templates/claude/settings.json` noting tool order should stay stable across sessions
- [x] Step 4: Update `bin/ai-setup.sh` Auto-Init prompt to mention static-first ordering when writing CLAUDE.md sections

## Acceptance Criteria
- [x] `templates/CLAUDE.md` explains caching tiers: system prompt → CLAUDE.md → session context → messages
- [x] context-freshness hook has comment explaining why `<system-reminder>` is cache-safe
- [x] Devs reading the generated CLAUDE.md understand why they shouldn't edit static sections mid-session

## Files to Modify
- `templates/CLAUDE.md` — add caching section (~8 lines)
- `templates/claude/hooks/context-freshness.sh` — add 1-2 comment lines
- `bin/ai-setup.sh` — minor prompt tweak in Auto-Init section

## Out of Scope
- Adding `cache_control` to Claude API calls (we use CLI, not API)
- Compaction implementation (handled by Claude Code itself)
- Tool defer_loading pattern (Claude Code internal, not exposed via CLI)
