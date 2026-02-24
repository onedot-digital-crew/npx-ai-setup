# Spec: Performance-Reviewer und Test-Generator Agent-Templates

> **Spec ID**: 029 | **Created**: 2026-02-24 | **Status**: completed

## Goal
Zwei neue universelle Agent-Templates hinzufuegen: `perf-reviewer` (Performance-Analyse) und `test-generator` (Test-Generierung).

## Context
Die aktuellen 5 Agents decken Build, Verification, Code-Review, Staff-Review und Context ab. Es fehlen spezialisierte Agents fuer Performance-Analyse und Test-Generierung. Beide sind universell — jedes Projekt profitiert davon. `perf-reviewer` ist read-only (wie code-reviewer), `test-generator` ist der erste generative Agent mit Write-Zugriff (nur fuer Testdateien).

## Steps
- [x] Step 1: `templates/agents/perf-reviewer.md` erstellen — Sonnet, Tools: Read/Glob/Grep/Bash, read-only. Prueft: N+1 Queries, Memory Leaks, unnoetige Re-Renders, Bundle-Groesse, langsame DB-Queries, ineffiziente Loops. Output: FAST/CONCERNS/SLOW Verdict mit Findings.
- [x] Step 2: `templates/agents/test-generator.md` erstellen — Sonnet, Tools: Read/Write/Glob/Grep/Bash, max_turns: 20. Analysiert geaenderte Dateien via `git diff`, identifiziert ungetestete Pfade, generiert Tests im bestehenden Test-Framework des Projekts. Guardrail: darf NUR Dateien in test/tests/__tests__/spec-Verzeichnissen schreiben.
- [x] Step 3: Beide Agents im Format der bestehenden Templates (Frontmatter + Behavior + Output Format + Rules). Konsistenz mit code-reviewer.md und build-validator.md sicherstellen.
- [x] Step 4: Smoke-Test: `./bin/ai-setup.sh` im Trockenlauf pruefen — TEMPLATE_MAP erkennt `templates/agents/*.md` automatisch, kein Eingriff in ai-setup.sh noetig.

## Acceptance Criteria
- [x] `perf-reviewer.md` folgt dem bestehenden Agent-Format (Frontmatter, Behavior, Output, Rules)
- [x] `test-generator.md` hat Write-Guardrail: nur Test-Verzeichnisse beschreibbar
- [x] TEMPLATE_MAP erkennt beide neuen Agents ohne Code-Aenderung in ai-setup.sh
- [x] Bestehende Agents bleiben unveraendert

## Files to Modify
- `templates/agents/perf-reviewer.md` — neues Agent-Template
- `templates/agents/test-generator.md` — neues Agent-Template

## Out of Scope
- Domain-spezifische Agents (React, Django, etc.)
- Aenderungen an ai-setup.sh oder TEMPLATE_MAP
- Aenderungen an bestehenden Agent-Templates
