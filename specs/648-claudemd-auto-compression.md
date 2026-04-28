# Spec: CLAUDE.md Auto-Compression Skill

> **Spec ID**: 648 | **Created**: 2026-04-13 | **Status**: draft | **Complexity**: medium | **Branch**: —
> **Related**: 632 (Output-Token Compression), 631 (Research Caveman)

## Goal

Skill der CLAUDE.md und andere Memory-Files automatisch komprimiert (~46% weniger Input-Tokens pro Session), mit Validation und Backup.

## Context

Research 631 zeigt: Cavemans `caveman-compress` nutzt Python + Claude API um Prose in Memory-Files zu komprimieren. Code-Blocks, URLs, Headings, File-Paths bleiben exakt erhalten. Backup als `.original.md`. Validation mit Retry. Unser `token-optimizer` analysiert Token-Usage, komprimiert aber nichts. Dieses Feature ist das fehlende Execute-Stück. Reimplementierung in Shell/Claude-CLI statt Python, passend zu unserem Bash-Stack.

## Steps

- [ ] Step 1: `templates/skills/compress/SKILL.md` erstellen — Skill-Definition mit Trigger, Process, Compression-Rules, Boundaries
- [ ] Step 2: `templates/scripts/compress.sh` erstellen — Shell-Script: detect filetype, backup, compress via `claude -p`, validate, retry (max 2)
- [ ] Step 3: Validation-Logik in compress.sh — Headings-Count, Code-Block-Preservation (diff fenced blocks), URL-Preservation, Path-Preservation
- [ ] Step 4: `lib/setup-skills.sh` — compress Skill in Skill-Installation aufnehmen
- [ ] Step 5: Integration-Test — verify Skill + Script werden korrekt deployed
- [ ] Step 6: Manueller Test — `/compress CLAUDE.md` komprimiert, `.original.md` Backup existiert, Validation passed

## Acceptance Criteria

- [ ] "Nach `npx ai-setup` existiert `.claude/skills/compress/SKILL.md` im Ziel-Projekt"
- [ ] "Nach `npx ai-setup` existiert `.claude/scripts/compress.sh` im Ziel-Projekt"
- [ ] "`/compress <file.md>` erstellt komprimierte Version + `.original.md` Backup"
- [ ] "Code-Blocks in komprimierter Version sind byte-identisch mit Original"
- [ ] "Alle URLs aus Original sind in komprimierter Version vorhanden"
- [ ] "Alle Headings (Level + Text) sind in komprimierter Version identisch"
- [ ] "Bei Validation-Fehler: targeted retry (max 2), kein Full-Recompress"
- [ ] "Nicht-Markdown-Dateien (.py, .js, .json etc.) werden abgelehnt"
- [ ] "`bash tests/integration.sh` passed"

## Files to Modify

- `templates/skills/compress/SKILL.md` — NEU: Compress-Skill Definition
- `templates/scripts/compress.sh` — NEU: Shell-basierter Kompressor mit Validation
- `lib/setup-skills.sh` — Compress Skill registrieren
- `tests/integration.sh` — Tests für Compress-Deployment

## Out of Scope

- Python-basierte Kompression (Cavemans Ansatz) — wir nutzen Shell + `claude -p`
- Benchmark-Harness — eigenes Feature (Eval Harness, Backlog)
- Bulk-Compression (alle .md Files auf einmal) — V2
- Auto-Recompression nach Edits — zu magisch, User soll bewusst auslösen
