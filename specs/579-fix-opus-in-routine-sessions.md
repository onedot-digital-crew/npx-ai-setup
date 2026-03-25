# Spec 579: Opus-Anteil in Routine-Sessions eliminieren

> **Spec ID**: 579 | **Created**: 2026-03-25 | **Status**: in-review | **Complexity**: medium | **Branch**: spec/579-fix-opus-in-routine-sessions

## Goal

Den Opus-Anteil in normalen Arbeits-Sessions auf 0% senken — Session-Metriken zeigen 28% Opus in einer 60-Minuten-Session mit Skills commit, reflect, session-optimize.

## Context

Session-Optimize-Analyse (2026-03-25): Session 50ee05b5 (60min) zeigt claude-opus-4-6:31 von 110 Turns (28%). Opus kostet 5x mehr als Sonnet. Die drei involvierten Skills (session-optimize, reflect, commit) sollten kein Opus triggern. Mögliche Ursachen: (a) Skill-Prompts enthalten `model: opus` Override, (b) Skill enthält "ultrathink:" Prefix der Opus triggert, (c) extended thinking wird durch bestimmte Prompt-Strukturen ausgelöst.

## Steps

- [x] Step 1: `session-optimize` SKILL.md lesen — auf `model:`, `ultrathink`, oder Opus-Referenzen prüfen
- [x] Step 2: `reflect` SKILL.md (templates/skills/reflect/) lesen — gleiche Prüfung
- [x] Step 3: `commit` SKILL.md (templates/skills/commit/) lesen — gleiche Prüfung
- [x] Step 4: Gefundene Opus-Trigger entfernen oder durch Sonnet ersetzen
- [x] Step 5: Prüfen ob andere Routine-Skills (pause, review, lint) ähnliche Trigger haben

## Acceptance Criteria

- [x] Keiner der drei Skills (session-optimize, reflect, commit) enthält `model: opus` oder `ultrathink:` in Pfaden die Routine-Ausführung betreffen
- [x] Skills die Opus legitim brauchen (Architecture-Review, komplexe Analyse) sind explizit und kommentiert dokumentiert
- [x] Komplexitäts-abhängiges Routing (z.B. spec-work high = Opus) bleibt erhalten

## Files to Modify

- `.claude/skills/session-optimize/SKILL.md`
- `templates/skills/reflect/SKILL.md`
- `templates/skills/commit/SKILL.md`
- `templates/skills/pause/SKILL.md` — präventiv prüfen
- `templates/skills/review/SKILL.md` — präventiv prüfen

## Out of Scope

- Haiku-Routing für Explore-Agents (→ Spec 575)
- spec-work high-complexity Opus (legitim, bleibt)
- Änderungen an `.claude/settings.json` Modell-Defaults
