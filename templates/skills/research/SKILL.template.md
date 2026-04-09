---
name: research
description: "Deep-researches an external repository, tool, or pattern. Produces a brainstorm document with prioritized adoption candidates."
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

## Phase 1 — Acquire

- **GitHub repo URL**: Deep Repo Scrape (below)
- **Article/blog URL**: WebFetch → extract patterns → Phase 2
- **Search query**: WebSearch → WebFetch best result → Phase 2
- **Pasted text**: extract patterns directly → Phase 2

### Deep Repo Scrape (GitHub only)

Spawn parallel haiku agents — one per directory type: commands, agents/skills, hooks/scripts, config/README. Each reads raw GitHub URLs (`https://raw.githubusercontent.com/OWNER/REPO/main/PATH`). Return full content, not summaries.

In parallel: read our existing `templates/`, `.claude/rules/`, `lib/plugins.sh`.

Compile inventory:
```
EXTERNAL: [N] commands, [N] skills, [N] hooks
OURS:     [N] commands, [N] rules, [N] hooks
```

## Phase 2 — Match & Compare

Coverage table per external item: ✅ Covered / ⚠️ Partial / ❌ Missing

For **Partial** items: quote exact line from theirs vs. our gap.
For **systemic patterns**: delegation structure, quality gates, scripted vs. LLM-driven.

## Phase 3 — Brainstorm Document

Write to `specs/NNN-research-[source-name].md`:

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

## Phase 4 — Interview

`AskUserQuestion` — top 5 findings, which to explore deeper. Min 2 rounds.

## Phase 5 — Philosophy Check (mandatory)

Read `CONCEPT.md` / `decisions.md`. Per candidate: GO / PIVOT / SKIP.
- Safety: does it ADD or REMOVE guardrails? (npx-ai-setup is safety-first)
- Layer: base setup vs. boilerplate-specific?
- Already covered by an existing feature?

Only GO candidates proceed. (This gate exists because /research generates enthusiasm — the interview selects favorites, but without this check specs get created then cancelled.)

## Phase 6 — Spec Gate

`AskUserQuestion` multiSelect — one option per GO candidate. Create spec files for selected items.

## Rules

- GitHub repos: read EVERY relevant file, not just README
- Agents return full content, not summaries
- Quote exact lines — no vague comparisons
- If our version is better, say so
- Append researched source to `README.md` under `## Links → ### Evaluated`

## Next Step

`/spec NNN` on selected candidate, or `/spec-board` for full pipeline.
