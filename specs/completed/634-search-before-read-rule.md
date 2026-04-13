# Spec: Search-before-Read Regel in Rules

> **Spec ID**: 634 | **Created**: 2026-04-13 | **Status**: completed | **Complexity**: low | **Branch**: —

## Goal

Explizite "Search first, Read last"-Regel in quality.md und agents.md einführen damit Claude File-Reads auf das Nötigste reduziert.

## Context

SymDex Research (spec 630) hat gezeigt dass Full-File-Reads ~250 Tokens kosten, ein gezielter Grep/Glob ~5-20 Tokens. Unsere Rules haben bereits "Graph-Assisted Navigation" in agents.md, aber keine allgemeine Search-before-Read-Direktive. Decision #4 (Token Optimization mandatory) fordert diese Ergänzung.

### Verified Assumptions

- `quality.md` hat eine Performance-Sektion — Evidence: `templates/claude/rules/quality.md:16` | Confidence: High | If Wrong: eigenen Abschnitt anlegen
- `agents.md` hat "Graph-Assisted Navigation" als Vorbild — Evidence: `templates/claude/rules/agents.md:43` | Confidence: High | If Wrong: passt trotzdem als eigener Block
- Projektspezifische Rules in `.claude/rules/` werden von Templates separat deployed — Evidence: `lib/generate.sh` | Confidence: High | If Wrong: beide Pfade anpassen

## Steps

- [ ] 1. `templates/claude/rules/quality.md` — unter Performance einen neuen Bullet "Search before Read" hinzufügen: Glob/Grep vor Read, Read vor Agent-Spawn, Full-File-Read nur wenn Symbol-Kontext nicht ausreicht
- [ ] 2. `templates/claude/rules/agents.md` — nach "Graph-Assisted Navigation" einen neuen Block "File Navigation Priority" mit 3-stufiger Hierarchie: (1) Glob/Grep, (2) Targeted Read mit Offset, (3) Full-File-Read
- [ ] 3. Projektspezifische Kopien aktualisieren: `.claude/rules/quality.md` + `.claude/rules/agents.md` im npx-ai-setup Repo selbst

## Acceptance Criteria

- [ ] `grep -n "Search before Read\|before.*[Rr]ead" templates/claude/rules/quality.md` gibt ein Ergebnis
- [ ] `grep -n "File Navigation\|Glob.*before\|before.*Read" templates/claude/rules/agents.md` gibt ein Ergebnis
- [ ] Beide Regeln passen inhaltlich zusammen (quality.md allgemein, agents.md agent-spezifisch)

## Files to Modify

- `templates/claude/rules/quality.md` — Bullet unter Performance
- `templates/claude/rules/agents.md` — neuer Block nach Graph-Assisted Navigation
- `.claude/rules/quality.md` — projektspezifische Kopie
- `.claude/rules/agents.md` — projektspezifische Kopie

## Out of Scope

- Skill-Template-Änderungen (→ Spec 635)
- Circular Dependency Detection (→ Spec 629)
- Änderungen an anderen Rule-Dateien
