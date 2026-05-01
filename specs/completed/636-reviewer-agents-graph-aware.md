# Spec: reviewer agents — graph-aware reverse-dep walk

> **Spec ID**: 636 | **Created**: 2026-05-01 | **Status**: completed | **Complexity**: small | **Branch**: —

## Goal

Make code-reviewer, staff-reviewer, performance-reviewer query the import graph for reverse dependencies of changed files before reviewing — so they catch cross-file impact without manual grep.

## Context

Reviewer agents currently see only the diff. They never run `jq` against `.agents/context/graph.json` even though the file exists in nearly every JS/TS project. Cross-file impact ("changing this signature breaks 4 callers") goes unflagged unless the user prompts for it. Three agents, three identical gaps.

This is the cheapest graph-integration win: ~5-line prompt addition per agent, no new tools, no new code paths. Hook from spec 634 covers Read/Edit; this spec covers the agent prompts that decide what to inspect.

## Stack Coverage

- **Profiles affected**: all (graph.json applies to JS/TS, but instruction is conditional — agent skips when graph absent)
- **Per-stack difference**: none — agents check for graph presence themselves

## Steps

- [x] Step 1: `templates/agents/code-reviewer.md` — add "Pre-review graph check" section: `git diff --name-only` → for each file query `.agents/context/graph.json` for reverse-deps → list importers as Risk-Hint
- [x] Step 2: `templates/agents/staff-reviewer.md` — same block, plus hub-flag: if changed file is in `.stats.top_hubs` (≥5 importers), escalate to "structural risk"
- [x] Step 3: `templates/agents/performance-reviewer.md` — same reverse-dep block, plus hot-path flag: hub file changes = wider blast radius
- [x] Step 4: `.claude/agents/{code,staff,performance}-reviewer.md` — mirror
- [x] Step 5: verify each agent file passes `bash -n`-equivalent (markdown lint clean) and frontmatter still has `Bash` in tools list

## Acceptance Criteria

- [x] Each of the 3 agent files has a "Pre-review graph check" or equivalent section with the exact jq query for reverse-deps
- [x] Instruction is conditional: agent skips block when `.agents/context/graph.json` does not exist
- [x] Each agent's frontmatter still lists `Bash` in `tools` (required for jq)
- [x] Spot-check on a real PR review: reviewer mentions affected callers without being asked

## Files to Modify

- `templates/agents/code-reviewer.md`
- `templates/agents/staff-reviewer.md`
- `templates/agents/performance-reviewer.md`
- `.claude/agents/code-reviewer.md`
- `.claude/agents/staff-reviewer.md`
- `.claude/agents/performance-reviewer.md`

## External References

- jq query shape verified in `.claude/rules/agents.md` line 60 (`.edges[] | select(.target==$f) | .source`)
- Hub stat schema verified in `.claude/rules/agents.md` line 59 (`.stats.top_hubs[]`)

## Out of Scope

- security-reviewer changes (security ≠ structural; reverse-deps less relevant)
- test-generator (writes tests, doesn't review)
- bash-runner / implementer (execution, not review)
- New jq query authoring (reuse existing patterns from agents.md)
- Liquid-graph integration in reviewers (covered by hook in spec 634; reviewers rarely touch `.liquid` directly)
