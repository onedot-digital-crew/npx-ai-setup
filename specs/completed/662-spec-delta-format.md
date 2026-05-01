# Spec: Brownfield Spec Delta Format

> **Spec ID**: 662 | **Created**: 2026-05-01 | **Status**: completed | **Complexity**: small | **Branch**: —

<!-- depends_on: [654] -->

## Goal

Erweitere Spec-Template um optionalen Delta-Block für Brownfield-Specs, damit `/review --spec` und `implementer` Verhaltensänderungen explizit sehen.

## Context

Aus Fission-AI/OpenSpec adaptiert: Greenfield-Specs (neuer Skill, neuer Hook) brauchen kein Delta. Brownfield-Specs (Refactor, Rule-Change, Hook-Merge wie Spec 657) sollten explizit `MODIFIED:` und `REMOVED:` Sektionen haben. Hilft Implementer beim Verstehen "was bleibt, was ändert sich" und Review beim Diff-Check.

Format ist **opt-in**, nicht Pflicht. Spec-Author entscheidet beim Erstellen, ob Block sinnvoll.

## Stack Coverage

- **Profiles affected**: all
- **Per-stack difference**: none

## Steps

- [ ] Step 1: `templates/skills/spec/SKILL.template.md` — optionalen Block dokumentieren: `## Changes to Existing Behavior` mit Sub-Sektionen `### MODIFIED: <component>` und `### REMOVED: <component>`
- [ ] Step 2: `templates/skills/spec/SKILL.template.md` — Beispiel ergänzen: Hook-Merge-Spec hat `### MODIFIED: graph-context.sh` und `### REMOVED: graph-before-read.sh`
- [ ] Step 3: `templates/skills/spec/SKILL.template.md` — Heuristik dokumentieren: wenn Spec >2 bestehende Files modifiziert oder löscht → Delta-Block empfohlen
- [ ] Step 4: `templates/skills/review/SKILL.template.md` — `--spec` Mode liest Delta-Block und prüft pro MODIFIED/REMOVED, ob Diff entspricht
- [ ] Step 5: `bash bin/sync-local.sh` nach Template-Edits

## Acceptance Criteria

- [ ] Spec-Template enthält Delta-Block-Beispiel
- [ ] `/review --spec` erkennt Delta-Block und nutzt ihn als zusätzliche Diff-Prüfung
- [ ] Greenfield-Spec ohne Delta-Block bleibt valid (keine Pflicht)
- [ ] `bash .claude/scripts/quality-gate.sh` grün

## Files to Modify

> Nur `templates/` editieren. `.claude/` Mirrors via `bash bin/sync-local.sh` aus Spec 654.

- `templates/skills/spec/SKILL.template.md` - Delta-Block dokumentieren
- `templates/skills/review/SKILL.template.md` - `--spec` Mode Delta-Diff
- `bash bin/sync-local.sh` nach Template-Edits

## Out of Scope

- RFC2119 SHALL/MUST Format
- GIVEN/WHEN/THEN Scenarios
- Capabilities-Sektion
- Validation-Engine
