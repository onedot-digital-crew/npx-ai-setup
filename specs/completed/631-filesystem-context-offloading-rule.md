# Spec 631: Filesystem Context Offloading Regel
> **Status**: completed | Effort: XS | Source: specs/630-research-agent-skills-context-engineering.md

## Problem

Sub-Agents geben große Outputs direkt zurück — das belastet den Haupt-Kontext.
Scrape-Agents, Explore-Agents und Research-Agents liefern oft 5-40KB zurück.
RTK filtert und kürzt automatisch, aber kein expliziter Hinweis existiert in agents.md.

Resultat: Agents erben implizit das Muster, statt es als Best Practice zu kennen.

## Lösung

Soft-Empfehlung in `templates/claude/rules/agents.md` und `.claude/rules/agents.md`:
Sub-Agent-Outputs >2KB sollen in Dateien geschrieben und der Pfad zurückgegeben werden.

## Was sich ändert

### templates/claude/rules/agents.md und .claude/rules/agents.md

Neue Sektion "Output Offloading" nach "Agent Dispatch":

```markdown
## Output Offloading

When spawning agents that return large outputs (scrape, explore, research):
- Instruct agents to write outputs >2KB to `$TMPDIR/agent-output-<task>.md`
- Agent returns only the file path, not the full content
- Read the file only when specific sections are needed

This prevents large tool results from filling the context window.
```

## Ziel

Aus dem Research: "Prefer dynamic context discovery over static inclusion,
because static context consumes tokens regardless of relevance."

## Akzeptanzkriterien

- [ ] Sektion in templates/claude/rules/agents.md vorhanden
- [ ] Sektion in .claude/rules/agents.md vorhanden
- [ ] Formulierung als Soft-Empfehlung (prefer, should), nicht als Pflicht

## Nicht in Scope

- Kein Hook, kein Enforcement
- Kein Threshold-Check
- Kein Umbau bestehender Skills
