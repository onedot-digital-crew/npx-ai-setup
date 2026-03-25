# Spec 584: session-optimize Duplicate Finding Filter

> **Spec ID**: 584 | **Created**: 2026-03-25 | **Status**: completed | **Complexity**: low | **Branch**: —

## Goal

session-optimize soll keine Findings reporten, die bereits in `.claude/findings-log.md` als addressed markiert sind.

## Context

Step 5 prüft nur ob Files existieren, nicht ob ein Finding bereits adressiert wurde. `.claude/findings-log.md` ist eine persistente Checkliste aller bisherigen Findings — session-optimize muss diese vor dem Report als Pre-Filter lesen.

## Steps

- [x] Step 1: In SKILL.md Step 5 einbauen — `Read .claude/findings-log.md` vor der File-Verifikation
- [x] Step 2: Filterregel ergänzen: "Finding-Topic gegen `## Addressed` Einträge abgleichen — Treffer → droppen"
- [x] Step 3: In `## Next Step` Abschnitt ergänzen: neue Findings nach dem Report in `## Open` von findings-log.md eintragen
- [x] Step 4: Rule in `## Rules` aktualisieren: altes "Skip findings that duplicate LEARNINGS.md" durch "Read .claude/findings-log.md as pre-filter" ersetzen

## Acceptance Criteria

### Truths
- [ ] SKILL.md enthält expliziten `Read .claude/findings-log.md` Schritt vor Step 5's File-Check
- [ ] `## Rules` referenziert findings-log.md (nicht mehr nur LEARNINGS.md)
- [ ] `## Next Step` enthält Anweisung, neue Findings in findings-log.md einzutragen

### Artifacts
- [ ] `.claude/skills/session-optimize/SKILL.md` — Pre-Filter + Updated Rules + Next Step (min 4 neue Zeilen)

## Files to Modify

- `.claude/skills/session-optimize/SKILL.md` — Step 5, Rules, Next Step

## Out of Scope

- Format-Änderungen an findings-log.md selbst
- Automatisches Schreiben in findings-log.md (bleibt manuell)
