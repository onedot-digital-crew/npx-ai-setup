# Spec: Spec Dependencies (lightweight)

> **Spec ID**: 663 | **Created**: 2026-05-01 | **Status**: completed | **Complexity**: small | **Branch**: —

<!-- depends_on: [654, 662] -->

## Goal

Mache Spec-Reihenfolge maschinenlesbar: optionales `depends_on` Frontmatter, `/spec-board` und `/spec-work` lesen es und blockieren falsche Reihenfolge.

## Context

Aus Fission-AI/OpenSpec adaptiert (light): aktuell stehen Spec-Abhängigkeiten nur in Prosa ("Spec 654 zuerst, dann 655"). Wenn 8 Specs queued sind, ist Reihenfolge unklar und User muss raten. Lösung: simples YAML-Frontmatter `depends_on: [654, 655]`. Tools lesen via `yq`/`jq`, sortieren topologisch, blockieren `in-progress` wenn Dependencies nicht `completed`.

Kein eigener CLI, keine Validation-Engine — Bash + `yq` reichen.

## Stack Coverage

- **Profiles affected**: all (ai-setup-Repo selbst und Zielprojekte)
- **Per-stack difference**: none

## Steps

- [ ] Step 1: `templates/skills/spec/SKILL.template.md` — Frontmatter-Format dokumentieren: optionaler YAML-Header `depends_on: [654, 655]` zwischen erstem `>` Block und Goal
- [ ] Step 2: `templates/skills/spec-board/SKILL.template.md` — Board liest `depends_on` per `yq`/grep, zeigt blockierte Specs mit Marker `⛔ blocked by 654`
- [ ] Step 3: `templates/skills/spec-work/SKILL.template.md` — vor Start prüft ob alle `depends_on` Status `completed`; sonst Abbruch mit klarer Message
- [ ] Step 4: `templates/scripts/spec-deps-check.sh` — Helper: gibt JSON mit `{spec, status, blocked_by[]}` für alle Specs in `specs/`
- [ ] Step 5: Bestehende Specs 655-663 mit `depends_on` Frontmatter rückwirkend annotieren
- [ ] Step 6: `templates/skills/spec/SKILL.template.md` — Plan-Header-Block (aus obra/superpowers) ergänzen: optional `## Architecture`, `## Tech Stack`, `## Verification per Step` als Inhaltsblöcke; Steps bekommen Empfehlung "verifiable check pro Step"
- [ ] Step 7: `bash bin/sync-local.sh` nach Template-Edits

## Acceptance Criteria

- [ ] `templates/skills/spec/SKILL.template.md` zeigt Beispiel mit `depends_on: [654]`
- [ ] `/spec-board` markiert blockierte Specs sichtbar
- [ ] `/spec-work 655` schlägt fehl wenn 654 nicht `completed`, mit Message `Spec 655 depends on 654 (status: draft) — finish 654 first`
- [ ] `spec-deps-check.sh` exit 0 bei valider Reihenfolge, exit 1 bei Zyklen
- [ ] Specs ohne `depends_on` funktionieren wie bisher (kein Pflicht-Feld)
- [ ] `bash .claude/scripts/quality-gate.sh` grün

## Files to Modify

> Nur `templates/` editieren. `.claude/` Mirrors via `bash bin/sync-local.sh` aus Spec 654.

- `templates/skills/spec/SKILL.template.md` - Frontmatter-Format
- `templates/skills/spec-board/SKILL.template.md` - Blocked-Marker
- `templates/skills/spec-work/SKILL.template.md` - Pre-Check
- `templates/scripts/spec-deps-check.sh` - Helper-Script
- `specs/655-...md` bis `specs/663-...md` - `depends_on` rückwirkend
- `bash bin/sync-local.sh` nach Template-Edits

## Out of Scope

- Visualisierung (graph-output, change-graph CLI)
- Auto-Resolve (Specs in richtiger Reihenfolge automatisch starten)
- Capabilities-Tracking
- Cross-Repo Dependencies
