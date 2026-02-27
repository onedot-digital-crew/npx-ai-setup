# Spec: Enhance template settings.json with hooks, env vars, and agent memory fields

> **Spec ID**: 047 | **Created**: 2026-02-28 | **Status**: in-review | **Branch**: spec/047-settings-hooks-agent-memory

## Goal
Add SessionStart compact hook, CLAUDE_AUTOCOMPACT_PCT_OVERRIDE, agent memory/isolation fields, PostToolUse failure-logging hook, Stop prompt hook, and ENABLE_TOOL_SEARCH to the template settings and agent files.

## Context
Gap analysis of Claude Code docs (hooks-guide, sub-agents, headless, settings, Lovable hacks) revealed seven missing best-practice configurations in the template. Context degrades at 20-40% usage (not 95%), so AUTOCOMPACT at 30 prevents silent context loss. SessionStart compact hook re-injects project context after compaction. Agent `memory: project` enables per-agent learning for reviewer agents; `isolation: worktree` protects file-writing agents. **Implement after Spec 044** — both touch `templates/claude/settings.json`.

## Steps
- [x] Step 1: Add `SessionStart` hook to `templates/claude/settings.json` — compact matcher command that re-reads STACK.md + CONVENTIONS.md after compaction
- [x] Step 2: Add `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE: "30"` to `env` block in `templates/claude/settings.json`
- [x] Step 3: Add `ENABLE_TOOL_SEARCH: "true"` to `env` block in `templates/claude/settings.json` — enables MCP lazy-loading
- [x] Step 4: Add `PostToolUse` failure-logging hook to `templates/claude/settings.json` — hook script checks `$CLAUDE_TOOL_EXIT_CODE` and logs failures with timestamp to `.claude/tool-failures.log`
- [x] Step 5: Add `Stop` prompt hook to `templates/claude/settings.json` — quality gate: verify all acceptance criteria met before stopping
- [x] Step 6: Add `memory: project` field to `templates/agents/code-reviewer.md`, `templates/agents/staff-reviewer.md`, and `templates/agents/perf-reviewer.md` frontmatter
- [x] Step 7: Add `isolation: worktree` field to `templates/agents/test-generator.md` frontmatter only — context-refresher must write directly to the working tree
- [x] Step 8: Verify idempotency — existing settings.json merge must not duplicate hooks or env keys

## Acceptance Criteria
- [x] `templates/claude/settings.json` contains SessionStart compact hook, AUTOCOMPACT=30, ENABLE_TOOL_SEARCH, PostToolUse failure hook, Stop hooks
- [x] `code-reviewer.md`, `staff-reviewer.md`, and `perf-reviewer.md` have `memory: project` in frontmatter
- [x] `test-generator.md` has `isolation: worktree` in frontmatter
- [x] Running install twice produces identical results (idempotent)

## Files to Modify
- `templates/claude/settings.json` — add hooks (SessionStart, PostToolUse failure, Stop) + env vars
- `templates/agents/code-reviewer.md` — add memory field
- `templates/agents/staff-reviewer.md` — add memory field
- `templates/agents/perf-reviewer.md` — add memory field
- `templates/agents/test-generator.md` — add isolation field

## Out of Scope
- PreCompact hook (not yet stable in production use)
- Team coordination hooks (TeammateIdle, TaskCompleted) — too specialized
- LSP server integration — separate spec if needed
