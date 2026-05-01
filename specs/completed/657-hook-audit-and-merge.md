# Spec: Hook-Audit — 10 Hooks auf 6 reduzieren

> **Spec ID**: 657 | **Created**: 2026-05-01 | **Status**: completed | **Complexity**: medium | **Branch**: —

<!-- depends_on: [654] -->

## Goal

Reduziere Hook-Inflation und Überschneidungen, ohne Safety zu schwächen: `graph-before-read.sh` und `graph-context.sh` werden zu `graph-hints.sh` zusammengeführt; Zielgröße 6 aktive Hooks.

## Context

Aktuell gibt es 10 Hooks. Einige sind harte Safety-Gates (`protect-files`, `circuit-breaker`, `shellcheck-guard`), andere sind Hinweise oder Graph-Kontext. `graph-before-read.sh` und `graph-context.sh` überschneiden sich konzeptionell: beide wollen Claude vor oder beim Read/Edit zu Graph-Nutzung bewegen. Ein zusammengeführtes `graph-hints.sh` kann PreToolUse und SessionStart/UserPromptSubmit Modi per Arg bedienen.

**Vorbedingung**: Spec 656 hat `context-freshness.sh` bereits eingeführt. Diese Spec konsolidiert nur den restlichen Bestand.

Ziel-Hooks (Soll-Zustand nach Audit):

- `graph-hints.sh` (neu, ersetzt graph-before-read + graph-context)
- `protect-files.sh` (Safety, behalten)
- `circuit-breaker.sh` (Safety, behalten)
- `shellcheck-guard.sh` (Safety, behalten)
- `context-freshness.sh` (aus Spec 656, behalten)
- 1 weiterer aus Audit-Entscheidung von `post-edit-lint.sh`, `precompact-guidance.sh`, `update-check.sh` — oder begründet 5 statt 6

`task-completed-gate.sh` ist nicht installiert und kein Ziel — aus früherer Planung gestrichen.

## Stack Coverage

- **Profiles affected**: all
- **Per-stack difference**: Shopify Liquid bekommt `.liquid` Graph-Hints; JS/TS bekommt import/reverse-dep Hints

## Steps

- [ ] Step 1: Hook-Inventar dokumentieren: Trigger, Output, Block/Hint, Tokenbudget, realer Nutzen
- [ ] Step 2: `templates/claude/hooks/graph-hints.sh` — neues Script aus `graph-before-read.sh` + `graph-context.sh`, Modus per erstem Argument: `pretool`, `session`
- [ ] Step 3: `graph-hints.sh` — PreToolUse: bestehende Graph-Before-Read-Warnungen + zusätzliche Context-Ausgabe für Read/Edit auf JS/TS/Vue/Liquid
- [ ] Step 4: `graph-hints.sh` — `.liquid` in Settings-Trigger aufnehmen und Liquid-Renderer-Hints sicher ausgeben
- [ ] Step 5: `templates/claude/settings.json` — `graph-before-read.sh` und `graph-context.sh` durch `graph-hints.sh pretool` ersetzen
- [ ] Step 6: Entferne alte Hook-Dateien aus Templates und `.claude/`; `cleanup_known_orphans` entsprechend ergänzen
- [ ] Step 7: Audit-Entscheidung für `post-edit-lint.sh`, `precompact-guidance.sh`, `update-check.sh`: behalten, optional machen oder in andere Checks verschieben
- [ ] Step 8: `templates/scripts/doctor.sh` — erwartete Hook-Anzahl/Registrierung aktualisieren
- [ ] Step 9: README/WORKFLOW-GUIDE/token-optimization Docs aktualisieren

## Acceptance Criteria

- [ ] Aktive Hook-Dateien in `templates/claude/hooks/*.sh` sind Zielgröße 5-6 (begründet bei 5)
- [ ] `templates/claude/settings.json` referenziert keine gelöschten Hooks
- [ ] Read/Edit auf `.ts` liefert forward/reverse Graph-Hints wie vorher
- [ ] Read/Edit auf `.liquid` liefert Liquid-Renderer-Hints
- [ ] Keine Hook-Ausgabe überschreitet Tokenbudget
- [ ] `bash .claude/scripts/quality-gate.sh` grün
- [ ] `doctor.sh` meldet keine Hook-Fehler

## Files to Modify

> Nur `templates/` editieren. `.claude/` Mirrors via `bash bin/sync-local.sh` aus Spec 654.

- `templates/claude/hooks/graph-hints.sh` - neuer zusammengeführter Hook
- `templates/claude/hooks/graph-before-read.sh` - DELETE (template + mirror via sync --prune)
- `templates/claude/hooks/graph-context.sh` - DELETE (template + mirror via sync --prune)
- `templates/claude/settings.json` - Hook-Registrierung
- `templates/scripts/doctor.sh` - Health
- `README.md`, `WORKFLOW-GUIDE.md`, `templates/claude/docs/token-optimization.md` - Docs
- `lib/update.sh` - Known orphan cleanup für alte Hook-Dateien
- `bash bin/sync-local.sh --prune` nach Template-Edits

## Out of Scope

- Safety-Hooks `protect-files`, `circuit-breaker`, `shellcheck-guard` entfernen
- Context-Freshness aus Spec 656 ersetzen
- Neue Graph-Builder schreiben
