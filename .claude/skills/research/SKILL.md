---
name: research
description: "Deep-researches an external repository, tool, or pattern; produces a prioritized brainstorm doc. Trigger: 'research X', 'evaluate this tool', 'look into this repo'."
user-invocable: true
effort: high
model: opus
argument-hint: "<github-url or article-url>"
allowed-tools:
  - Read
  - Glob
  - Grep
  - WebFetch
  - WebSearch
  - AskUserQuestion
  - Agent
  - Bash
---

Deep-researches an external repository, tool, or pattern. Input: $ARGUMENTS

## Process

### 1. Acquire source material

- **GitHub repo URL**: run a deep repo scrape
- **Article/blog URL**: WebFetch and extract patterns
- **Search query**: WebSearch, then WebFetch the best result
- **Pasted text**: extract patterns directly

#### Deep repo scrape

Spawn parallel haiku agents by area: commands, agents/skills, hooks/scripts, config/README.
Each agent reads raw GitHub content and returns full content, not summaries.

In parallel, detect the current project type and read relevant local context:
- **npx-ai-setup**: read `templates/`, `.claude/rules/`, `lib/plugins.sh`
- **Other project**: read `.claude/`, `CLAUDE.md`, `package.json`, top-level config files

Build an inventory:

```text
EXTERNAL: [N] commands, [N] skills, [N] hooks
OURS:     [N] commands, [N] rules, [N] hooks
```

### 2. Match and compare

For each external item, classify:
- ✅ Covered
- ⚠️ Partial
- ❌ Missing

For partial coverage, quote exact lines showing the gap.
Also compare systemic patterns such as delegation, quality gates, and scripted vs LLM-driven workflows.

### 3. Write brainstorm document

Write `specs/NNN-research-[source-name].md`:

```markdown
# Brainstorm: [Source] Adaptionen für [project]
> Source: [URL] | Date: [date]

## Bestandsvergleich
[coverage table]

## Kandidaten für Adaption
[NEW/PARTIAL items: description, gap, effort, recommendation]

## Patterns zum Adaptieren
[Specific quotes worth adopting]

## Ranking nach Aufwand/Nutzen
[Item | Value ★ | Aufwand | Empfehlung]
```

### 4. Interview

Use AskUserQuestion to explore the top 5 findings. Run at least 2 rounds.

### 5. Philosophy check

Read project-specific philosophy docs if they exist (`CONCEPT.md`, `decisions.md`, `docs/architecture.md`). For each candidate, classify:
- GO
- PIVOT
- SKIP

Check:
- Does it fit the project's purpose and conventions?
- Does it add or remove guardrails?
- Is it already covered?

Only GO candidates proceed.

### 6. Spec gate

Use AskUserQuestion multi-select with one option per GO candidate. Create spec files for selected items.

## Rules
- For GitHub repos, read all relevant files, not just the README.
- Agents must return source material, not summaries.
- Quote exact lines when comparing.
- If our current implementation is better, say so.
- Append the researched source to `README.md` under `## Links → ### Evaluated`.

## Next Step

Run `/spec NNN` for selected candidates or `/spec-board`.
