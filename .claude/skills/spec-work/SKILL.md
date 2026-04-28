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

## Tool & Context Matrix

Read this matrix once at start. Skip silently if a file/agent doesn't exist.

**Foundation (every spec):**

| File | Step | Why |
|---|---|---|
| `.agents/context/STACK.md` | 4 | Frameworks, build tooling for branch setup |
| `.agents/context/CONVENTIONS.md` | 7 | Code style for implementation |
| `.agents/context/graph.json` | 7 | jq lookups before grep (saves tokens) |
| `decisions.md` | 7 | Append architectural decisions |

**Conditional (existence-checked):**

| Agent / Script | Trigger | Step |
|---|---|---|
| `code-architect` agent | Complexity=high in spec frontmatter | 3 |
| `frontend-developer` agent | Steps touch `*.vue` `*.tsx` `*.jsx` `*.css` `*.scss` `*.liquid` | 7 |
| `backend-developer` agent | Steps touch API routes, middleware, server-side | 7 |
| `bash .claude/scripts/quality-gate.sh` | Steps modify `.sh` files | 8 |
| `bash .claude/scripts/lint-prep.sh` | After Edit/Write to source files | 8 |
| `bash .claude/scripts/test-prep.sh` | Spec has test-related steps | 11 |
| `code-reviewer` agent | Always at step 12 (low/medium complexity) | 12 |
| `staff-reviewer` agent | Complexity=high | 12 |
| `security-reviewer` agent | Spec touches auth/secrets/permissions | 12 |
| `performance-reviewer` agent | Spec touches DB queries, bundle size, rendering hot paths | 12 |

**Fallback:** if a conditional agent doesn't exist (`ls .claude/agents/<name>.md`), proceed without it. Never block on missing optional agents. `code-reviewer` is the only required agent at step 12.

**Anti-bloat:** zero-token bash prep-scripts before LLM checks. Trust spec — no re-validation (Phase 3 of `/spec` already validated structure).

## Process

1. **Find spec**: `$ARGUMENTS` as number → `specs/NNN-*.md`. Filename → open directly. Empty → list drafts, ask via AskUserQuestion.
2. **Read spec** — Goal, Steps, Files to Modify, Acceptance Criteria. Trust it; structure was validated in `/spec`.
3. **High-complexity check**: If spec frontmatter `Complexity: high` AND `code-architect` agent exists → spawn for design review (model: opus). REDESIGN verdict → stop, report. Otherwise continue.
4. **Branch + foundation**: AskUserQuestion → create `spec/NNN-<slug>` now/later/skip. Read STACK.md (matrix). Load Skill refs from spec Context.
5. **Set status**: `Status: in-progress` in spec frontmatter.
6. **Progress checklist**: Print `[ ] Step N: <title>`. Resume from first unchecked.

### Model routing per spec Complexity

| Complexity | Implementation model |
|---|---|
| low | direct (no subagent) |
| medium / unset | `model: sonnet` |
| high | `model: opus` |

**Effort override** (`${CLAUDE_EFFORT}`): if `xhigh` or `max`, treat all medium specs as high (spawn opus for implementation, run all optional review agents in step 12 regardless of complexity).

Specialist routing (matrix above): frontend/backend agents only when they exist AND step touches matching files.

7. **Execute each step**:
   - Read CONVENTIONS.md once before first edit (matrix).
   - For graph-aware lookups: `jq -r '.edges[] | select(.target=="<file>") | .source' .agents/context/graph.json | head -5` instead of grep.
   - Implement → check off `- [x]` → if architectural choice made: append to `decisions.md` (one line).
   - **Stall guard**: 3× same failure on a step → mark `- [~]`, set `Status: blocked`, stop with diagnostic. 2 consecutive no-change steps → AskUserQuestion before continuing.
   - **Hypothesis budget**: max 2 diagnostic attempts per failure. After 2: switch strategy or ask user.
   - No commits during work — `/spec-review` is the gate.
8. **Verify ACs + zero-token quality**:
   - Run lint-prep.sh / quality-gate.sh per matrix triggers (zero-token sanity).
   - For each Acceptance Criterion: run the verification command from spec, or read modified files to confirm.
   - FAIL → fix once, re-verify. Second FAIL → set `Status: in-review`, surface to user, stop.
9. **CHANGELOG**: Insert one-line entry under `## [Unreleased]`.
10. **Verify-app**: If `verify-app` agent exists → spawn (model: haiku, read-only). FAIL → spawn investigator, fix once, re-verify. Skip silently if agent missing.
11. **Test coverage**: If `test-generator` agent exists AND spec is not test-only AND test framework present → spawn (model: sonnet) for gap-fill. Skip silently otherwise. Run `test-prep.sh` per matrix trigger.
12. **Review gate**: Set `Status: in-review`. Spawn agents per matrix:
    - Always: `code-reviewer` (model: sonnet).
    - Add `staff-reviewer` if high complexity (when agent exists).
    - Add `security-reviewer` if auth/secrets touched (when agent exists).
    - Add `performance-reviewer` if perf-relevant (when agent exists).
    - Reviews run in parallel (single message, multiple Agent calls).
    - FAIL → report findings, stop. PASS → `Status: completed`, move spec to `specs/completed/`.

## Skill-Trimming Quality Gate

When spec modifies SKILL.md files: before step 8, spawn Haiku subagent to diff original vs trimmed. Classify each removed element as REDUNDANT or CRITICAL. Any CRITICAL → stop, re-add before completing.

## Status Lifecycle (canonical vocab — enforced)

| Status | Trigger | Side effect |
|---|---|---|
| `draft` | `/spec` created | file in `specs/NNN-*.md` |
| `in-progress` | step 5 (this skill) | — |
| `in-review` | step 12 start | — |
| `blocked` | stall guard / verify-fail | stop, surface to user |
| `completed` | step 12 review PASS | **move file to `specs/completed/NNN-*.md`** |

Use ONLY these five values. Synonyms like `done`, `finished`, `closed`, `merged` are forbidden — `spec-board.sh` won't bucket them and the spec disappears from the board.
`completed` without the file move = drift; `/spec-board` will flag it as Type B.

## Rules
- Follow spec exactly. Check off each step. No commits during `/spec-work`.
- Blocked → set `blocked`, ask user. Skill references → invoke via `Skill` tool.
- `--complete`: skip steps 9-12 (changelog + verify + test + review). Use when manually verified. STILL set `Status: completed` AND move file to `specs/completed/`.
- Missing optional agents never block — log skip and continue.

## Next Step

> 📋 `/spec-review NNN` — validate, then `/commit`
