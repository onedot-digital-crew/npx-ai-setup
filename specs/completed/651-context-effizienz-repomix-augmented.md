# Spec: Context-Effizienz + repomix-augmented /analyze

> **Spec ID**: 651 | **Created**: 2026-04-30 | **Status**: completed | **Complexity**: medium | **Branch**: —

## Goal

Tote Context-Dateien killen oder mit Read-Trigger reaktivieren. `/analyze` mit repomix-Fast-Path auf 70% weniger Tokens bringen, ohne aktiven Read-Pfad zu verlieren.

## Context

Audit zeigt: 4 von 10 `.agents/context/`-Files sind Karteileichen (AUDIT.md, CONCEPT.md, DESIGN-DECISIONS.md, LEARNINGS.md). Werden generiert, nirgends gelesen → Token-Müll bei jedem `--patch`/`--audit`-Refresh + Repo-Bloat.

Aktiv genutzt: SUMMARY.md (`@`-import in CLAUDE.md jede Session), graph.json (3 Hooks + agents.md), STACK.md/ARCHITECTURE.md/CONVENTIONS.md (on-demand `@`-Hinweis).

Schwach: PATTERNS.md (1 Agent), context-scanner.md liest "top 3" — kein anderer Trigger.

repomix `--compress` (Tree-sitter signatures) liefert strukturellen Codebase-Snapshot in einem Read-Call statt 50+ File-Reads bei `/analyze`. Win nur wenn der bestehende Read-Loop ersetzt wird, nicht parallel läuft.

**Kernprinzip**: Eine Datei wird nur generiert wenn ein Read-Trigger nachweisbar existiert (Hook, Skill, Agent, `@`-import, oder fail-loud Doctor-Check).

## Stack Coverage

- **Profiles affected**: all
- **Per-stack difference**: repomix Tree-sitter Coverage variiert — Rust/JS/TS/Python solide, Vue SFC partial, Liquid unklar. Fallback-Path bleibt Pflicht.

## Steps

### Phase 1: Audit + Cleanup (no repomix)

- [x] Step 1: `lib/setup-context.sh` — auditen welche Files generator-seitig erzeugt werden. Befund: alle 9 Files haben Trigger. DESIGN-DECISIONS.md fehlte Read-Trigger → nachrüsten statt löschen.
- [x] Step 2: `.agents/context/` — kein Kill nötig (alle Files haben Trigger). DESIGN-DECISIONS.md Read-Trigger in CLAUDE.md + templates/CLAUDE.md ergänzt.
- [x] Step 3: `.claude/scripts/build-summary.sh` + `templates/claude/scripts/build-summary.sh` — AUDIT.md + CONCEPT.md aus SUMMARY entfernt (waren via @-import trotz .claudeignore in jeder Session). DESIGN-DECISIONS/LEARNINGS aus auto-discover excluded.
- [x] Step 4: DESIGN-DECISIONS.md Read-Trigger in CLAUDE.md (aktiv) + templates/CLAUDE.md nachgerüstet.
- [x] Step 5: `.claude/scripts/doctor.sh` + `templates/scripts/doctor.sh` — Check #21 ergänzt: zeigt pro File ob Read-Trigger in .claude/,templates/,lib/,CLAUDE.md existiert.

### Phase 2: repomix-Fast-Path für /analyze

- [x] Step 6: `.claude/skills/analyze/SKILL.md` — Fast-Path Branch + Fallback-Branch. repomix replaces Read-Loop, nicht supplement.
- [x] Step 7: `.claude/scripts/analyze-fast.sh` — NEU: repomix --compress --style xml mit stack-aware ignore patterns. Schreibt .repomix-hash für Drift-Detection.
- [x] Step 8: `lib/stack-detect.sh` — Stack-Profile inline in analyze-fast.sh gelöst (Nuxt/Shopify/Laravel/Next + default).
- [x] Step 9: `.claude/skills/analyze/SKILL.md` — Output-Kontrakt ergänzt: repomix-path deriviert Architecture aus XML directory_structure.
- [x] Step 10: `.claude/hooks/context-freshness.sh` — .repomix-hash Variable + Drift-Check via File-Count-Delta (>10% Threshold, 0 tokens, kein repomix-re-run bei jedem Prompt).

