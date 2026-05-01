# Spec: cleanup — tote stack-context scripts + scan-prep entfernen

> **Spec ID**: 638 | **Created**: 2026-05-01 | **Status**: completed | **Complexity**: small | **Branch**: —

## Goal

Entferne 6 ungenutzte Bash-Scripts und ihre Doc-Referenzen aus `templates/scripts/` + `.claude/scripts/`. Sie produzieren Outputs die niemand liest, blähen das Setup auf und verwirren beim Audit.

## Context

Audit (2026-05-01) hat ergeben:

- `templates/scripts/context-{laravel,nuxt,shopify,shopware,storyblok}.sh` — 5 Stack-Scanner, in Spec 596 eingeführt. Generieren `NUXT.md`/`SHOPIFY.md`/etc. in Target-Projekten. **Null Konsumenten**: kein Skill, kein Hook, keine CLAUDE.md liest die Outputs. `lib/setup.sh` und `lib/update.sh` rufen sie nicht auf.
- `templates/scripts/scan-prep.sh` — `npm audit`-Wrapper. Nur in `templates/claude/docs/token-optimization.md` als Beispiel erwähnt, kein Skill ruft auf, kein Hook.

`docs-audit.sh` bleibt — wird von `release.sh` benutzt.

Resultat: ~6 KB toten Bash-Code löschen, Setup wird ehrlicher.

## Stack Coverage

- **Profiles affected**: alle (cleanup ist generic)
- **Per-stack difference**: keine

## Steps

- [x] Step 1: Löschen `templates/scripts/context-{laravel,nuxt,shopify,shopware,storyblok}.sh` (5 Files)
- [x] Step 2: Löschen `templates/scripts/scan-prep.sh`
- [x] Step 3: Löschen Mirrors in `.claude/scripts/` (gleiche 6 Files)
- [x] Step 4: `templates/claude/docs/token-optimization.md` Zeile 12 — `scan-prep.sh` Zeile aus Tabelle entfernen
- [x] Step 5: `.claude/docs/token-optimization.md` mirror
- [x] Step 6: `lib/setup.sh` + `lib/update.sh` — prüfen ob diese Scripts in der Boilerplate-Whitelist (`.boilerplate_files`) stehen, falls ja entfernen damit Update-Lauf sie nicht wieder anlegt
- [x] Step 7: Smoke: `bash bin/ai-setup.sh --audit` in einem Test-Repo, verify dass keine Referenz auf gelöschte Files ist

## Acceptance Criteria

- [x] `find templates/scripts .claude/scripts -name "context-*.sh" -o -name "scan-prep.sh"` returns nothing
- [x] `grep -rn "scan-prep\|context-laravel\|context-nuxt\|context-shopify\|context-shopware\|context-storyblok" .claude/ templates/ lib/ bin/` returns nothing (excluding specs/completed)
- [x] Audit-Run auf einem nuxt-Projekt zeigt keine Hinweise auf fehlende Scripts
- [x] Update-Lauf re-installiert die gelöschten Files NICHT

Note: `bin/ai-setup.sh --audit` is currently an intentionally unsupported flag; verification used the current rejection path plus reference/manifest checks, with no deleted-script hints or reinstall sources remaining.

## Files to Modify

- `templates/scripts/context-laravel.sh` — DELETE
- `templates/scripts/context-nuxt.sh` — DELETE
- `templates/scripts/context-shopify.sh` — DELETE
- `templates/scripts/context-shopware.sh` — DELETE
- `templates/scripts/context-storyblok.sh` — DELETE
- `templates/scripts/scan-prep.sh` — DELETE
- `.claude/scripts/context-laravel.sh` — DELETE
- `.claude/scripts/context-nuxt.sh` — DELETE
- `.claude/scripts/context-shopify.sh` — DELETE
- `.claude/scripts/context-shopware.sh` — DELETE
- `.claude/scripts/context-storyblok.sh` — DELETE
- `.claude/scripts/scan-prep.sh` — DELETE
- `templates/claude/docs/token-optimization.md` — Tabellen-Zeile entfernen
- `.claude/docs/token-optimization.md` — mirror
- `lib/setup.sh` / `lib/update.sh` — boilerplate metadata cleanup wenn nötig

## Out of Scope

- `docs-audit.sh` löschen (wird von release.sh benutzt — behalten)
- `spec-work-all/` skill löschen (Funktion existiert, nur untererwähnt — siehe spec 639)
- Neue Stack-Scanner schreiben (kompletter Ersatz wäre eigene Spec)
