# Spec: `/spec-review` in `/review --spec` migrieren

> **Spec ID**: 658 | **Created**: 2026-05-01 | **Status**: completed | **Complexity**: medium | **Branch**: —

<!-- depends_on: [654] -->

## Goal

Reduziere Skill-Oberfläche, indem `/spec-review` als eigener Skill entfällt und seine Funktion als Spec-Modus in `/review` integriert wird.

## Context

Review-Funktionalität ist doppelt: `/review` prüft uncommitted changes, `/spec-review` prüft Spec-Acceptance und bewegt Status nach completed. Das ist konzeptionell ein Review-Modus. Zusammenlegung spart Routing-Entscheidungen, behält aber Acceptance-Criteria-Prüfung und Status-Lifecycle.

## Stack Coverage

- **Profiles affected**: all
- **Per-stack difference**: none

## Steps

- [ ] Step 1: `templates/skills/review/SKILL.template.md` — Argument-Modi ergänzen: `/review`, `/review --spec NNN`, `/review --quick`, `/review --deep`
- [ ] Step 2: `templates/skills/review/SKILL.template.md` — Spec-Modus aus `spec-review` übernehmen: Spec finden, Status `in-review` prüfen, ACs verifizieren, prep output nutzen
- [ ] Step 3: `templates/skills/review/SKILL.template.md` — Status-Lifecycle übernehmen: APPROVED → `completed` + move nach `specs/completed/`; CHANGES REQUESTED → `in-progress`; REJECTED → `blocked`
- [ ] Step 4: `templates/skills/review/SKILL.template.md` — Reviewer-Agent-Dispatch aus Spec-Review integrieren und mit bestehendem Review-Modus deduplizieren
- [ ] Step 5: `templates/skills/spec-review/` — Skill entfernen; `.claude/skills/spec-review/` via Sync/cleanup entfernen
- [ ] Step 6: Routing-Docs aktualisieren: `/spec-work` Next Step → `/review --spec NNN`
- [ ] Step 7: `spec-board` und workflow hints prüfen, keine `/spec-review` Empfehlungen mehr
- [ ] Step 8: `lib/update.sh cleanup_known_orphans` — `.claude/skills/spec-review/SKILL.md` und References als bekannte Orphans eintragen
- [ ] Step 9: Auto-Invocation klären: `/review --spec NNN` darf nach `/spec-work` weiterhin auto-invoked werden (wie bisher `/spec-review`); `disable-model-invocation` für Standard-`/review` bleibt bestehen, aber `--spec`-Mode ist explizit ausgenommen
- [ ] Step 10: Optionale Spec-Reviewer-Stage (aus obra/superpowers): in `/spec-work` zwischen `implementer` und `code-reviewer` einen leichten Spec-Compliance-Check einbauen — prüft nur AC-Erfüllung des aktuellen Steps, kein Code-Review; opt-in via Spec-Frontmatter `review_per_step: true`

## Acceptance Criteria

- [ ] `/review --spec NNN` deckt alle bisherigen `/spec-review` Acceptance-Kriterien ab
- [ ] `rg "/spec-review" templates .claude README.md WORKFLOW-GUIDE.md` findet nur Migrations-/Changelog-Kontext oder gar nichts
- [ ] `templates/skills/spec-review/` existiert nicht mehr
- [ ] `review` Skill bleibt unter 180 Zeilen oder ist in klare `references/` ausgelagert
- [ ] `/review --spec NNN` ist auto-invocable (wie altes `/spec-review`), `/review` ohne Args bleibt user-only
- [ ] `bash .claude/scripts/quality-gate.sh` grün

## Files to Modify

> Nur `templates/` editieren. `.claude/` Mirrors via `bash bin/sync-local.sh --prune` aus Spec 654.

- `templates/skills/review/SKILL.template.md` - Spec-Modus integrieren
- `templates/skills/spec-review/` - DELETE (template + mirror via sync --prune)
- `templates/skills/spec-work/SKILL.template.md` - Next Step
- `templates/skills/spec-board/SKILL.template.md` - Hinweise prüfen
- `templates/claude/rules/workflow.md` - Routing
- `README.md`, `WORKFLOW-GUIDE.md` - Docs
- `lib/update.sh` - Orphan cleanup für alte spec-review Skill-Dateien
- `bash bin/sync-local.sh --prune` nach Template-Edits

## Out of Scope

- `/review` in mehrere neue Skills splitten
- Review-Agents entfernen
- Spec-Dateiformat ändern