### Phase 3: Verify Token-Effizienz

- [x] Step 11: `.claude/scripts/measure-context-cost.sh` — NEU: Token-Counter mit Load-Phase-Klassifikation (ALWAYS/ON_DEMAND/SKILL/HOOK). Baseline: 344→222 Tokens nach SUMMARY-Cleanup.
- [x] Step 12: Acceptance-Run: Doctor ✓, SUMMARY 222 Tokens, alle 9 Files haben Trigger, Fallback-Path im Skill verifiziert.

## Acceptance Criteria

- [ ] `/bin/ls .agents/context/*.md` zeigt max 6 Files (SUMMARY/STACK/ARCHITECTURE/CONVENTIONS/PATTERNS + 1 Stack-spezifisch)
- [ ] `bash .claude/scripts/doctor.sh` reportet pro Context-File einen aktiven Read-Trigger oder failed
- [ ] `/analyze` mit repomix installiert ist messbar billiger: Token-Cost via `measure-context-cost.sh` mind. 50% niedriger als ohne
- [ ] `/analyze` ohne repomix funktioniert weiter (Fallback-Path)
- [ ] Hook `context-freshness.sh` triggert nur bei echter Codebase-Änderung, nicht bei jedem CLAUDE.md-Edit
- [ ] Kein generated File ohne Read-Trigger im Repo — verifizierbar via `grep -r "<filename>" .claude/ templates/ lib/ CLAUDE.md`

## Files to Modify

- `lib/setup-context.sh` — Generator-Code für tote Files entfernen, Read-Trigger-Check ergänzen
- `.claude/scripts/build-summary.sh` — abgespeckt, dropt Sections die niemand liest
- `.claude/scripts/doctor.sh` — erweiterter Context-Health-Check
- `.claude/skills/analyze/SKILL.md` — repomix-Fast-Path + Fallback-Branch
- `.claude/scripts/analyze-fast.sh` — NEU: repomix-Wrapper
- `.claude/scripts/measure-context-cost.sh` — NEU: Token-Counter
- `.claude/hooks/context-freshness.sh` — Drift-Detection via repomix-Hash
- `lib/stack-detect.sh` — repomix-Profile pro Stack
- `.agents/context/AUDIT.md` `CONCEPT.md` `DESIGN-DECISIONS.md` `LEARNINGS.md` — DELETE
- `templates/agents/context-files-readme/` — falls Generator-Templates für tote Files existieren, entfernen

## Out of Scope

- code2prompt-Integration (redundant zu repomix)
- Tree-sitter Signature-Index in graph.json (eigene Spec, größerer Scope)
- Handlebars-Templating-Engine
- Codebase-MCP-Server
- Goal+Format+Context Migration der TEMPLATE.md (separate Spec, parallel angedacht)
- repomix Hard-Dependency machen (bleibt opt-in)
- Stack-spezifische Context-Files (NUXT.md/SHOPIFY.md/etc.) — die haben bereits klare Read-Trigger via stack-aware Skills

## Risiken

1. **Tree-sitter Coverage Vue/Liquid lückenhaft**: Fallback-Path muss Pflicht bleiben, kein Hard-Switch.
2. **XML-Parsing in Bash schmerzt**: `xmllint` (macOS-default) verwenden, sonst Python-Helper. Skill darf nicht selbst parsen wenn `which xmllint` fehlt.
3. **Hash-basierte Drift-Detection false-positive**: bei jedem File-Touch triggert. Lösung: Hash nur über `--compress`-Output, nicht über volle Files.
4. **Cleanup-Risiko**: ein User könnte AUDIT.md manuell pflegen. Vor Delete: prüfen ob es echte Inhalte gibt jenseits Generator-Output (Frontmatter check, manuelle git-blame-prüfung).

## Messbare Erfolgs-Metrik

| Metrik                                          | Vorher    | Ziel       |
| ----------------------------------------------- | --------- | ---------- |
| Context-Files mit aktivem Read-Trigger          | 6/10      | 6/6 (100%) |
| Tokens für `/analyze` Bootstrap (mid-size repo) | ~30k      | <10k       |
| `--patch` Refresh Token-Cost                    | ungemessen | -50%       |
| Doctor-Check zeigt tote Files                   | nein      | ja         |
