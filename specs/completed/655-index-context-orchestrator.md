# Spec: `/index` — zentraler Context- und Graph-Orchestrator

> **Spec ID**: 655 | **Created**: 2026-05-01 | **Status**: completed | **Complexity**: high | **Branch**: —

<!-- depends_on: [654] -->

## Goal

Führe einen zentralen `/index` Skill ein, der bestehende Projekte stack-aware indexiert und alle wiederverwendbaren Context-/Graph-Artefakte konsistent baut oder aktualisiert.

## Context

Das Produktziel ist: bestehendes Projekt einmal verstehen, Kontext speichern, danach jede Claude-Session mit wenig Tokens und hoher Qualität führen. Aktuell verteilen sich diese Aufgaben über `/analyze`, `build-graph.sh`, Liquid-Graph-Docs, optional `/graphify` und Context-Scanner. `/index` soll der sichtbare Einstieg für Projektwissen werden; Graphify bleibt als Expert-Modul, wird aber von `/index` orchestriert, wenn installiert/aktiviert.

Manifest-Format wird hier festgelegt:

```json
{
  "version": 1,
  "stack": "shopify-liquid",
  "generated_at": "2026-05-01T00:00:00Z",
  "sources": {
    "package.json": {"hash": "...", "mtime": 0},
    "composer.json": {"hash": "...", "mtime": 0}
  },
  "artifacts": {
    "graph.json": {"built_at": "2026-05-01T00:00:00Z", "stale": false},
    "liquid-graph.json": {"built_at": "2026-05-01T00:00:00Z", "stale": false},
    "graphify-out/graph.json": {"built_at": "2026-05-01T00:00:00Z", "stale": false}
  }
}
```

## Stack Coverage

- **Profiles affected**: all
- **Per-stack difference**:
  - `shopify-liquid`: build `.agents/context/liquid-graph.json`
  - `nuxt-storyblok`, `nuxtjs`, `nextjs`: build `.agents/context/graph.json` and capture auto-import hints
  - `laravel`, `shopware`: context files + optional future graph hooks; no fake JS graph
  - all large repos: optional Graphify module if installed/enabled

## Steps

- [x] Step 1: `templates/skills/index/SKILL.template.md` — neuen Skill erstellen: `/index [--refresh] [--graphify] [--no-graphify]`
- [x] Step 2: `.claude/skills/index/SKILL.md` — Mirror via `bin/sync-local.sh`
- [x] Step 3: `templates/scripts/index-prep.sh` — neues Prep-Script: stack detect, source hash/mtime sammeln, vorhandene Artefakte prüfen, Manifest lesen/schreiben
- [x] Step 4: `templates/scripts/index-prep.sh` — `.agents/context/index-manifest.json` im oben definierten Format schreiben
- [x] Step 5: `templates/scripts/index-prep.sh` — `build-graph.sh` für JS/TS/Vue-Projekte ausführen; Graph-Ausgabe in Manifest unter `artifacts.graph.json`
- [x] Step 6: `templates/scripts/liquid-graph-refresh.sh` — falls noch nicht template-managed, aus lokaler Kopie übernehmen; `/index` ruft es bei `shopify-liquid`
- [x] Step 7: `/index` — optional Graphify: wenn Binary verfügbar und Flag/Profil erlaubt, `graphify build .` ausführen und `graphify-out/graph.json` im Manifest erfassen
- [x] Step 8: `/analyze` — auf `/index` verweisen: Analyse nutzt bestehende Artefakte und wird nicht mehr als primärer Indexer beschrieben
- [x] Step 9: `templates/claude/rules/workflow.md` + README — Routing: "Projekt frisch installiert / Context stale / große Änderung" → `/index`
- [x] Step 10: Doctor-Check ergänzen: Manifest vorhanden, Stack gesetzt, Artefakte existieren oder bewusst skipped

## Acceptance Criteria

- [x] `/index --refresh` baut `.agents/context/index-manifest.json`
- [x] Manifest enthält `version`, `stack`, `generated_at`, `sources`, `artifacts`
- [x] In einem JS/Vue-Projekt wird `.agents/context/graph.json` gebaut und im Manifest als `stale:false` geführt
- [x] In einem Shopify-Projekt wird `.agents/context/liquid-graph.json` gebaut und im Manifest als `stale:false` geführt
- [x] Wenn Graphify fehlt, warnt `/index` nur und fährt fort
- [x] `/graphify` Skill bleibt verfügbar und wird nicht gelöscht
- [x] `bash .claude/scripts/quality-gate.sh` grün

## Files to Modify

> Nur `templates/` editieren. `.claude/` Mirrors entstehen via `bash bin/sync-local.sh` aus Spec 654.

- `templates/skills/index/SKILL.template.md` - neuer Orchestrator-Skill
- `templates/scripts/index-prep.sh` - neuer Index-Prep
- `templates/scripts/liquid-graph-refresh.sh` - template-managed machen
- `templates/skills/analyze/SKILL.template.md` - Rolle von Analyze schärfen
- `templates/scripts/doctor.sh` - Manifest-Health
- `README.md`, `WORKFLOW-GUIDE.md`, `templates/claude/rules/workflow.md` - Routing/Doku
- `bash bin/sync-local.sh` nach allen Template-Edits ausführen

## Out of Scope

- Graphify-Binary automatisch installieren
- Neue Graph-Builder für PHP/Shopware schreiben
- Automatischer Rebuild bei Hook-Trigger
- `/graphify` Skill löschen
