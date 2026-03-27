# Spec: Boilerplate-Sync bei ai-setup Update

> **Spec ID**: 594 | **Created**: 2026-03-27 | **Status**: draft | **Complexity**: medium | **Branch**: —

## Goal
Boilerplate-Skills/Agents/Rules werden bei `ai-setup update` automatisch re-synced, nicht nur bei Erstinstallation.

## Context
`pull_boilerplate_files()` läuft nur bei Erstinstallation via `select_boilerplate_system`. Bei Updates werden nur ai-setup Templates gesynced. Boilerplate-Änderungen erreichen existierende Projekte nie.

`select_boilerplate_system()` setzt bereits `SELECTED_SYSTEM`, aber der Wert wird nicht persistiert. Bei Updates ist unklar welches Boilerplate-System aktiv ist.

### Verified Assumptions
- `select_boilerplate_system` setzt `SELECTED_SYSTEM` bereits — Evidence: `lib/boilerplate.sh:179` | Confidence: High
- `.ai-setup.json` hat kein `system` Feld — Evidence: `lib/core.sh:123` | Confidence: High
- `has_system_config()` prüft ob System-Rules existieren — Evidence: `lib/boilerplate.sh:164` | Confidence: High
- `run_smart_update()` ruft nie Boilerplate-Code auf — Evidence: `lib/update.sh` | Confidence: High

## Steps
- [ ] Step 1: `write_metadata()` in `lib/core.sh` — `system` Feld aus `SELECTED_SYSTEM` in `.ai-setup.json` schreiben
- [ ] Step 2: `detect_installed_system()` in `lib/boilerplate.sh` — System aus `.ai-setup.json` lesen, Fallback: aus vorhandenen Rule-Files erkennen (`shopify*.md` → shopify etc.)
- [ ] Step 3: `sync_boilerplate()` in `lib/boilerplate.sh` — liest System via `detect_installed_system()`, prüft `_gh_available`, ruft `pull_boilerplate_files()` auf. Graceful skip wenn gh nicht verfügbar.
- [ ] Step 4: `run_smart_update()` in `lib/update.sh` — `sync_boilerplate` nach Template-Sync aufrufen
- [ ] Step 5: `bin/ai-setup.sh` — `SELECTED_SYSTEM` nach `select_boilerplate_system` an `write_metadata` übergeben

## Acceptance Criteria

### Truths
- [ ] `jq .system .ai-setup.json` gibt das System zurück nach Neuinstallation
- [ ] `ai-setup update` auf einem Nuxt-Projekt re-pulled Boilerplate-Skills
- [ ] Bestehende Projekte ohne `system` Feld: System wird aus Rules erkannt
- [ ] Ohne gh CLI: Sync skippt mit Info-Meldung, kein Fehler

### Artifacts
- [ ] `lib/boilerplate.sh` — `sync_boilerplate()` + `detect_installed_system()`
- [ ] `lib/core.sh` — `system` Feld in Metadata

### Key Links
- [ ] `lib/update.sh:run_smart_update` → `lib/boilerplate.sh:sync_boilerplate`
- [ ] `lib/boilerplate.sh:sync_boilerplate` → `lib/boilerplate.sh:pull_boilerplate_files`

## Files to Modify
- `lib/core.sh` — write_metadata() system Feld
- `lib/boilerplate.sh` — detect_installed_system(), sync_boilerplate()
- `lib/update.sh` — run_smart_update() Boilerplate-Sync
- `bin/ai-setup.sh` — SELECTED_SYSTEM Persistierung

## Out of Scope
- Manueller `--sync-boilerplate` Flag
- Multi-System Support (ein Projekt = ein Boilerplate)
- Boilerplate-Versioning (immer latest aus dem Repo)
