# Spec 632: PreCompact Hook — Structured Summary Template
> **Status**: completed | Effort: S | Source: specs/630-research-agent-skills-context-engineering.md

## Problem

precompact-guidance.sh gibt Claude vor AutoCompact generische Hinweise.
Die Compression-Ausgabe ist unstrukturiert — Claude entscheidet selbst, was zu behalten ist.

Resultat: Kumulative Detail-Verluste bei mehrfachen AutoCompact-Events in langen Sessions.
Insbesondere: geänderte Dateien, getroffene Entscheidungen und Next Steps gehen verloren.

## Lösung

Strukturierte Summary-Vorlage in precompact-guidance.sh einbauen.
Claude bekommt ein konkretes Format, das als Checkliste wirkt und stille Informationsverluste verhindert.

Aus dem Research (Anchored Iterative Summarization):
> "Maintain structured, persistent summaries with explicit sections for session intent,
> file modifications, decisions, and next steps. Summarize only the newly-truncated span
> and merge with existing summary rather than regenerating from scratch."

## Was sich ändert

### .claude/scripts/precompact-guidance.sh (und template)

Aktuellen Output um strukturierten Template-Abschnitt ergänzen:

```bash
cat <<'GUIDANCE'
## Structured Summary Template

When creating the compacted summary, use this structure to prevent information loss:

### Session Intent
[1-2 sentences: what is being built/fixed in this session]

### Files Modified
[list each file path changed this session with one-line description of change]

### Decisions Made
[list technical decisions and the reasoning behind them]

### Blockers & Open Questions
[anything unresolved that the next context window needs to handle]

### Next Steps
[concrete next actions, in order]

---
Merge this template with any existing summary rather than regenerating from scratch.
Preserve all file paths and decisions from previous compactions.
GUIDANCE
```

## Ziel

Verhindert, dass repeated AutoCompact-Events Details verlieren die Claude als "low-priority"
einstuft aber der Task benötigt (z.B. spezifische Dateipfade, Rollback-Entscheidungen).

## Akzeptanzkriterien

- [ ] precompact-guidance.sh enthält strukturiertes Template nach bestehendem Hinweis-Block
- [ ] Template hat 5 Sektionen: Intent, Files Modified, Decisions, Blockers, Next Steps
- [ ] Hinweis "Merge, nicht regenerate" ist enthalten
- [ ] templates/claude/scripts/ oder templates/scripts/ entsprechend aktualisiert
- [ ] Kein Breaking Change am bestehenden Hook-Output

## Nicht in Scope

- Kein neues Hook-Event
- Kein automatisches Parsen der Summary
- Kein Schreiben in persistente Datei (das wäre Scope Creep)
