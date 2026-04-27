---
name: reflect
description: "Analyze the current session for corrections, architectural discoveries, and stack decisions — convert them into permanent learnings."
user-invocable: true
effort: medium
model: sonnet
disable-model-invocation: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - AskUserQuestion
---

Analyze the current session for corrections, architectural discoveries, and stack decisions — convert them into permanent learnings.

## Process

### 1. Recall session signals

Review the conversation history and extract only:
- **CORRECTION**: explicit corrections or rejected approaches
- **AFFIRMATION**: approved approaches worth preserving
- **ARCHITECTURAL**: data flow, boundaries, dependencies, gotchas
- **STACK**: dependencies, versions, tool choices, runtime requirements

Skip general questions, clarifications, and one-off decisions without reusable value.

If `decisions.md` exists and you find new architectural decisions, append only genuinely new rows with the next D-number.

### 2. Classify by target

| Signal type | Target | Section |
|---|---|---|
| Coding style, naming, patterns, tooling | `.agents/context/LEARNINGS.md` | `## Conventions` |
| Component relationships, data flow, gotchas | `.agents/context/LEARNINGS.md` | `## Architecture` |
| Dependencies, versions, runtime requirements | `.agents/context/LEARNINGS.md` | `## Stack` |
| Corrections and approved approaches | `.agents/context/LEARNINGS.md` | `## Corrections` |
| Workflow, process rules, safety rules | `CLAUDE.md` | Critical Rules |
| Tool usage, commands, CLI patterns | `CLAUDE.md` | Commands |

Prefer `.agents/context/LEARNINGS.md`. Only workflow and CLI rules go to `CLAUDE.md`.

### 3. Draft smart-merge operations

Read `.agents/context/LEARNINGS.md` and `CLAUDE.md` first.

For each signal, classify the write operation:
- `+ ADD` — new rule or fact
- `~ UPDATE` — refine an existing entry
- `- REMOVE` — stale or contradicted entry

Draft rules:
- Max 1-2 lines per entry
- Corrections and affirmations as directives
- Architecture and stack items as factual statements

If there are no actionable signals, report that and stop.

### 4. Ask for approval

Use AskUserQuestion to show all proposed operations grouped by target and section.
Offer: `Apply all`, `Skip all`, `Edit manually`.

### 5. Write approved changes

Only write approved items.

For `.agents/context/LEARNINGS.md`:
- Create the file only if needed
- Keep sections to `Corrections`, `Conventions`, `Architecture`, `Stack`
- Only create sections that have entries
- `ADD` append, `UPDATE` replace, `REMOVE` delete

For `CLAUDE.md`:
- `ADD` append under `Critical Rules` or `Commands`
- `UPDATE` replace
- `REMOVE` delete

### 6. Save approved corrections to claude-mem

After writing approved changes, save only approved **CORRECTION** signals to `mcp__plugin_claude-mem_mcp-search__save_memory`.

Use:
- `title`: `decision: [context] — [decision]`
- `text`:
  ```
  Project: [project]
  Context: [component, file, or feature]
  Decision: [chosen approach]
  Avoid: [rejected alternative]
  Reason: [one sentence]
  ```

If the plugin is unavailable, skip silently.

## Rules
- Smart merge only: ADD, UPDATE, REMOVE.
- Never write low-signal observations as durable rules.
- If a signal is ambiguous, skip it.
- Do not invent learnings when none were observed.
- LEARNINGS.md is primary; CLAUDE.md is secondary.

## Next Step

Run `/commit` to persist the LEARNINGS.md / CLAUDE.md updates.
