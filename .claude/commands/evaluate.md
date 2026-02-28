---
model: opus
mode: plan
argument-hint: "<url-or-pasted-text>"
allowed-tools: Read, Glob, Grep, WebFetch, WebSearch, AskUserQuestion
---

Systematically evaluates an external idea, article, tool, or pattern against the existing npx-ai-setup template inventory. Input: $ARGUMENTS

## Phase 1 — Acquire Input

### 1a — Parse Input

Inspect `$ARGUMENTS`:

- If it starts with `http://` or `https://`: fetch via WebFetch. Use the prompt: "Extract all Claude Code patterns, workflow commands, agent definitions, hook configurations, settings fields, and tool recommendations mentioned in this content. List each as a named item with a one-sentence description."
- If it looks like a search query (no URL, short phrase): use WebSearch to find the most relevant article or discussion, then WebFetch the result.
- Otherwise: treat the full argument text as pasted content and extract patterns directly by reading it carefully.

Produce a numbered **Proposal Inventory** — every distinct pattern, feature, command, agent, rule, hook, or tool identified in the input. Format:

```
1. [Name]: [one-line description]
2. [Name]: [one-line description]
...
```

If nothing can be extracted, report "No actionable Claude Code patterns found" and stop.

---

## Phase 2 — Build Existing Inventory

Scan the project to understand what we already have. Run all reads in parallel:

1. Glob `templates/commands/*.md` — list all command filenames and read first 3 lines (frontmatter + description) of each
2. Glob `templates/agents/*.md` — list all agent filenames and read first 3 lines of each
3. Glob `templates/claude/rules/*.md` — list all rule filenames and read first 5 lines of each
4. Read `templates/claude/settings.json` — note all top-level keys and notable field values
5. Glob `.claude/commands/*.md` — list all project-local commands (these are maintenance tools, not distributed)

Produce an **Existing Inventory** grouped by category:

```
Commands:    analyze, bug, commit, grill, pr, reflect, release, review, spec, spec-board,
             spec-review, spec-work, spec-work-all, techdebt, test
Agents:      build-validator, code-architect, code-reviewer, context-refresher, perf-reviewer,
             staff-reviewer, test-generator, verify-app
Rules:       general, git, testing, typescript
Settings:    [key fields from settings.json]
Local Cmds:  [.claude/commands/ list]
```

---

## Phase 3 — Gap Analysis

For each item in the Proposal Inventory, classify it against the Existing Inventory:

| Classification | Meaning |
|---|---|
| **NEW** | We have nothing equivalent — this fills a genuine gap |
| **BETTER** | We have something similar but the proposed version is stronger, cleaner, or more complete |
| **REDUNDANT** | We already have this — our version is equivalent or the difference is cosmetic |
| **WORSE** | We have this and our version is stronger — the proposal would be a downgrade |

Use Grep to search for keyword matches before classifying as NEW. Do not classify as NEW without searching first.

---

## Phase 4 — Output: Findings Table

Present a structured findings table:

```
## Evaluation Results

**Source**: [URL or "inline text"]
**Evaluated**: [date]

### Findings

| # | Pattern | Classification | Existing Equivalent | Recommended Action |
|---|---------|----------------|--------------------|--------------------|
| 1 | [name]  | NEW            | —                  | Create spec        |
| 2 | [name]  | BETTER         | templates/commands/spec.md | Modify via spec |
| 3 | [name]  | REDUNDANT      | templates/agents/code-reviewer.md | Skip |
| 4 | [name]  | WORSE          | templates/claude/rules/general.md | Skip |

### Summary

- NEW findings: N
- BETTER findings: N
- REDUNDANT findings: N
- WORSE findings: N

### Overhead Assessment

For each NEW or BETTER finding, briefly state:
- Maintenance burden: [low / medium / high]
- Integration complexity: [low / medium / high]
- User value: [low / medium / high]

### Verdict

[One paragraph: overall assessment of the evaluated content. Is it worth adopting partially, fully, or not at all? What is the highest-value action?]
```

**Rules for the table:**
- Every item from Phase 1 must appear as a row
- Existing Equivalent must name the actual file path (e.g., `templates/commands/grill.md`) or `—` for NEW
- Recommended Action must be one of: `Create spec` / `Modify via spec` / `Replace via spec` / `Skip`
- Never recommend directly modifying files — always route through specs

---

## Phase 5 — Spec Recommendations

List only the ADOPT-worthy findings (NEW or BETTER with high/medium user value):

```
## Adoption Candidates

1. [Pattern name] — [one-line rationale]
   Action: Create spec for `.claude/commands/[name].md`

2. [Pattern name] — [one-line rationale]
   Action: Modify `templates/commands/[existing].md` via spec
```

If there are no adoption candidates, state: "No adoption candidates identified — no action recommended."

---

## Phase 6 — Spec Creation Gate

If there are adoption candidates, use `AskUserQuestion` with the following options:

```
Which findings should become specs now?
```

Options: one option per adoption candidate (e.g., "1 — [Pattern name]"), plus:
- "All of the above"
- "None — I will decide later"

If the user selects one or more items: list the exact `/spec` commands they should run, pre-filled with a suggested task description. Do NOT create the specs — only recommend the commands.

Example output:
```
Run the following to create specs:

  /spec "Add [pattern name] command to templates/commands/"
  /spec "Improve [existing command] with [specific improvement]"
```

---

## Rules

- Read-only: never write, create, or modify any file
- Never auto-create specs — only recommend `/spec` commands for the user to run
- Scoped to Claude Code AI dev environment patterns only — do not evaluate general programming tools
- Always search before classifying as NEW — use Grep with relevant keywords
- If WebFetch fails, note the error and ask the user to paste the content directly
