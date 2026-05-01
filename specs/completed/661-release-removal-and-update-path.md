# Spec: `/release` aus Templates entfernen + Update-Path validieren

> **Spec ID**: 661 | **Created**: 2026-05-01 | **Status**: completed | **Complexity**: medium | **Branch**: —

<!-- depends_on: [654,659] -->

## Goal

Entferne `/release` Skill aus den Templates (gehört zu diesem Repo, nicht in Zielprojekte) und validiere End-to-End, dass `npx ai-setup --patch` ein altes Install sauber auf den neuen Slim-Setup-Stand migriert.

## Context

`/release` macht Versions-Bump, CHANGELOG-Update und Tag — Operationen für npx-ai-setup selbst. In Zielprojekten (Shopify-Theme, Nuxt-App, Laravel) ist das nicht relevant; eigene Release-Flows existieren dort. Skill blockiert Slot in der schlanken Default-Liste.

Gleichzeitig brauchen Specs 654-660 zusammen einen sauberen Update-Path: alte Installs haben `/spec-review`, `/release`, `graph-before-read.sh`, `graph-context.sh`. Nach `npx ai-setup --patch` darf nichts davon übrigbleiben.

## Stack Coverage

- **Profiles affected**: all
- **Per-stack difference**: none

## Steps

- [ ] Step 1: `templates/skills/release/` — DELETE komplett
- [ ] Step 2: `bin/release.sh` — falls noch nicht vorhanden, lokale Release-Logik aus `/release` Skill nach `bin/` extrahieren (nur dieses Repo)
- [ ] Step 3: `templates/claude/rules/workflow.md` — `/release` aus Routing entfernen; Hint nach `/commit` ist nur `/pr` oder Stop
- [ ] Step 4: `lib/update.sh cleanup_known_orphans` — `release/` Skill, alte Hooks (`graph-before-read.sh`, `graph-context.sh`), `spec-review/` Skill als bekannte Orphans eintragen
- [ ] Step 5: `lib/update.sh` — Idempotenz-Check: `--patch` zweimal hintereinander ohne Diff in zweiter Ausführung
- [ ] Step 6: Smoke-Test-Script `tests/update-path.sh` — simuliert altes Install (commit `5a8bd1d` Stand), führt `--patch` aus, verifiziert: `/release`, `/spec-review`, `graph-before-read.sh`, `graph-context.sh` entfernt; `/index`, `graph-hints.sh`, `context-freshness.sh` vorhanden
- [ ] Step 7: README/WORKFLOW-GUIDE — `/release` aus User-facing Skill-Liste entfernen
- [ ] Step 8: CHANGELOG — Migration-Notes für betroffene User

## Acceptance Criteria

- [ ] `templates/skills/release/` existiert nicht
- [ ] `rg "/release" templates README.md WORKFLOW-GUIDE.md` findet nur Migrations-/Changelog-Kontext
- [ ] Smoke-Test `tests/update-path.sh` läuft grün: alte Skills/Hooks weg, neue da
- [ ] Zweimaliger `--patch` Run: zweite Ausführung produziert keinen Diff
- [ ] `bin/release.sh` funktioniert für dieses Repo (Version-Bump + Tag + CHANGELOG)
- [ ] `bash .claude/scripts/quality-gate.sh` grün

## Files to Modify

> Nur `templates/` editieren. `.claude/` Mirrors via `bash bin/sync-local.sh --prune` aus Spec 654.

- `templates/skills/release/` - DELETE
- `bin/release.sh` - lokale Release-Logik
- `templates/claude/rules/workflow.md` - Routing
- `lib/update.sh` - Orphan cleanup + Idempotenz
- `tests/update-path.sh` - End-to-End Smoke-Test
- `README.md`, `WORKFLOW-GUIDE.md` - Docs
- `CHANGELOG.md` - Migration-Notes
- `bash bin/sync-local.sh --prune` nach Template-Edits

## Out of Scope

- Release-Automation für Zielprojekte (eigenes Spec, falls je gewünscht)
- GitHub Actions Release-Workflow ändern
- npm publish flow ändern
