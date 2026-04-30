# Spec: Content-Hash Pull Tracking — Stop Format-Drift Diffs

> **Spec ID**: 653 | **Created**: 2026-04-30 | **Status**: completed | **Complexity**: medium | **Branch**: spec/653-content-hash-pull

## Goal

Boilerplate-Pull schreibt Remote-Content-Hash ins Manifest und unterdrückt nachfolgende Format-Drift-Diffs.
Echte Upstream-Änderungen schlagen durch, lokale Whitespace/Prettier-Reformatierungen werden ignoriert.

## Context

Symptom: Bei `npx ai-setup` mit `--pull-boilerplate` zeigen `.claude/skills/**/*.md`-Files immer wieder Diffs,
obwohl der Remote-Inhalt unverändert ist. Diff-Beispiel zeigt nur eingefügte Leerzeilen + Line-Wrapping —
identischer Content, anderes Format.

Root Cause:
- `post-edit-lint.sh` läuft Prettier auf jedes geänderte `.md`
- Boilerplate-Repo hat anderen Prettier-Config als Zielprojekt (printWidth, prose-wrap)
- Bei Pull: Remote-File mit Format-A geschrieben → Hook re-formatiert mit Format-B → Local-Drift
- Bei nächstem Pull: Remote-File ist wieder Format-A → erneuter "Update"

Aktuell: `_gh_fetch_file` vergleicht Remote-SHA mit lokalem File-Hash. Lokaler Format-Drift macht jeden
Pull zu einem "Update", obwohl semantisch nichts neu ist.

Manifest `.ai-setup.json` hat bereits Feld-Format `"checksum size"` pro File — aber gefüllt mit lokalem
Hash, nicht Remote-Hash. Genau das ist die Lücke.

## Stack Coverage

- **Profiles affected**: all (jeder Boilerplate-Pull über alle Stacks)
- **Per-stack difference**: none — Hash-Logik ist content-agnostic

## Steps

- [x] Step 1: `lib/json.sh` — neue Helper: `_json_set_boilerplate_file()`, `_json_get_boilerplate_remote_sha()` für separate `.boilerplate_files` Sektion
- [x] Step 2: `lib/boilerplate.sh` — `_gh_get_remote_sha()` neue Funktion: fetcht nur SHA via `gh api repos/X/contents/Y --jq '.sha'` (1 Call, kein Content-Download)
- [x] Step 3: `lib/boilerplate.sh` — `_should_fetch_boilerplate()` neue Funktion: vergleicht Remote-SHA mit `.boilerplate_files["path"].remote_sha` aus Manifest. Match = skip, kein Match oder fehlend = pull
- [x] Step 4: `lib/boilerplate.sh` — `pull_boilerplate_files()` integrieren: Pre-Check via `_should_fetch_boilerplate`, nach erfolgreichem Pull Remote-SHA via `_json_set_boilerplate_file` ins Manifest persistieren. `unchanged_count` zählen
- [x] Step 5: `lib/boilerplate.sh` — Pull-Output erweitern: "✓ N pulled, M unchanged (cache-hit), K failed"
- [x] Step 6: Test mit Test-Manifest: zweiter Pull direkt nach erstem → alle "unchanged" via cache
- [x] Step 7: Test mit echtem Upstream-Update: lokale `.boilerplate_files`-Eintrag manuell auf falsche SHA setzen → Pull erkennt Mismatch, holt File, updated SHA
- [x] Step 8: `bash -n lib/boilerplate.sh` und `lib/json.sh` clean
- [x] Step 9: `README.md` Boilerplate-Sektion: kurz `.boilerplate_files`-Tracking erklären

**Design-Update**: Statt `.files` zu refactorieren (großer Blast-Radius, Migration für hunderte Template-Files), neue separate `.boilerplate_files` Sektion. `.files` bleibt für Template-Tracking unverändert. Saubere Trennung, keine 2.4.0-Migration nötig — Bestands-Projekte schreiben `.boilerplate_files` lazy beim nächsten Pull.

## Acceptance Criteria

- [ ] Zweiter Pull direkt nach erstem zeigt 0 echte Updates (alle "unchanged")
- [ ] Echte Upstream-Änderung (1 File im Boilerplate-Repo modifiziert) wird vom nächsten Pull erkannt
- [ ] Lokaler Format-Drift (Prettier auf gepulltes File) löst KEIN "Update" beim nächsten Pull aus
- [ ] `.ai-setup.json` hat neues Schema mit `remote_sha` pro gepulltem File
- [ ] Bestands-Projekte (alte `.ai-setup.json`-Schema) werden bei erstem 2.4.0-Run migriert ohne Datenverlust
- [ ] `bash -n lib/boilerplate.sh` clean, keine Syntax-Errors

## Files to Modify

- `lib/json.sh` — neue Helper für `.boilerplate_files`
- `lib/boilerplate.sh` — Hash-Tracking-Logik (Steps 2-5)
- `README.md` — Doku Step 9 (kurz)

Keine Migration nötig durch separates `.boilerplate_files`-Feld. Kein Version-Bump zwingend.

## Out of Scope

- Prettier-Config-Sync zwischen Boilerplate-Repos und Zielprojekten (separates Problem, nicht-blockierend wenn Hash-Tracking funktioniert)
- `.editorconfig`-Templating (würde 80% der Drifts auch lösen, aber zu invasiv für Zielprojekte mit eigenen Conventions)
- Force-Re-Pull-Flag (`--force-pull`): wenn jemand wirklich neu pullen will, kann er Manifest-Eintrag manuell löschen
- Hash-Tracking für non-boilerplate Files (Templates aus npx-ai-setup selbst): bereits idempotent, nicht betroffen

## Risks

- **R1**: GitHub-API-Rate-Limit bei vielen Files (60/h unauthenticated, 5000/h mit Token) → Mitigation: nur SHA-Check via `gh api repos/:repo/contents/:path` ist 1 Call pro File, bei 20 Files = 20 Calls, weit unter Limit. Bei großen Pulls Batch-Endpoint nutzen.
- **R2**: Manifest-Schema-Migration bricht bestehende Projekte → Mitigation: Migration 2.4.0 detektiert altes Schema (String statt Object) und konvertiert defensiv. Default-Werte für fehlende Felder.
- **R3**: User editiert lokal eine gepullte Datei mit echtem Inhalt-Change, will Boilerplate-Update später nicht überschrieben bekommen → bestehende `_should_update_file`-Logik bleibt aktiv (3-way-merge), Hash-Check nur als Pre-Filter.
- **R4**: `gh api` nicht verfügbar (kein gh CLI installiert) → Fallback: bestehende Logik (immer Pull, Format-Drift bleibt). Hint anzeigen.

## Validation

Nach Implementation:
1. Frischer Pull in Test-Projekt → Manifest zeigt Object-Schema mit `remote_sha`
2. `npx ai-setup --pull-boilerplate` zweimal hintereinander → zweiter Pull "0 file(s) pulled, N unchanged"
3. Boilerplate-Repo: 1 File ändern, push → Zielprojekt-Pull erkennt Update korrekt
4. Bestandsprojekt nuxt-onedot mit altem Manifest → Migration läuft, Format-Drift verschwindet bei nächstem Pull
