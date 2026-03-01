# Spec: Agent Delegation Rules Template

> **Spec ID**: 052 | **Created**: 2026-02-28 | **Status**: in-review | **Branch**: spec/052-agent-delegation-rules

## Goal
Create `templates/claude/rules/agents.md` with clear delegation guidelines so Claude knows when to use which agent without being asked.

## Context
Our template ships 8 agents but no rule defining when each should be used. Without guidance, Claude either over-delegates (spawning agents for trivial tasks) or under-delegates (doing complex work inline). A rules file is always active — zero user action required — making it the right mechanism for teams that won't invoke meta-commands manually. Installable via the existing rules template map in `lib/core.sh`.

## Steps
- [ ] Step 1: Create `templates/claude/rules/agents.md` with an agent-to-task mapping table covering all 8 agents: `build-validator`, `code-architect`, `code-reviewer`, `context-refresher`, `perf-reviewer`, `staff-reviewer`, `test-generator`, `verify-app`
- [ ] Step 2: For each agent, specify: trigger condition (when to use), scope limit (what it must NOT do), and model cost note (haiku/sonnet/opus)
- [ ] Step 3: Add anti-patterns section — explicit list of when NOT to delegate (trivial tasks, single-file reads, tasks faster than agent startup overhead)
- [ ] Step 4: Register `agents.md` in the rules template map in `lib/core.sh` (same pattern as `general.md`, `git.md`, `testing.md`)

## Acceptance Criteria
- [ ] `templates/claude/rules/agents.md` exists with all 8 agents documented
- [ ] Each entry has: trigger, scope limit, model note
- [ ] Anti-patterns section prevents over-delegation
- [ ] File is registered in `lib/core.sh` and installs with `ai-setup`

## Files to Modify
- `templates/claude/rules/agents.md` - new file (create)
- `lib/core.sh` - register in rules template map

## Out of Scope
- Language-specific agents (Go, Python — not in our template set)
- Automatic agent selection hooks (rules-based guidance is sufficient)
- build-resolver agent (not yet in our template set)
