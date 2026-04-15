# Spec: SUMMARY.md Auto-Import statt Context-Loader Hook

> **Spec ID**: 636 | **Created**: 2026-04-15 | **Status**: completed | **Complexity**: medium | **Branch**: —

## Goal
Projekt-Kontext via committeter `SUMMARY.md` (@-Import in CLAUDE.md) laden (AUDIT Critical/High + ARCH-Abstracts + Graph Top-Hubs), `context-loader.sh` Hook ersetzen, `context-freshness.sh` erst ab 5 Commits warnen.

## Context
SessionStart-Hook injiziert heute ~400 Tokens additionalContext (dynamic, nicht im Prompt-Cache). Eine committete `.agents/context/SUMMARY.md` via `@`-Import landet im statischen CLAUDE.md-Layer, wird gecached, ist im Git-Log sichtbar und funktioniert auch unter `--bare`. `/context-refresh` generiert SUMMARY.md deterministisch aus AUDIT.md + ARCHITECTURE.md + graph.json (Top-Hubs), max 50 Zeilen. Graph-Hubs liefern Navigation-Context für große Codebases.

### Verified Assumptions
- `context-loader.sh` lädt STACK/ARCH/CONV by-name, AUDIT via glob-catch-all (nicht by-name) — Evidence: `.claude/hooks/context-loader.sh:78-84` | Confidence: High | If Wrong: Hook entfernt trotzdem, SUMMARY.md Generator liest AUDIT-Frontmatter direkt.
- AUDIT.md/ARCH.md haben YAML-Frontmatter (`abstract`, `sections`) — Evidence: `.agents/context/AUDIT.md:1-20` | Confidence: High | If Wrong: Generator liest Plain-Headings als Fallback.
- `@file`-Import in CLAUDE.md funktioniert bis 5 Ebenen tief — Evidence: Context7 docs (Claude Code memory) | Confidence: High | If Wrong: Fallback auf Plain-Read via SessionStart-Hook.
- `/context-refresh` schreibt bereits `.state` reliably — Evidence: `.claude/skills/context-refresh/SKILL.md:22-29` | Confidence: High | If Wrong: SUMMARY-Generation hängt an gleichem Punkt.
- `graph.json.stats.top_hubs` ist Array von `{file, imported_by}` (falls vorhanden) — Evidence: `.agents/context/graph.json` Schema | Confidence: Medium | If Wrong: Generator skippt Hubs-Section graceful, kein Fehler.

## Steps
- [x] Step 1: Generator-Script `.claude/scripts/build-summary.sh` schreiben — liest AUDIT/ARCH Frontmatter + prüft CONCEPT.md (falls vorhanden, als L0-Abstract einbauen) + graph.json.stats.top_hubs (falls vorhanden), baut `.agents/context/SUMMARY.md` (max 50 Zeilen: Critical/High Findings + Key Decisions + Top Hubs, Marker `<!-- GENERATED -->`)
- [x] Step 2: Mirror nach `templates/claude/scripts/build-summary.sh`
- [x] Step 3: `context-refresh` Skill erweitern — ruft `build-summary.sh` vor `.state` Write, aktualisiert Doku, Mirror in `templates/skills/context-refresh/SKILL.template.md`
- [x] Step 4: `CLAUDE.md` + `templates/CLAUDE.md` ergänzen: `@.agents/context/SUMMARY.md` unter "Project Context"-Section
- [x] Step 5: `context-loader.sh` entfernen aus `.claude/settings.json` SessionStart-Hooks, Script-Datei aus `.claude/hooks/` + `templates/`, READMEs updaten
- [x] Step 6: `context-freshness.sh` Line 33-36: Hash-Gleichheit ersetzen durch `git rev-list --count $STORED_GIT..HEAD` (Threshold ≥5), Mirror in `templates/claude/hooks/`
- [x] Step 7: `/context-refresh` lokal laufen, SUMMARY.md committen, Graph-Hubs verifizieren, SessionStart-Test, `tests/claude-runtime.sh` verifizieren

## Acceptance Criteria
- [x] `cat .agents/context/SUMMARY.md | wc -l` ≤ 50
- [x] `grep '@.agents/context/SUMMARY.md' CLAUDE.md` matcht
- [x] `grep -q 'Top Hubs:' .agents/context/SUMMARY.md` matcht wenn graph.json top_hubs vorhanden (graceful skip wenn leer)
- [x] `ls .claude/hooks/context-loader.sh` schlägt fehl (entfernt)
- [x] 1 Commit nach `/context-refresh` → `bash .claude/hooks/context-freshness.sh` gibt keine Warnung
- [x] 5 Commits → Warnung erscheint mit Commit-Count

## Files to Modify
- `.claude/scripts/build-summary.sh` (new) + `templates/.claude/scripts/build-summary.sh` — Generator-Logik
- `.claude/skills/context-refresh/SKILL.md` + `templates/skills/context-refresh/SKILL.template.md` — Generator-Aufruf, stale Doku-Referenzen entfernen
- `CLAUDE.md` + `templates/CLAUDE.md` — `@`-Import-Zeile
- `.claude/settings.json` + `templates/claude/settings.json` — SessionStart-Hook entfernen
- `.claude/hooks/context-loader.sh` + `templates/claude/hooks/context-loader.sh` — löschen
- `.claude/hooks/README.md` + `templates/claude/hooks/README.md` — context-loader.sh Referenzen entfernen
- `.claude/hooks/context-freshness.sh` + `templates/claude/hooks/context-freshness.sh` — Commit-Counter-Fix
- `tests/claude-runtime.sh` — Assertions für context-freshness.sh verifizieren

## Out of Scope
- Kuratierte Inhalte in SUMMARY.md (nur automatische Extraktion aus Quellen)
- Migration bestehender Projekte ohne `.agents/context/` Struktur
- Automatische Refresh-Trigger bei Graph-Änderung (Graph-Staleness ist kein Trigger; nur Commit-Count in context-freshness.sh)
- context-refresh Skill-Dokumentation in anderen Repos
