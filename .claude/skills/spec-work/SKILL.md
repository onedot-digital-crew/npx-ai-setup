---
name: spec-work
description: "Execute a single spec step by step."
user-invocable: true
effort: medium
model: sonnet
argument-hint: "<NNN spec number>"
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - Agent
  - AskUserQuestion
---

Executes spec $ARGUMENTS step by step and verifies acceptance criteria.

## Process

1. **Find spec**: `$ARGUMENTS` as number → `specs/NNN-*.md`. Filename → open directly. Empty → list drafts, ask.
2. **Read spec** — understand Goal, Steps, Files to Modify. Spec was structure-validated + user-approved during `/spec`; trust it.
3. **High complexity only**: Show Goal/Approach/Files summary, ask confirmation. Spawn `code-architect` (model: opus). REDESIGN → stop.
4. **Branch setup**: Ask user → `spec/NNN-title`. Read `CONVENTIONS.md` + `STACK.md`. Load skills from spec Context.
5. **Start work**: Set `in-progress`.
6. **Progress checklist**: Print `[ ] Step N: <title>`. Resume from first unchecked `- [x]`.

### Model routing (per Complexity field)

| Complexity | Model |
|-----------|-------|
| low | direct (no subagent) |
| medium/unset | `model: sonnet` |
| high | `model: opus` |

Specialist routing: Vue/React/styling → `frontend-developer`; API/middleware → `backend-developer`. Only if agent exists in `.claude/agents/`.

7. **Execute each step**: Implement → check off (`- [x]`) → append `decisions.md` if architectural. No commits — `/spec-review` is the gate.
   - Stall: 3× same failure → `- [~]`, set `blocked`, stop. 2 no-change steps → ask user.
8. **Verify acceptance criteria**: Run commands to check each criterion. Read modified files to confirm changes landed.
9. **CHANGELOG**: Insert under `## [Unreleased]`.
10. **Verify**: Spawn `verify-app`. FAIL → spawn investigator (model: haiku, read-only), fix, re-verify once. Second FAIL → `in-review`, stop.
11. **Test coverage**: Spawn `test-generator` (model: sonnet) if gaps exist. Skip if test-only or no framework.
12. **Review**: Set `in-review`. Low/Medium → `code-reviewer`. High → + `staff-reviewer`. Auth/secrets → + `security-reviewer`. DB/perf → + `performance-reviewer`. FAIL → report. PASS → `completed`, move to `specs/completed/`.

## Skill-Trimming Quality Gate

When spec modifies SKILL.md files: before step 8, spawn Haiku subagent to diff original vs trimmed. Classify each removed element as REDUNDANT or CRITICAL. Any CRITICAL → stop, re-add before completing.

## Rules
- Follow spec exactly. Check off each step. No commits during `/spec-work`.
- Blocked → set `blocked`, ask user. Skill references → invoke via `Skill` tool.
- `--complete`: skip steps 9-12.

## Next Step

> 📋 `/spec-review NNN` — validate, then `/commit`
