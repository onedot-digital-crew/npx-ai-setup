# Spec: Boilerplate-Sync bei ai-setup Update

> **Spec ID**: 594 | **Created**: 2026-03-27 | **Status**: completed | **Complexity**: medium | **Branch**: main

## Goal
Boilerplate-Skills/Agents/Rules werden bei `ai-setup update` automatisch re-synced, nicht nur bei Erstinstallation.

## Context
`pull_boilerplate_files()` läuft nur bei Erstinstallation via `select_boilerplate_system`. Bei Updates werden nur ai-setup Templates gesynced. Boilerplate-Änderungen erreichen existierende Projekte nie.

`select_boilerplate_system()` setzt `SELECTED_SYSTEM` und pullt Boilerplate, aber `has_system_config()` (Zeile 203) returnt sofort wenn Rules vorhanden — bei Updates wird der Sync nie erreicht.

### Verified Assumptions
- `select_boilerplate_system` setzt `SELECTED_SYSTEM` + pullt via `pull_boilerplate_files` — Evidence: `lib/boilerplate.sh:199-230` | Confidence: High
- `has_system_config()` blockt Re-Sync bei Updates (returniert 0 wenn Rules existieren) — Evidence: `lib/boilerplate.sh:185-194` | Confidence: High
- `.ai-setup.json` hat kein `system` Feld — Evidence: `lib/core.sh` | Confidence: High
- `run_smart_update()` ruft nie Boilerplate-Code auf — Evidence: `lib/update.sh` | Confidence: High
- `_gh_available()` prüft gh CLI Verfügbarkeit — Evidence: `lib/boilerplate.sh` | Confidence: High

## Steps
- [x] Step 1: `detect_installed_system()` in `lib/boilerplate.sh` — System aus `.ai-setup.json` `.system` lesen, Fallback: Rule-Files Pattern-Match (`shopify*.md` → shopify). Returniert System-String oder leer.
- [x] Step 2: `sync_boilerplate()` in `lib/boilerplate.sh` — liest System via `detect_installed_system()`, prüft `_gh_available` (graceful skip + Info-Meldung wenn nicht verfügbar), ruft `pull_boilerplate_files()` auf. Kein `has_system_config()` Guard — bei Updates muss Sync immer laufen.
- [x] Step 3: `run_smart_update()` in `lib/update.sh` — `sync_boilerplate` nach Template-Sync aufrufen
- [x] Step 4: `write_metadata()` in `lib/core.sh` — `system` Feld in `.ai-setup.json` schreiben. `bin/ai-setup.sh` übergibt `SELECTED_SYSTEM` nach `select_boilerplate_system`.

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
- `lib/boilerplate.sh` — detect_installed_system(), sync_boilerplate()
- `lib/update.sh` — run_smart_update() Boilerplate-Sync
- `lib/core.sh` — write_metadata() system Feld
- `bin/ai-setup.sh` — SELECTED_SYSTEM an write_metadata übergeben

## Out of Scope
- Manueller `--sync-boilerplate` Flag
- Multi-System Support (ein Projekt = ein Boilerplate)
- Boilerplate-Versioning (immer latest aus dem Repo)
