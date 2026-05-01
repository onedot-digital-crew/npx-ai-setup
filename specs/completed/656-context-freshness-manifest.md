# Spec: Context Freshness Manifest + Stale-Hinweis

> **Spec ID**: 656 | **Created**: 2026-05-01 | **Status**: completed | **Complexity**: medium | **Branch**: —

<!-- depends_on: [654,655] -->

## Goal

Mach veralteten Projektkontext sichtbar: Hooks vergleichen Source-Hashes gegen `.agents/context/index-manifest.json`, markieren Artefakte stale und zeigen Claude beim Session-Start einen knappen Hinweis.

## Context

Context-Dateien und Graphen sparen Tokens nur, wenn Claude ihnen vertrauen kann. Heute können `package.json`, `composer.json`, Lockfiles, Configs oder Liquid-Dateien geändert werden, ohne dass `.agents/context/` oder Graphen als stale markiert werden. Der Hook soll nicht automatisch rebuilden; er setzt nur Stale-Status und empfiehlt `/index --refresh`.

## Stack Coverage

- **Profiles affected**: all
- **Per-stack difference**:
  - Shopify: Liquid-Dateien stale setzen `liquid-graph.json`
  - JS/TS/Vue: Source/config changes stale setzen `graph.json`
  - All: stack/config changes stale setzen context files

## Steps

- [x] Step 1: `templates/scripts/context-freshness-prep.sh` oder Erweiterung in `index-prep.sh` — Hash/mtime-Vergleich gegen Manifest implementieren
- [x] Step 2: `templates/claude/hooks/context-freshness.sh` — Manifest lesen, Source-Änderungen erkennen und `stale:true` für betroffene Artefakte setzen
- [x] Step 3: `templates/claude/hooks/context-freshness.sh` — SessionStart/UserPromptSubmit Output: maximal eine Zeile `[CONTEXT STALE] run /index --refresh` mit betroffenen Artefakten
- [x] Step 4: `templates/claude/settings.json` — Hook auf SessionStart registrieren; bestehende UserPromptSubmit-Nutzung prüfen und Tokenbudget klein halten
- [x] Step 5: `templates/scripts/doctor.sh` — Warnung wenn Manifest fehlt, unlesbar ist oder stale Artefakte enthält
- [x] Step 6: `.claude/` Mirrors via `bin/sync-local.sh`
- [x] Step 7: Tests/Smoke: Manifest mit geändertem `package.json` und geändertem `.liquid` simulieren
- [x] Step 8: SessionStart-Hook erweitern (aus obra/superpowers): zusätzlich zur Stale-Warning eine Skill-Routing-Map (7 Default-Skills + Trigger-Conditions) als knapper `additionalContext`-Block injizieren — max 300 Token gesamt
- [x] Step 9: Semantische Drift-Heuristik: zusätzlich zu Hash-Vergleich Source-File-Count-Delta tracken (`% files changed since last index`); ab >20% Delta `stale:true` für `graph.json`

## Acceptance Criteria

- [x] Änderung an `package.json` setzt `artifacts.graph.json.stale=true` oder Context-Stale im Manifest
- [x] Änderung an `snippets/*.liquid` setzt `artifacts["liquid-graph.json"].stale=true` bei Shopify-Profil
- [x] Hook-Ausgabe (Stale + Skill-Map zusammen) bleibt unter 300 Token
- [x] Skill-Routing-Map enthält die 7 Default-Skills mit 1-Line-Trigger
- [x] Source-File-Count-Delta >20% setzt `graph.json` stale
- [x] Hook baut keine Artefakte automatisch
- [x] SessionStart-Hinweis nennt `/index --refresh`
- [x] `doctor.sh` warnt bei stale Manifest
- [x] `bash .claude/scripts/quality-gate.sh` grün

## Files to Modify

> Nur `templates/` editieren. `.claude/` Mirrors via `bash bin/sync-local.sh` aus Spec 654.

- `templates/claude/hooks/context-freshness.sh` - Manifest-Stale-Logik
- `templates/claude/settings.json` - SessionStart-Hook
- `templates/scripts/doctor.sh` - Health-Check
- `templates/scripts/index-prep.sh` - Manifest-Helfer, falls aus Spec 655 vorhanden
- `bash bin/sync-local.sh` nach Template-Edits

## Out of Scope

- Automatischer Rebuild
- Komplexe File-Watcher
- Vollständige Source-Graph-Diffing-Engine
